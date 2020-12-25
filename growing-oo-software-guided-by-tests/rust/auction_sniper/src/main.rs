fn main() {
    println!("Hello, world!");
}


#[cfg(test)]
mod auction_sniper_end_to_end_tests {


    #[test]
    fn sniper_joins_auction_until_auction_closes() {
        // startup
        let mut auction = FakeAuctionServer("item-54321");
        let mut application = ApplicationRunner::new();

        auction.start_selling_item();
        application.start_bidding_in(auction);
        auction.has_received_join_request_from_sniper();
        auction.announce_closed();
        application.shows_sniper_has_lost_auction();

        // cleanup
        // todo: this will not be called on panics (i.e. assertion errors).
        //       Could be put into Drop::drop, or may not be needed at all?
        auction.stop();
        application.stop();
    }
}
