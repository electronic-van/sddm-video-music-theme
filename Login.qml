import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

Item {
  id: loginFrame

  width: page.width
  height: page.height
  anchors.horizontalCenter: page.horizontalCenter
  anchors.verticalCenter: page.verticalCenter

  property string name
  property string realName
  property string icon
  focus: false 

  Behavior on opacity {
    NumberAnimation { duration: 500; easing.type: Easing.InOutQuad }
  }

  //Functions:

  //Login with current details
  function login() {
    video1.state = "welcome"
    passwordBox.visible = false;
    welcome.visible = true;
    powerFrame.visible = false;
    loginTimer.start();
  }

  //Goes back to user select
  function back() {
    passwordInput.text = ""
    page.state = "lockscreen";
    listView.focus = true;
  }

  function focusPassword() {
    passwordInput.focus = true;
  }

  KeyNavigation.tab: passwordInput
  Keys.onEscapePressed: back()

  // Waits for animation to complete
  Timer {
    id: loginTimer
    interval: 4000
    running: false
    repeat: false
    onTriggered: sddm.login(loginFrame.name, passwordInput.text, sessionSelect.currentIndex)
  }

  Connections {
    target: sddm
    onLoginSucceeded: {
    }

    onLoginFailed: {
      video1.state = "login"
      passwordInput.text = ""
      welcome.visible = false
      passwordStatus.visible = true
      passwordBox.visible = false
      incorrectPasswordButton.focus = true
    }
  }

  states: State {
      name: "active"
      // when: passwordInput.activeFocus == true || passwordInput.text != ""
      when: passwordInput.text != ""

      PropertyChanges {
        target: defaultPasswordText
        opacity: 0
      }

      PropertyChanges {
        target: submitPassword
        opacity: 1
      }

      // PropertyChanges {
      //   target: passwordUnderline
      //   height: 32
      // }
  }

  //Back Button
  Image {

    anchors {
      right: userProfile.left
      rightMargin: 30
    }
    y: parent.height / 2
    opacity: 0
    width: 32
    height: 32
    source: "Assets/Selector.png"
    transform: Rotation { origin.x : 16; origin.y: 16; angle: 270}

    MouseArea {
      anchors.fill: parent
      onClicked: {
        loginFrame.back();
      }
    }
  }

  // Profile picture
  Item {
    id: userProfile

    width: 200
    height: 350

    y:0
    anchors {
      horizontalCenter: parent.horizontalCenter
      top: parent.verticalCenter
      // verticalCenter: parent.verticalCenter
      topMargin: -228
    }

    //User's Name
    Text {
      id: usersName

      color: "white"
      font {
       family: "Segoe UI Light"
        pointSize: 36
      }
      text: loginFrame.realName
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: usersPic.bottom
      anchors.topMargin: 10
    }

    //User's Profile Pic
    Image {
      id: usersPic
      width: 192
      height: 192

      anchors {
        // bottom: usersName.top
        // topMargin: 50
        horizontalCenter: parent.horizontalCenter
      }
      source: loginFrame.icon

      property bool rounded: true
      property bool adapt: true

      layer.enabled: rounded
      layer.effect: OpacityMask {
        maskSource: Item {
          width: usersPic.width
          height: usersPic.height
          Rectangle {
            anchors.centerIn: parent
            width: usersPic.adapt ? usersPic.width : Math.min(usersPic.width, usersPic.height)
            height: usersPic.adapt ? usersPic.height : width
            radius: Math.min(width, height)
          }
        }
      }
    }
  }

  // Welcome
  Row {
    id: welcome
    visible: false
    opacity: 1
    spacing: 8

    AnimatedSprite {
      id: loadingSprite
      source: "Assets/loading_spritesheet.png"
      frameWidth: 32
      opacity: 1
      frameHeight: 32
      frameCount: 85
      frameDuration: 50
    }
    Text {
      id: welcomeText

      text: "Welcome"
      color: "white"
      font {
        pointSize: 18
        family: "Segoe UI"
      }
    }
    anchors {
      horizontalCenter: passwordBox.horizontalCenter
      top: passwordBox.top
      topMargin: -10
    }
  }

  // Password box
  Item {
    id: passwordBox
    visible: true

    width: 292
    height: 32
    anchors {
      horizontalCenter: parent.horizontalCenter
      top: userProfile.bottom
      topMargin: -55
    }

    Rectangle {
      id: passwordUnderline
      width: passwordBox.width - 31
      height: 32
      anchors {
        bottom: passwordBox.bottom
        left: passwordBox.left
      }
      color: "white"
      opacity: 1.0
      radius: 0
    }

    Rectangle {
      id: passwordOutline
      parent: passwordUnderline

      width: 296
      height: 36
      color: "transparent"
      opacity: mouse.hovered ? 0.9 : 0.4
      radius: 0

      HoverHandler {
        id: mouse
        acceptedDevices: PointerDevice.Mouse
        cursorShape: Qt.IBeamCursor
      }

      anchors {
        bottom: parent.bottom
        left: parent.left
        bottomMargin: -border.width
        leftMargin: -border.width
      }

      border.color: "white"
      border.width: 2
    }

    Text {
      id: defaultPasswordText
      parent: passwordOutline

      anchors {
        fill: parent
        topMargin: 8
        leftMargin: 10
      }
      text: "Password"
      color: "black"
      font {
        pointSize: 10.5
        family: "Segoe UI"
      }
      opacity: 0.5
    }

    TextInput {
      id: passwordInput

      verticalAlignment: TextInput.AlignVCenter
      anchors {
        fill: parent
        leftMargin: 8
        rightMargin: 50
      }
      font {
        pointSize: 10.5
        family: "Segoe UI"
        // letterSpacing: 2
      }
      color: "black"
      echoMode:TextInput.Password
      clip: true

      onAccepted: {
        loginFrame.login()
      }
    }

    // Login button
    RoundButton {
      id: submitPasswordRect

      width: 31
      height: 32
      // color: "white"
      radius: 0
      opacity: down ? 0.5 : 0.2
      anchors.right: parent.right
      anchors.bottom: parent.bottom

      onClicked: {
        loginFrame.login()
      }
    }

    Image {
      id: submitPassword

      // x: 280
      // y: 0
      width: 16
      height: 16
      opacity: 1
      source: "Assets/RightArrow_Win10.png"
      anchors {
        right: parent.right
        bottom: parent.bottom
        rightMargin: 8
        bottomMargin: 8
      }
    }

    Behavior on opacity {
      NumberAnimation {
        duration: 500
        easing.type: Easing.InOutQuad
      }
    }
  }

  // Incorrect password text and button
  Text {
    id: passwordStatus
    opacity: 1
    visible: false

    text: "The password is incorrect. Try again."
    color: "white"
    font {
      pointSize: 10.5
      family: "Segoe UI"
    }

    anchors {
      horizontalCenter: passwordBox.horizontalCenter
      bottom: passwordBox.verticalCenter
      bottomMargin: 0
    }

    // OK button
    RoundButton {
      id: incorrectPasswordButton

      width: 120
      height: 33
      // color: "white"
      radius: 0
      opacity: down ? 0.5 : 0.2
      anchors.top: passwordStatus.bottom
      anchors.topMargin: 50
      anchors.horizontalCenter: parent.horizontalCenter

      onClicked: {
        passwordStatus.visible = false
        passwordBox.visible = true
        powerFrame.visible = true
        passwordInput.focus = true
      }
    }

    Rectangle {
      id: incorrectPasswordButtonOutlineInner

      width: 120
      height: 33
      color: "transparent"
      opacity: incorrectPasswordButton.down ? 0.0 : mouse2.hovered ? 0.5 : 0.0
      radius: 0

      HoverHandler {
        id: mouse2
        acceptedDevices: PointerDevice.Mouse
      }

      anchors {
        bottom: incorrectPasswordButton.bottom
        left: incorrectPasswordButton.left
        // bottomMargin: -border.width
        // leftMargin: -border.width
      }

      border.color: "white"
      border.width: 2
    }

    Rectangle {
      id: incorrectPasswordButtonOutlineOuter

      width: 126
      height: 39
      color: "transparent"
      opacity: incorrectPasswordButton.down ? 0.0 : incorrectPasswordButton.activeFocus ? 1.0 : 0.0
      radius: 0

      anchors {
        bottom: incorrectPasswordButton.bottom
        left: incorrectPasswordButton.left
        bottomMargin: -border.width - 1
        leftMargin: -border.width - 1
      }

      border.color: "white"
      border.width: 2
    }

    Text {
      id: incorrectPasswordButtonText
      opacity: 1

      text: "OK"
      color: "white"

      anchors {
        horizontalCenter: incorrectPasswordButton.horizontalCenter
        bottom: incorrectPasswordButton.bottom
        bottomMargin: 7
      }

      font {
        pointSize: 10.5
        family: "Segoe UI"
      }
    }
  }
}
