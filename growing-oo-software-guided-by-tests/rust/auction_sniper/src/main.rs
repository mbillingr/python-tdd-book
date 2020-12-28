use crate::xmpp::Chat;
use std::collections::HashMap;

pub mod testing;
pub mod xmpp;

fn main() {
    println!("Hello, world!");
}

struct Main;

impl Main {
    pub fn main(
        xmpp_hostname: &str,
        sniper_id: &str,
        sniper_password: &str,
        item_id: &str,
        io: impl SniperIO,
    ) {
        let jid = &format!("{}@{}", sniper_id, xmpp_hostname);
        let chat = Chat::new(
            jid,
            sniper_password,
            &Self::auction_id(item_id, xmpp_hostname),
            (),
        );
        chat.send("hi");
        Main::start_user_interface(io);
        chat.stop()
    }

    pub fn start_user_interface(io: impl SniperIO) {
        MainWindow::new(io).run_event_loop()
    }

    fn auction_id(item_id: &str, xmpp_hostname: &str) -> String {
        format!("auction-{}@{}", item_id, xmpp_hostname)
    }
}

struct MainWindow<T: SniperIO> {
    labels: HashMap<&'static str, &'static str>,
    io: T,
}

impl<T: SniperIO> MainWindow<T> {
    fn new(io: T) -> Self {
        let mut labels = HashMap::new();
        labels.insert("STATUS", STATUS_JOINING);
        MainWindow { labels, io }
    }

    fn run_event_loop(&mut self) {
        loop {
            let _ = self.io.get_command();
            let output = self.create_output();
            self.io.update(&output);
        }
    }

    fn create_output(&self) -> String {
        let mut output = String::new();

        for (label, value) in &self.labels {
            output += &format!("{}: {}", label, value);
        }

        output
    }
}

pub const STATUS_JOINING: &str = "joining";
pub const STATUS_LOST: &str = "lost";

pub trait SniperIO {
    fn get_command(&mut self) -> SniperCommand;
    fn update(&mut self, text: &str);
}

pub enum SniperCommand {
    Update,
}

#[cfg(test)]
mod auction_sniper_end_to_end_tests {
    use crate::testing::{ApplicationRunner, FakeAuctionServer};

    #[test]
    fn sniper_joins_auction_until_auction_closes() {
        //SimpleLogger::new().init().unwrap();

        let auction = FakeAuctionServer::start_selling_item("item-54321");

        let application = ApplicationRunner::start_bidding_in(&auction);
        auction.has_received_join_request_from_sniper();

        auction.announce_closed();
        application.shows_sniper_has_lost_auction();

        application.stop();
        auction.stop();
    }
}
