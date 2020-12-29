import time
import xmpp


jid = xmpp.protocol.JID("sniper@localhost")
print(jid.getNode())
print(jid.getDomain())
print(jid.getResource())
connection = xmpp.Client(server=jid.getDomain(), debug=True)
connection.connect()
print(connection.isConnected())
print(connection.auth(user=jid.getNode(), password="sniper", resource=jid.getResource()))
connection.send(xmpp.protocol.Message(to="auction-item-54321@localhost", body="hello, auction!"))


def message_handler(conn, mess):
    print('got message')


connection.RegisterHandler('message', message_handler)
connection.sendInitPresence()

while True:
    pass



if False:
    def _on_signal( _client, _signal_name):
        print("signal")


    def _on_connected( _client, _signal_name):
        print("connected")
        client.send(nbxmpp.Presence())


    client = Client()
    client.set_domain("localhost")
    client.set_username("sniper@localhost")
    client.set_password("sniper")
    #client.set_resource(AUCTION_RESOURCE)
    client.set_ignore_tls_errors(True)
    client.subscribe('resume-failed', _on_signal)
    client.subscribe('resume-successful', _on_signal)
    client.subscribe('disconnected', _on_signal)
    client.subscribe('connection-lost', _on_signal)
    client.subscribe('connection-failed', _on_signal)
    client.subscribe('connected', _on_connected)
    #client.register_handler(StanzaHandler('message', _on_message))

    client.connect()

    while True:
        print(client.state)
        time.sleep(1)