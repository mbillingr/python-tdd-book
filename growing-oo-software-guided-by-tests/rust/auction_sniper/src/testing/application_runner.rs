use crate::testing::{AuctionSniperDriver, FakeAuctionServer};
use crate::{STATUS_JOINING, STATUS_LOST};
use std::sync::Arc;
use std::thread;
use std::thread::JoinHandle;

const XMPP_HOSTNAME: &str = "localhost";

pub struct ApplicationRunner {
    driver: Arc<AuctionSniperDriver>,
    thread: JoinHandle<()>,
}

impl ApplicationRunner {
    fn sniper_id() -> &'static str {
        "sniper"
    }

    fn sniper_password() -> &'static str {
        "sniper"
    }

    pub fn start_bidding_in(_auction: &FakeAuctionServer) -> Self {
        let driver = Arc::new(AuctionSniperDriver::new());

        let thread_driver = driver.clone();

        let thread = thread::Builder::new()
            .name("Test Application".to_string())
            .spawn(|| {
                crate::Main::main(
                    XMPP_HOSTNAME,
                    Self::sniper_id(),
                    Self::sniper_password(),
                    thread_driver,
                );
            })
            .unwrap();

        driver.shows_sniper_status(STATUS_JOINING);

        ApplicationRunner { driver, thread }
    }

    pub fn stop(self) {
        // todo: stop sniper
        self.thread.join().unwrap();
    }

    pub fn shows_sniper_has_lost_auction(&self) {
        self.driver.shows_sniper_status(STATUS_LOST);
    }
}
