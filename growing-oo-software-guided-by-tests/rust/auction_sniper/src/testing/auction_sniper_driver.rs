use crate::{SniperCommand, SniperIO};
use std::sync::mpsc::{channel, Receiver, Sender};
use std::sync::{Arc, Mutex};

pub struct AuctionSniperDriver {
    command_tx: Mutex<Sender<SniperCommand>>,
    command_rx: Mutex<Receiver<SniperCommand>>,
    output_tx: Mutex<Sender<String>>,
    output_rx: Mutex<Receiver<String>>,
}

impl AuctionSniperDriver {
    pub fn new() -> Self {
        let (ctx, crx) = channel();
        let (otx, orx) = channel();
        AuctionSniperDriver {
            command_tx: Mutex::new(ctx),
            command_rx: Mutex::new(crx),
            output_tx: Mutex::new(otx),
            output_rx: Mutex::new(orx),
        }
    }

    pub fn shows_sniper_status(&self, status_text: &str) {
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
