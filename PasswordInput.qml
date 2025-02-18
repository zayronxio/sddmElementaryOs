import QtQuick
import QtQuick.Controls
import org.kde.kirigami as Kirigami

TextField {
    id: password
    property string user
    property string session

    leftPadding: 24
    topPadding: 4
    color: "#71706F"
    echoMode: TextInput.Password

    onAccepted: sddm.login(user, password.text,
                           session)

    background: Rectangle {
        anchors.fill: parent
        anchors.centerIn: parent
        radius: 4
        border.color: "#429DE8"
        border.width: 1
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#26000000" }
            GradientStop { position: 1.0; color: "transparent" }
        }
        Kirigami.Icon {
            width: 22
            height: 22
            anchors.verticalCenter: parent.verticalCenter
            isMask: true
            color: "black"
            opacity: 0.5
            source: Qt.resolvedUrl("images/lock.svg")
        }
        Kirigami.Icon {
            width: 22
            height: 22
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: Kirigami.Units.smallSpacing
            isMask: true
            color: "black"
            opacity: 0.5
            source: Qt.resolvedUrl("images/loginGo.svg")
        }

    }

}
