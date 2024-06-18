import QtQuick 2.0

Item {
  id: slidingView
  width: page.width
  height: page.height

  x: 0
  y: 0

  Timer {
      id: time
      interval: 100
      running: true
      repeat: true

      onTriggered: {
          timeText.text = Qt.formatTime(new Date(), "h:mm                                                                                                                 a") //thank you qt
          dateText.text = Qt.formatDate(new Date(), "dddd, MMMM d")
      }
  }

  // Date and time
  Item {
    id: clock

    anchors.left: parent.left
    anchors.bottom: parent.bottom

    Text {
      id: timeText
      // y: parent.height * config.relativePositionY - clock.height / 2
      // x: parent.width * config.relativePositionX - clock.width / 2

      anchors.left: parent.left
      anchors.bottom: parent.bottom
      anchors.leftMargin: 50
      anchors.bottomMargin: 160

      horizontalAlignment: Text.AlignRight

      color: "white"
      font.family: "Segoe UI Light"
      font.bold: false
      font.pixelSize: 150
    }

    Text {
      id: dateText
      // y: parent.height * config.relativePositionY - clock.height / 2
      // x: parent.width * config.relativePositionX - clock.width / 2
      anchors.left: parent.left
      anchors.bottom: parent.bottom
      anchors.leftMargin: 50
      anchors.bottomMargin: 120
      horizontalAlignment: Text.AlignRight

      color: "white"
      font.family: "Segoe UI Light"
      font.bold: false
      font.pixelSize: 48
    }

    Behavior on anchors.bottomMargin {
      NumberAnimation { duration: 500 }
    }

    Behavior on opacity {
      NumberAnimation { duration: 500 }
    }
  }

  // Network icon
  Image {
    id: netIcon
    width: 24
    height: 24
    opacity: 1
    source: "Assets/WiFi.ico"
    anchors {
      right: slidingView.right
      bottom: slidingView.bottom
      rightMargin: 48
      bottomMargin: 48
    }
  }
}
