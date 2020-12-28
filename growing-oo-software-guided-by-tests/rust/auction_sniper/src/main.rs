pub mod testing;

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
        let auction = FakeAuctionServer::start_selling_item("item-54321");

        let application = ApplicationRunner::start_bidding_in(&auction);
        auction.has_received_join_request_from_sniper();

        auction.announce_closed();
        application.shows_sniper_has_lost_auction();

        application.stop();
        auction.stop();
    }
}
