use crate::testing::{Message, SingleMessageListener};
use std::sync::mpsc::{Sender, TryRecvError};
use std::thread;
use std::thread::JoinHandle;
use std::time::Duration;

pub struct FakeAuctionServer {
    item_id: String,
    thread: JoinHandle<()>,
    message_listener: SingleMessageListener,
    message_sender: Sender<Message>,
}

impl FakeAuctionServer {
    pub fn start_selling_item(item_id: &str) -> Self {
        use libstrophe::{Connection, Stanza};

        //SimpleLogger::new().init().unwrap();

        let jid = Self::item_id_as_login(item_id);
        let pass = Self::auction_password();

        let (tx, rx) = std::sync::mpsc::channel::<String>();
        let message_listener = SingleMessageListener::new(rx);

        let (out_tx, out_rx) = std::sync::mpsc::channel::<String>();

        let message_handler = move |_ctx: &libstrophe::Context,
                                    conn: &mut libstrophe::Connection,
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

            tx.send(intext.clone()).unwrap();

            eprintln!(
                "Incoming message from {}: {}",
                stanza.from().expect("Cannot get from"),
                intext
            );

            let mut reply = stanza.reply();
            if reply.stanza_type().is_none() {
                reply.set_stanza_type("chat").expect("Cannot set type");
            }

            let (quit, replytext) = if intext == "quit" {
                (true, "bye!".to_owned())
            } else {
                (false, format!("{} to you too!", intext))
            };
            reply.set_body(replytext).expect("Cannot set body");

            conn.send(&reply);

            if quit {
                conn.disconnect();
            }

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
                match out_rx.try_recv() {
                    Ok(msg) if msg == "/stop/" => ctx.stop(),
                    Ok(msg) => {
                        let mut stanza =
                            Stanza::new_message(Some("chat"), None, Some("sniper@localhost"));
                        stanza.set_body(&msg).unwrap();
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

        FakeAuctionServer {
            item_id: item_id.to_string(),
            thread,
            message_listener,
            message_sender: out_tx,
        }
    }

    fn send_message(&self, msg: impl Into<Message>) {
        self.message_sender.send(msg.into()).unwrap()
    }

    pub fn stop(self) {
        self.send_message("/stop/");
        self.thread.join().unwrap();
    }

    fn item_id_as_login(id: &str) -> String {
        format!("auction-{}@localhost", id)
    }

    fn auction_resource() -> &'static str {
        "Auction"
    }

    fn auction_password() -> &'static str {
        "auction"
    }

    pub fn has_received_join_request_from_sniper(&self) {
        self.message_listener.receives_a_message()
    }

    pub fn announce_closed(&self) {
        self.send_message("auction closed".to_string())
    }
}
