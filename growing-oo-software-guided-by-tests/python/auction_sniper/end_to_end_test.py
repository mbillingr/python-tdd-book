from unittest import TestCase
from threading import Thread
from PyQt5 import QtWidgets
import pytest
from nbxmpp.connection import Connection
from nbxmpp.client import Client
from nbxmpp.structs import StanzaHandler
from queue import Queue, Empty as QueueEmpty
from hamcrest import *


class Main:
    STATUS_JOINING = 'joining'


class MainWindow(QtWidgets.QMainWindow):
    def __init__(self, xmpp_hostname, sniper_id, sniper_password, item_id,
                 parent=None):
        super().__init__(parent)
        self.setLayout(QtWidgets.QHBoxLayout())
        self.layout().addWidget(QtWidgets.QLabel(Main.STATUS_JOINING))


##########################################################################

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
        self.client = None
        self.messageListener = SingleMessageListener()

    def startSellingItem(self):
        if self.client is None:
            self.createClient()

        self.client.connect()

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
        self.client.register_handler(
            StanzaHandler('message', self._on_message))

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
        main_window = MainWindow(XMPP_HOSTNAME, self.SNIPER_ID,
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
