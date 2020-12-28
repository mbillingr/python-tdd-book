use std::sync::mpsc::Receiver;
use std::time::Duration;

pub struct SingleMessageListener<T> {
    rx: Receiver<T>,
}

impl<T> SingleMessageListener<T> {
    pub fn new(rx: Receiver<T>) -> Self {
        SingleMessageListener { rx }
    }

    pub fn receives_a_message(&self) {
        assert!(self.rx.recv_timeout(Duration::from_secs(50)).is_ok())
    }
}
