import QtQuick
import QtQuick.Controls
import org.kde.kirigami as Kirigami
import Qt5Compat.GraphicalEffects
import QtQuick.Layouts 1.2
import org.kde.plasma.core 2.0 as PlasmaCore
import "components"

Rectangle {
    id: root
    width: 640
    height: 480
    LayoutMirroring.enabled: Qt.locale().textDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true
    property bool dialogVisible: true
    signal exitDialogs
    TextConstants {
        id: textConstants
    }

    // hack for disable autostart QtQuick.VirtualKeyboard
    Loader {
        id: inputPanel
        property bool keyboardActive: false
        source: "components/VirtualKeyboard.qml"
    }

    onExitDialogs: {
        panel.clickExit()
        dialogVisible = false
    }

    Connections {
        target: sddm
        onLoginSucceeded: {

        }
        onLoginFailed: {
            password.placeholderText = textConstants.loginFailed
            password.placeholderTextColor = "white"
            password.text = ""
            password.focus = false
            errorMsgContainer.visible = true
        }
    }

    Image {
        id: wallpaper
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop

        Binding on source {
            when: config.background !== undefined
            value: config.background
        }
    }
    StackView {
        id: mainStack
        anchors.centerIn: parent
        height: parent.height / 2
        width: parent.width / 3

        focus: false //StackView is an implicit focus scope, so we need to give this focus so the item inside will have it

        Timer {
            //SDDM has a bug in 0.13 where even though we set the focus on the right item within the window, the window doesn't have focus
            //it is fixed in 6d5b36b28907b16280ff78995fef764bb0c573db which will be 0.14
            //we need to call "window->activate()" *After* it's been shown. We can't control that in QML so we use a shoddy timer
            //it's been this way for all Plasma 5.x without a huge problem
            running: true
            repeat: false
            interval: 200
            onTriggered: password.forceActiveFocus()
        }
    }

    Clock {
        width: parent.width
        height: 150
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            exitDialogs()
        }
    }
    Panel {
        id: panel
        width: 98
        height:24
        anchors.right: parent.right
    }

    ListModel {
        id: colorModel

        ListElement {
            normal: "#3689e6"
            light: "#6aa9ff"
        }

        ListElement {
            normal: "#28bca3"
            light: "#5ad4b9"
        }

        ListElement {
            normal: "#ed5353"
            light: "#ff7b7b"
        }

        ListElement {
            normal: "#485a6c"
            light: "#7a8c9e"
        }

        ListElement {
            normal: "#a56de2"
            light: "#c895f5"
        }

        ListElement {
            normal: "#f9c440"
            light: "#ffd86e"
        }

        ListElement {
            normal: "#17a2b8"
            light: "#4dc4d8"
        }

        ListElement {
            normal: "#ffffff"
            light: "#2d2d2d"
        }
    }

    ListView {
        id: carouselView
        width: originalWidth
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: 300
        model: userModel
        //visible: false
        orientation: Qt.Horizontal
        spacing: 10
        snapMode: ListView.SnapOneItem
        currentIndex: 0

        property int originalWidth: (parent.width/2) + 150

        // Animación para el desplazamiento
        Behavior on contentX {
            NumberAnimation {
                duration: 600 // Duración de la animación en milisegundos
                easing.type: Easing.InOutQuad // Tipo de easing para suavizar la animación
            }
        }

        delegate: Delegate {
            width: 300
            height: carouselView.currentIndex === model.index ? 300 : 240
            active: carouselView.currentIndex === model.index
            anchors.verticalCenter: parent.verticalCenter
            colorBackground: colorModel.get(colorModel.count < model.index ? model.index % colorModel.count : model.index).light
            colorDegrad: colorModel.get(colorModel.count < model.index ? model.index % colorModel.count : model.index).normal
            nameUser: model.name
            img: model.icon
            isCurrent: false
            dialogAveilable: dialogVisible
            onExitSessionMenu: {
                if (isVisible) {
                    console.log("señal trabajando",isVisible, dialogAveilable, dialogVisible)
                    dialogVisible = isVisible
                    dialogAveilable = dialogVisible
                }

            }
            MouseArea {
                anchors.fill: carouselView
                onClicked: {
                    exitDialogs()
                }
            }
            MouseArea {
                width: parent.width
                height: 240
                onClicked: {
                    exitDialogs()
                    carouselView.currentIndex = model.index
                    carouselView.width = carouselView.originalWidth + (model.index * 300)
                }
            }
            onDestroyDialogs: {
                exitDialogs()
            }

        }
    }

}
