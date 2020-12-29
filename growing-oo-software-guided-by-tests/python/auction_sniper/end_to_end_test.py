from unittest import TestCase
from threading import Thread
from PyQt5 import QtWidgets
import pytest
from nbxmpp.connection import Connection
import nbxmpp
from nbxmpp.client import Client
from nbxmpp.structs import StanzaHandler
from queue import Queue, Empty as QueueEmpty
from hamcrest import *


class Main:
    STATUS_JOINING = 'joining'
    AUCTION_RESOURCE = 'Auction'
    ITEM_ID_AS_LOGIN = 'auction-{}'
    AUCTION_ID_FORMAT = ITEM_ID_AS_LOGIN + '@{}'

    def __init__(self):
        self.client = None
        self.chatManager = None
        self.chat = None

    def main(self, xmpp_hostname, sniper_id, sniper_password, item_id):
        self.connectTo(xmpp_hostname, sniper_id, sniper_password, item_id)
        main_window = MainWindow()
        return main_window

    def connectTo(self, xmpp_hostname, username, password, item_id):
        self.createClient(xmpp_hostname, username, password)
        #self.client.connect()
        #self.client.send(nbxmpp.Presence())
        self.chatManager = ChatManager(self.client)
        self.chat = self.chatManager.create_chat(self.auctionId(item_id, xmpp_hostname))

    def auctionId(self, itemId, xmpp_hostname):
        return self.AUCTION_ID_FORMAT.format(itemId, xmpp_hostname)

    def createClient(self, xmpp_hosntame, username, password):
        self.client = Client()
        self.client.set_domain(xmpp_hosntame)
        self.client.set_username(username)
        self.client.set_password(password)
        self.client.set_resource(self.AUCTION_RESOURCE)
        self.client.set_ignore_tls_errors(True)
        self.client.subscribe('connection-failed', self._on_signal)

    def _on_signal(self, _client, signal_name, *args, **kwargs):
        print('%s, Error: %s', signal_name, self.client.get_error())



class MainWindow(QtWidgets.QMainWindow):
    def __init__(self,
                 parent=None):
        super().__init__(parent)
        self.setLayout(QtWidgets.QHBoxLayout())
        self.sniperStatus = QtWidgets.QLabel(Main.STATUS_JOINING)
        self.layout().addWidget(self.sniperStatus)


##########################################################################

class ChatManager:
    def __init__(self, client):
        self.client = client
        self.client.register_handler(StanzaHandler('message', self._on_message))
        self.chats = {}

    def create_chat(self, partner_id):
        chat = Chat()
        self.chats[partner_id] = chat
        return chat

    def _on_message(self, _stream, stanza, _properties):
        print('Chat Manager Message received:')
        print(stanza.getBody())
        self.messageListener.processMessage(stanza)


class Chat:
    pass


##########################################################################


XMPP_HOSTNAME = "localhost"


def test_sniperJoinsAuctionUntilAuctionCloses(qtbot):
    auction = FakeAuctionServer("item-54321")
    application = ApplicationRunner(qtbot)

    try:
        auction.startSellingItem()
        application.startBiddingIn(auction)
        auction.hasReceivedJoinRequestFromSniper()
        auction.announceClosed()
        application.showsSniperHasLostAuction()

    finally:
        auction.stop()
        application.stop()


class FakeAuctionServer:
    ITEM_ID_AS_LOGIN = "auction-{}"
    AUCTION_RESOURCE = "Auction"
    XMPP_HOSTNAME = "localhost"
    AUCTION_PASSWORD = "auction"

    def __init__(self, itemId):
        self.itemId = itemId
        self.client: Client = None
        self.messageListener = SingleMessageListener()

    def startSellingItem(self):
        if self.client is None:
            self.createClient()

        print("connecting")
        self.client.connect()
        while True:
            print(self.client.state)

    def hasReceivedJoinRequestFromSniper(self):
        self.messageListener.receivesAMessage()

    def stop(self):
        pass

    def getItemId(self):
        return self.itemId

    def createClient(self):
        self.client = Client()
        self.client.set_domain(self.XMPP_HOSTNAME)
        self.client.set_username(self.ITEM_ID_AS_LOGIN.format(self.itemId))
        self.client.set_password(self.AUCTION_PASSWORD)
        self.client.set_resource(self.AUCTION_RESOURCE)
        self.client.set_ignore_tls_errors(True)
        self.client.subscribe('resume-failed', self._on_signal)
        self.client.subscribe('resume-successful', self._on_signal)
        self.client.subscribe('disconnected', self._on_signal)
        self.client.subscribe('connection-lost', self._on_signal)
        self.client.subscribe('connection-failed', self._on_signal)
        self.client.subscribe('connected', self._on_connected)
        self.client.register_handler(
            StanzaHandler('message', self._on_message))

    def _on_signal(self, _client, _signal_name):
        print("signal")

    def _on_connected(self, _client, _signal_name):
        print("connected")
        self.client.send(nbxmpp.Presence())

    def _on_message(self, _stream, stanza, _properties):
        print('Message received')
        print(stanza.getBody())
        self.messageListener.processMessage(stanza)


class SingleMessageListener:
    def __init__(self):
        self.messages = Queue(maxsize=1)

    def processMessage(self, message):
        self.messages.put(message)

    def receivesAMessage(self):
        try:
            assert_that(self.messages.get(timeout=5), is_(not_none()))
            return
        except QueueEmpty:
            pass
        pytest.fail("did not receive a message")


class ApplicationRunner:
    SNIPER_ID = "sniper"
    SNIPER_PASSWORD = "sniper"

    def __init__(self, qtbot):
        self.driver = None
        self.qtbot = qtbot

    def startBiddingIn(self, auction: FakeAuctionServer):
        main_window = Main().main(XMPP_HOSTNAME, self.SNIPER_ID,
                                  self.SNIPER_PASSWORD, auction.getItemId())
        self.driver = AuctionSniperDriver(main_window, self.qtbot)
        self.driver.showsSniperStatus(Main.STATUS_JOINING)

    def showsSniperHasLostAuction(self):
        self.driver.showsSniperStatus(Main.STATUS_LOST)

    def stop(self):
        if self.driver is not None:
            self.driver.dispose()


class AuctionSniperDriver:
    def __init__(self, mainWindow, qtbot):
        self.qtbot = qtbot
        self.main_window = mainWindow
        qtbot.addWidget(mainWindow)

    def showsSniperStatus(self, statusText):
        for label in self.main_window.findChildren(QtWidgets.QLabel):
            if label.text() == statusText:
                return
        pytest.fail(f'Found no label with "{statusText}"')

    def dispose(self):
        pass
