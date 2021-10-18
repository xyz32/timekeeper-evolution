import QtQuick 2.1

Item {
    id: jupiter;

    width: 24
    height: 24

    Component.onCompleted: {
    }

    Image {
        anchors.fill: parent

        smooth: true
        source: "./jupiter.png"

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
