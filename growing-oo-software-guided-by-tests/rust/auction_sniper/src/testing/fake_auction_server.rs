use crate::testing::SingleMessageListener;
use crate::xmpp::{Chat, Message};
use std::sync::mpsc::channel;

pub struct FakeAuctionServer {
    item_id: String,
    chat: Chat,
    message_listener: SingleMessageListener<Message>,
}

impl FakeAuctionServer {
    pub fn start_selling_item(item_id: &str) -> Self {
        let jid = Self::item_id_as_login(item_id);
        let pass = Self::auction_password();

        let (tx, rx) = channel();

        FakeAuctionServer {
            item_id: item_id.to_string(),
            chat: Chat::new(&jid, pass, "sniper@localhost", tx),
            message_listener: SingleMessageListener::new(rx),
        }
    }

    fn send_message(&self, msg: impl ToString) {
        self.chat.send(msg.to_string());
    }

    pub fn stop(self) {
        self.chat.stop()
    }

    fn item_id_as_login(id: &str) -> String {
        format!("auction-{}@localhost", id)
    }

    pub fn item_id(&self) -> &str {
        &self.item_id
    }

    /*fn auction_resource() -> &'static str {
        "Auction"
    }*/

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
