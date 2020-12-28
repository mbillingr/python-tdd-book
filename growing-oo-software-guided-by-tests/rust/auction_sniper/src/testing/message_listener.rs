use std::sync::mpsc::Receiver;
use std::time::Duration;

pub type Message = String;

pub struct SingleMessageListener {
    rx: Receiver<Message>,
}

impl SingleMessageListener {
    pub fn new(rx: Receiver<Message>) -> Self {
        SingleMessageListener { rx }
    }

    pub fn receives_a_message(&self) {
        assert!(self.rx.recv_timeout(Duration::from_secs(5)).is_ok())
    }
}
