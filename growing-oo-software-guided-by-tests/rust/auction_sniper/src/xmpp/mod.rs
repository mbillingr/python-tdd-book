mod chat;
pub use chat::Chat;

pub struct Message {
    pub text: String,
    pub who: String,
}
