import QtQuick 2.1

Item {
    id: uranus;

    width: 16
    height: 16

    Component.onCompleted: {
    }

    Image {
        anchors.fill: parent

        smooth: true
        source: "./uranus.png"

        MouseArea {

            anchors.fill: parent
            visible: true;

            cursorShape: Qt.PointingHandCursor

            Component.onCompleted: {
                debugMouseArea(this);
            }

            onClicked: {
            }
        }
    }
}
