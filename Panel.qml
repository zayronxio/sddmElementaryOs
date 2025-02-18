import QtQuick
import "components" as Components
import org.kde.kirigami as Kirigami

Item {
    signal clickExit
    ListModel {
        id: power
        ListElement {
            name: "Shudown"
        }
        ListElement{
            name: "Restart"
        }
        ListElement {
            name: "Sleep"
        }
    }

    onClickExit: {
        powerMenu.visible = false
    }

    DialogCard {
        id: powerMenu
        width: 96
        height: 100
        visible: false
        anchors.top: panel.bottom
        anchors.left: parent.left
        anchors.leftMargin: - ((width/2) - 12)

        Item {
            id: bg
            width: parent.width
            height: listSession.height
            anchors.centerIn: parent

            ListView {
                id: listSession
                width: parent.width - Kirigami.Units.largeSpacing * 2
                model: power
                height: (Kirigami.Units.gridUnit *1.5) * sessionModel.count
                anchors.centerIn: parent
                interactive: false // Desactiva el scroll para que todo el contenido sea visible

                delegate: Item {
                    width: parent.width
                    height: 22
                    Kirigami.Heading {
                        id: text
                        width: parent.width
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        text: model.name
                        level: 5
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (model.name === "Shudown") {
                                sddm.powerOff()
                            } else if (model.name === "Restart") {
                                sddm.reboot()
                            } else if (model.name === "Sleep") {
                                sddm.suspend()
                            }
                            powerMenu.visible = false
                        }
                    }
                }
            }
        }
    }
    Row {
        id: panel
        spacing: Kirigami.Units.mediumSpacing
        //anchors.right: parent.right
        width: parent.width
        height: 24

        Kirigami.Icon {
            id: iconPower
            width: 24
            height: 24
            isMask: true
            color: "white"
            source: Qt.resolvedUrl("images/shutdown.svg")
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    powerMenu.visible = !powerMenu.visible
                }
            }
        }
        Components.Battery {
            height: 24
            width: 24
        }


    }
}

