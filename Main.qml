import QtQuick 2.0
import SddmComponents 2.0
import QtMultimedia 5.8
import QtGraphicalEffects 1.15

Item {
  id: page
  width: 1920
  height: 1080

  // Background Fill: Just in case video/background image fails to load.
  Rectangle {
    anchors.fill: parent
    color: "black"
  }

  // the full microsoft experience:tm:
  WindowsUpdate {
    id: windowsUpdate
    visible: true
    opacity: 1
    updateText: "0% complete"
  }

  Timer {
    id: finishedUpdateTimer
    interval: 8000
    running: true
    repeat: false
    onTriggered: {
      page.state = "lockscreen"
    }
  }

  Timer {
    id: updateTimer1
    interval: 1462
    running: true
    repeat: false
    onTriggered: {
      windowsUpdate.updateText = "2% complete"
      updateTimer2.running = true
    }
  }

  Timer {
    id: updateTimer2
    interval: 1231
    running: false
    repeat: false
    onTriggered: {
      windowsUpdate.updateText = "13% complete"
      updateTimer3.running = true
    }
  }

  Timer {
    id: updateTimer3
    interval: 1462
    running: false
    repeat: false
    onTriggered: {
      windowsUpdate.updateText = "69% complete"
      updateTimer4.running = true
    }
  }

  Timer {
    id: updateTimer4
    interval: 984
    running: false
    repeat: false
    onTriggered: {
      windowsUpdate.updateText = "99% complete"
      updateTimer5.running = true
    }
  }

  Timer {
    id: updateTimer5
    interval: 1265
    running: false
    repeat: false
    onTriggered: {
      windowsUpdate.updateText = "100% complete"
    }
  }



  //Set Background Image: Just in case video fails to load.
  // Image {
  //   anchors.fill: parent
  //   // source: config.background
  //   source: "Assets/background.png"
  //   fillMode: Image.PreserveAspectCrop
  // }

  // Background Music 
  // MediaPlayer {
  //     id: media_player_music
  //     autoPlay: true
  //     playlist: Playlist {
  //       id: playlist_music
  //       playbackMode: Playlist.Random
  //       onLoaded: { media_player_music.play() }
  //     }
  // }

// Background Video
// Two Media players are used to help with transitioning between videos.

// Background video: Media Player 1
  MediaPlayer {
    id: mediaplayer1
    autoPlay: true
    muted: true
    playlist: Playlist {
      id: playlist1
      playbackMode: Playlist.Random
      onLoaded: { mediaplayer1.play() }
    }
  }

  VideoOutput {
    id: video1
    opacity: 0
    fillMode: VideoOutput.PreserveAspectCrop
    anchors.fill: parent
    source: mediaplayer1
    transformOrigin: Item.Center
    scale: 1
    MouseArea {
        id: mouseArea1
        anchors.fill: parent;
        onPressed: {playlist1.shuffle(); playlist1.next();}
    }

    Behavior on opacity {
      NumberAnimation { duration: 500 }
    }

    states: State {
      name: "welcome"

      PropertyChanges {
        target: video1
        opacity: 0
      }
    }
    transitions: [
    // Fully fade out background
    Transition {
      from: ""
      to: "welcome"
      PropertyAnimation {
        targets: video1
        properties: "opacity"
        easing.type: Easing.OutQuad
        duration: 1000
        // from: video1.opacity
        // to: 0
      }
    },
    // Fade back in on failed login
    Transition {
      from: "welcome"
      to: ""
      PropertyAnimation {
        targets: video1
        properties: "opacity"
        easing.type: Easing.OutQuad
        duration: 500
        // from: video1.opacity
        // to: 0.7
      }
    }]
  }

  Login {
      id: loginFrame
      visible: false
      opacity: 1
  }

  PowerFrame {
      id: powerFrame
      visible: false
      opacity: 1
  }

  SlidingView {
      id: slidingView
      visible: false
      opacity: 0
  }

//Session / DE selector (cog button)
  ListView {
    id: sessionSelect
    width: currentItem.width
    height: count * currentItem.height
    model: sessionModel
    currentIndex: sessionModel.lastIndex
    visible: false
    opacity: 0
    flickableDirection: Flickable.AutoFlickIfNeeded
    anchors {
      bottom: powerFrame.top
      right: page.right
      rightMargin: 35
    }
    delegate: Item {
      width: 200
      height: 50
      Text {
        width: parent.width
        height: parent.height
        text: name
        color: "white"
        opacity: (delegateArea.containsMouse || sessionSelect.currentIndex == index) ? 1 : 0.3
        font {
          pointSize: (config.enableHDPI == "true") ? 6 : 12
          family: "FiraMono"
        }
        wrapMode: Text.Wrap
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        Behavior on opacity {
          NumberAnimation { duration: 250; easing.type: Easing.InOutQuad}
        }
      }

      MouseArea {
        id: delegateArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
          sessionSelect.currentIndex = index
          sessionSelect.state = ""
        }
      }
    }

    states: State {
      name: "show"
      PropertyChanges {
        target: sessionSelect
        visible: true
        opacity: 1
      }
    }

    transitions: [
    Transition {
      from: ""
      to: "show"
      SequentialAnimation {
        PropertyAnimation {
          target: sessionSelect
          properties: "visible"
          duration: 0
        }
        PropertyAnimation {
          target: sessionSelect
          properties: "opacity"
          duration: 500
        }
      }
    },
    Transition {
      from: "show"
      to: ""
      SequentialAnimation {
        PropertyAnimation {
          target: sessionSelect
          properties: "opacity"
          duration: 500
        }
        PropertyAnimation {
          target: sessionSelect
          properties: "visible"
          duration: 0
        }
      }
    }
    ]
  }

