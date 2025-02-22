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

    property bool dialogVisible: false
    property int currentElement
    property var faces: ["faces/fakeWallpaper0.webp", "faces/fakeWallpaper1.webp", "faces/fakeWallpaper2.webp", "faces/fakeWallpaper3.webp", "faces/fakeWallpaper4.webp", "faces/fakeWallpaper5.webp"]

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
        //tooltip.showTooltip("This is a tooltip message!")
        dialogVisible = false
        panel.clickExit()
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

    Clock {
        width: parent.width
        height: 150
        anchors.top: parent.top
        anchors.topMargin: 32
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
            img: (model.icon).includes("face.icon") ? Qt.resolvedUrl(faces[model.index % 5]) : model.icon
            isCurrent: model.index === model.lastUser
            isFocused: carouselView.currentIndex === model.index
            dialogBool: !dialogVisible ? false : dialogAveilable

            property bool dialogAveilable: false

            onExitSessionMenu: {
                currentElement = model.index
                dialogAveilable = isVisible
                dialogVisible = isVisible
                if (isVisible) {
                    timer.start()
                } else {
                    timer.stop()
                }

            }
            Timer {
                id: timer
                interval: 50
                running: false
                repeat: true
                onTriggered: {
                    dialogBool = !dialogVisible ? false : dialogAveilable
                }
            }

            onDialogBoolChanged: {
                if (!dialogBool) {
                    timer.stop()
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
            onError: {
                tooltip.showTooltip("Error, please verify your password!")
            }

        }
    }

    TooltipError {
        id: tooltip
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Kirigami.Units.largeSpacing*2
    }

}
