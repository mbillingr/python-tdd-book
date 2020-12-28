mod chat;
pub use chat::Chat;
use std::sync::mpsc::Sender;

pub struct Message {
    pub text: String,
    pub who: String,
}

pub trait MessageListener: 'static + Send {
    fn process_message(&self, msg: Message);
}

impl MessageListener for Sender<Message> {
    fn process_message(&self, msg: Message) {
        self.send(msg).unwrap()
    }
}

impl MessageListener for () {
    fn process_message(&self, _: Message) {}
}