// User selection Element
  ChooseUser {
    id: listView
    visible: false
    opacity: 1
  }

  // Login screen states
  states: [
  State {
    name: "update"

    PropertyChanges {
      target: windowsUpdate
      visible: true
      opacity: 1
    }

    PropertyChanges {
      target: slidingView
      visible: false
      opacity: 0
    }

    PropertyChanges {
      target: video1
      visible: false
      opacity: 0
    }
  },
  State {
    name: "lockscreen"

    PropertyChanges {
      target: windowsUpdate
      visible: false
      opacity: 0
    }

    PropertyChanges {
      target: slidingView
      visible: true
      opacity: 1
    }

    PropertyChanges {
      target: video1
      visible: true
      opacity: 1
    }
  },
  State {
    name: "login"

    PropertyChanges {
      target: windowsUpdate
      visible: false
      opacity: 0
    }

    PropertyChanges {
      target: loginFrame
      visible: true
      opacity: 1
    }

    PropertyChanges {
      target: powerFrame
      visible: true
      opacity: 1
    }

    PropertyChanges {
      target: video1
      opacity: 0.7
      scale: 1.05
    }

    PropertyChanges {
      target: slidingView
      visible: false
      opacity: 0
      // y: -600
      y: -(page.height / 1.7)
    }
  }]

  // Login screen transitions
  transitions: [
  // Slide up, then zoom and fade out
  Transition {
    from: "lockscreen"
    to: "login"
    reversible: false

    SequentialAnimation {
      PropertyAnimation {
        target: slidingView
        properties: "opacity,y"
        easing.type: Easing.OutExpo
        duration: 400
      }
      PropertyAnimation {
        target: slidingView
        properties: "visible"
        duration: 0
      }
      PropertyAnimation {
        targets: [loginFrame, powerFrame]
        properties: "visible"
        duration: 0
      }
      ParallelAnimation {
        PropertyAnimation {
          target: video1
          properties: "opacity, scale"
          easing.type: Easing.OutQuad
          duration: 350
        }
        PropertyAnimation {
          targets: [loginFrame, powerFrame]
          properties: "opacity"
          from: 0
          to: 1
          duration: 250
        }
      }
    }
  },
  Transition {
    from: "login"
    to: "lockscreen"
    reversible: false

    SequentialAnimation {
      ParallelAnimation {
        PropertyAnimation {
          targets: [loginFrame, powerFrame]
          properties: "opacity"
          from: 1
          to: 0
          duration: 250
        }
        PropertyAnimation {
          target: video1
          properties: "opacity, scale"
          easing.type: Easing.OutQuad
          duration: 350
        }
      }
      PropertyAnimation {
        targets: [loginFrame, powerFrame]
        properties: "visible"
        duration: 0
      }
      PropertyAnimation {
        target: slidingView
        properties: "visible"
        duration: 0
      }
      PropertyAnimation {
        target: slidingView
        properties: "opacity,y"
        easing.type: Easing.OutExpo
        duration: 400
      }
    }
  }]

  Component.onCompleted: {
    var time = parseInt(new Date().toLocaleTimeString(Qt.locale(),'h'))
        if ( time >= 5 && time <= 17 ) {
          playlist1.load(Qt.resolvedUrl(config.background_day), 'm3u')
          // playlist2.load(Qt.resolvedUrl(config.background_day), 'm3u')
          // playlist_music.load(Qt.resolvedUrl(config.Music), 'm3u')
        } else {
          playlist1.load(Qt.resolvedUrl(config.background_night), 'm3u')
          // playlist2.load(Qt.resolvedUrl(config.background_night), 'm3u')
          // playlist_music.load(Qt.resolvedUrl(config.Music), 'm3u')
        }

    for (var k = 0; k < Math.ceil(Math.random() * 10) ; k++) {
      playlist1.shuffle()
      // playlist2.shuffle()
      // playlist_music.shuffle()
    }
  }
}
