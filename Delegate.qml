import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import org.kde.kirigami as Kirigami

Item {
    property string nameUser: "Adolfo"
    property bool active: true
    property string img: Qt.resolvedUrl("faces/fakeWallpaper4.webp")
    property bool isCurrent: true
    property color colorBackground: "#FACE64"
    property color colorDegrad: "#F9C442"
    property bool dialogBool: false
    property bool isFocused: false

    signal destroyDialogs

    signal exitSessionMenu(bool isVisible)

    signal error()

    onDialogBoolChanged: {
        sessionMenu.visible = dialogBool
    }

    Component.onCompleted: {
        if(isFocused) {
            Qt.callLater(() => password.forceActiveFocus())
        }

    }

    Kirigami.Card {
        anchors.fill: parent
        banner {
            id: banner
            source: img
            implicitHeight: parent.height * .60// Ajustar la altura del banner
            fillMode: Image.PreserveAspectCrop
            titleAlignment: Qt.AlignLeft | Qt.AlignBottom
        }
        Logo {
            id: logo
            one: colorBackground
            two: colorDegrad
            width: parent.width*.26
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: banner.implicitHeight -height/2
        } Logo {
            width: 24
            isText: false
            one: "#68ACF3"
            two: "#4584E3"
            height: width
            visible: isCurrent
            anchors.right: logo.right
            //anchors.rightMargin: - width/3
            anchors.bottom: logo.bottom
            //anchors.bottomMargin: - height/2
        }
        contentItem: Item {
            anchors.fill: parent
            Text {
                id: usr
                width: parent.width
                anchors.top: parent.top
                anchors.topMargin: (parent.width*.26)/2 + Kirigami.Units.largeSpacing
                font.pointSize: 16
                horizontalAlignment:  Text.AlignHCenter
                text: nameUser
            }
            PasswordInput {
                id: password
                anchors.top: parent.top
                anchors.topMargin: usr.implicitHeight + Kirigami.Units.largeSpacing + usr.anchors.topMargin
                anchors.left: parent.left
                anchors.leftMargin: sessionModel.count > 1 ? (parent.width - width - mesh.width - Kirigami.Units.mediumSpacing)/2 : parent.width - width
                user: nameUser
                session: listSession.currentIndex
                width: sessionModel.count > 1 ? 225 : 252
                height: 28
                visible: active
                onTextChanged: {
                    destroyDialogs()
                }
                onLoginError: {
                    error()
                }
            }

            Kirigami.Icon {
                id: mesh
                width: 24
                height: width
                anchors.left:  password.right
                anchors.leftMargin: Kirigami.Units.mediumSpacing
                anchors.verticalCenter: password.verticalCenter
                source: Qt.resolvedUrl("images/mesh.svgz")
                visible: sessionModel.count > 1 ? password.visible : false
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                            dialogBool = !dialogBool
                            exitSessionMenu(dialogBool)
                    }
                }
            }

            DialogCard {
                id: sessionMenu
                width: 175
                height: 100
                visible: dialogBool
                anchors.top: mesh.bottom
                anchors.horizontalCenter: mesh.horizontalCenter

                Item {
                    id: bg
                    width: parent.width
                    height: listSession.height
                    anchors.centerIn: parent

                    ListView {
                        id: listSession
                        width: parent.width - Kirigami.Units.largeSpacing * 2
                        model: sessionModel
                        currentIndex: sessionModel.lastIndex
                        height: (Kirigami.Units.gridUnit *1.5) * sessionModel.count
                        anchors.centerIn: parent
                        interactive: false // Desactiva el scroll para que todo el contenido sea visible

                        delegate: CheckBox {
                            id: element
                            width: listSession.width
                            text: model.name
                            checked: listSession.currentIndex === model.index
                            onCheckedChanged: {
                                if (checked){
                                    listSession.currentIndex = model.index
                                }
                            }
                        }
                    }
                }
            }

        }
    }

}
