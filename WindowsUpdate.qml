import QtQuick 2.0

Rectangle {
  id: windowsUpdate
  // TODO: get color from config
  color: "#005c9f"
  anchors.fill: parent
  property alias updateText: updateText2.text

  Item {
    id: windowsUpdateFrame
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter

    AnimatedSprite {
      id: updateSprite
      source: "Assets/update_spritesheet_edited.png"
      scale: 1
      opacity: 1
      frameWidth: 64
      frameHeight: 64
      frameCount: 275
      frameDuration: 16
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.bottom: updateText1.top
    }

    Text {
      id: updateText1
      color: "white"
      font.family: "Segoe UI"
      font.pointSize: 18
      text: "Working on updates"
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: updateText1.bottom
    }

    Text {
      id: updateText2
      color: "white"
      font.family: "Segoe UI"
      font.pointSize: 18
      text: "0% complete"
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: updateText1.bottom
    }

    Text {
      id: updateText3
      color: "white"
      font.family: "Segoe UI"
      font.pointSize: 18
      text: "Don't turn off your computer"
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: updateText2.bottom
    }
  }
}
