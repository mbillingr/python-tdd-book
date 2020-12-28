fn main() {
    println!("Hello, world!");
}

pub fn sniper_main(
    _xmpp_hostname: &str,
    _sniper_id: &str,
    _sniper_password: &str,
    mut io: impl SniperIO,
) -> Result<(), ()> {
    loop {
        let _ = io.get_command();
        io.update("STATUS: joining");
    }
}

const STATUS_JOINING: &str = "joining";
const STATUS_LOST: &str = "lost";

pub trait SniperIO {
    fn get_command(&mut self) -> SniperCommand;
    fn update(&mut self, text: &str);
}

pub enum SniperCommand {
    Update,
}

#[cfg(test)]
mod auction_sniper_end_to_end_tests {
    use crate::*;
    use std::cell::RefCell;
    use std::sync::mpsc::{channel, Receiver, Sender, TryRecvError};
    use std::sync::{Arc, Mutex};
    use std::thread;
    use std::thread::JoinHandle;
    use std::time::Duration;

    const XMPP_HOSTNAME: &str = "localhost";

    #[test]
    fn sniper_joins_auction_until_auction_closes() {
        let mut auction = FakeAuctionServer::start_selling_item("item-54321");

        let application = ApplicationRunner::start_bidding_in(&auction);
        auction.has_received_join_request_from_sniper();

        auction.announce_closed();
        application.shows_sniper_has_lost_auction();

        auction.stop();
    }

    struct ApplicationRunner {
        driver: Arc<AuctionSniperDriver>,
    }

    impl ApplicationRunner {
        fn sniper_id() -> &'static str {
            "sniper"
        }

        fn sniper_password() -> &'static str {
            "sniper"
        }

        fn start_bidding_in(auction: &FakeAuctionServer) -> Self {
            let driver = Arc::new(AuctionSniperDriver::new());

            let thread_driver = driver.clone();

            let thread = thread::Builder::new()
                .name("Test Application".to_string())
                .spawn(|| {
                    crate::sniper_main(
                        XMPP_HOSTNAME,
                        Self::sniper_id(),
                        Self::sniper_password(),
                        thread_driver,
                    )
                    .unwrap()
                })
                .unwrap();

            driver.shows_sniper_status(STATUS_JOINING);

            ApplicationRunner { driver }
        }

        fn shows_sniper_has_lost_auction(&self) {
            self.driver.shows_sniper_status(STATUS_LOST);
        }
    }

    struct AuctionSniperDriver {
        command_tx: Mutex<Sender<SniperCommand>>,
        command_rx: Mutex<Receiver<SniperCommand>>,
        output_tx: Mutex<Sender<String>>,
        output_rx: Mutex<Receiver<String>>,
    }

    impl AuctionSniperDriver {
        fn new() -> Self {
            let (ctx, crx) = channel();
            let (otx, orx) = channel();
            AuctionSniperDriver {
                command_tx: Mutex::new(ctx),
                command_rx: Mutex::new(crx),
                output_tx: Mutex::new(otx),
                output_rx: Mutex::new(orx),
            }
        }

        fn shows_sniper_status(&self, status_text: &str) {
            self.send_command(SniperCommand::Update);
            let output = self.get_output();
            let idx = output.find("STATUS:").unwrap();
            assert!(
                output[idx..].starts_with(&format!("STATUS: {}", status_text)),
                format!("sniper does not show status {:?}", status_text)
            );
        }

        fn send_command(&self, cmd: SniperCommand) {
            self.command_tx.lock().unwrap().send(cmd).unwrap()
        }

        fn get_output(&self) -> String {
            self.output_rx.lock().unwrap().recv().unwrap()
        }
    }

    impl SniperIO for Arc<AuctionSniperDriver> {
        fn get_command(&mut self) -> SniperCommand {
            self.command_rx.lock().unwrap().recv().unwrap()
        }

        fn update(&mut self, text: &str) {
            self.output_tx
                .lock()
                .unwrap()
                .send(text.to_string())
                .unwrap()
        }
    }

    struct FakeAuctionServer {
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

            let message_handler =
                move |_ctx: &libstrophe::Context,
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

            let mut conn =
                libstrophe::Connection::new(libstrophe::Context::new_with_default_logger());
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

        fn stop(self) {
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

        fn has_received_join_request_from_sniper(&self) {
            self.message_listener.receives_a_message()
        }

        fn announce_closed(&self) {
            self.send_message("auction closed".to_string())
        }
    }

    type Message = String;

    trait MessageListener {
        fn process_message(&self, message: Message);
    }

    struct SingleMessageListener {
        rx: Receiver<Message>,
        message: RefCell<Option<Message>>,
    }

    impl SingleMessageListener {
        pub fn new(rx: Receiver<Message>) -> Self {
            SingleMessageListener {
                rx,
                message: Default::default(),
            }
        }

        pub fn receives_a_message(&self) {
            assert!(self.rx.recv_timeout(Duration::from_secs(5)).is_ok())
        }
    }
}
