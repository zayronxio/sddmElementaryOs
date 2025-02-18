import QtQuick
import org.kde.kirigami as Kirigami

Item {

    property string textDate: abbr(getDate("d")) + " " + abbr(getDate("m")) + " " + Qt.formatDateTime(new Date(), "d");
    property string time: Qt.formatDateTime(new Date(), "h:mm");
    property color clockColor: "white"

    function getDate(type) {
        var value = type === "d" ? "dddd" : type === "m" ? "MMMM" : ""
        var date = new Date();
        var name = date.toLocaleString(Qt.locale(), value);
        return name;
    }

    function abbr(text) {
        var value = ""
        for (var u = 0; u < 3; u++) {
            value = value + text[u]
        }
        return value
    }

    Column {
        width: parent.width
        height: parent.height
        Text {
            width: parent.width
            color: clockColor
            font.pointSize: 64
            font.capitalization: Font.Capitalize
            text: time
            horizontalAlignment:  Text.AlignHCenter
        }

        Text {
            width: parent.width
            color: clockColor
            font.pointSize: 22
            horizontalAlignment:  Text.AlignHCenter
            font.capitalization: Font.Capitalize
            text: textDate
        }
    }

}
