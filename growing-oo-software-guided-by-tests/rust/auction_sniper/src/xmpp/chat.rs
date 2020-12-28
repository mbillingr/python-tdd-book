use super::Message;
use libstrophe::{Connection, Stanza};
use std::sync::mpsc::{channel, Sender, TryRecvError};
use std::thread;
use std::thread::JoinHandle;
use std::time::Duration;

pub struct Chat {
    jid: String,
    output_channel: Sender<Message>,
    thread: JoinHandle<()>,
}

impl Chat {
    pub fn new(jid: &str, pass: &str, listener: Sender<Message>) -> Self {
        let (otx, orx) = channel::<Message>();

        let message_handler = move |_ctx: &libstrophe::Context,
                                    _conn: &mut libstrophe::Connection,
                                    stanza: &libstrophe::Stanza| {
            let body = match stanza.get_child_by_name("body") {
                Some(body) => body,
                None => return true,
            };

            match stanza.stanza_type() {
                Some(typ) => {
                    if typ == "error" {
                        return true;
                    }
                }
                None => return true,
            };

            let intext = body.text().expect("Cannot get body");

            let msg = Message {
                text: intext,
                who: stanza.from().expect("Cannot get from").to_string(),
            };
            listener.send(msg).unwrap();

            true
        };

        let conn_handler = |ctx: &libstrophe::Context,
                            conn: &mut libstrophe::Connection,
                            evt: libstrophe::ConnectionEvent| {
            match evt {
                libstrophe::ConnectionEvent::Connect => {
                    eprintln!("Connected");
                    let pres = libstrophe::Stanza::new_presence();
                    conn.send(&pres);
                }
                libstrophe::ConnectionEvent::Disconnect(err) => {
                    eprintln!("Disconnected, Reason: {:?}", err);
                    ctx.stop();
                }
                _ => unimplemented!(),
            }
        };

        let mut conn = libstrophe::Connection::new(libstrophe::Context::new_with_default_logger());
        conn.set_jid(jid);
        conn.set_pass(pass);
        conn.set_flags(libstrophe::ConnectionFlags::TRUST_TLS)
            .unwrap();
        conn.handler_add(message_handler, None, Some("message"), None)
            .unwrap();
        conn.timed_handler_add(
            move |ctx: &libstrophe::Context, conn: &mut Connection| {
                match orx.try_recv() {
                    Ok(msg) if msg.text == "/stop/" => ctx.stop(),
                    Ok(msg) => {
                        let mut stanza = Stanza::new_message(Some("chat"), None, Some(&msg.who));
                        stanza.set_body(&msg.text).unwrap();
                        conn.send(&stanza)
                    }
                    Err(TryRecvError::Empty) => {}
                    Err(TryRecvError::Disconnected) => return false,
                }
                true
            },
            Duration::from_millis(1),
        )
        .unwrap();
        let ctx = conn
            .connect_client(None, None, conn_handler)
            .expect("Cannot connect to XMPP server");

        let thread = thread::Builder::new()
            .name("Fake Auction Server".to_string())
            .spawn(move || {
                ctx.run();
            })
            .unwrap();

        Chat {
            jid: jid.to_string(),
            output_channel: otx,
            thread,
        }
    }

    pub fn send_message(&self, msg: Message) {
        self.output_channel.send(msg).unwrap()
    }

    pub fn send(&self, text: String) {
        self.output_channel
            .send(Message {
                text,
                who: self.jid.clone(),
            })
            .unwrap()
    }

    pub fn stop(self) {
        self.send("/stop/".to_string());
        self.thread.join().unwrap();
    }
}
