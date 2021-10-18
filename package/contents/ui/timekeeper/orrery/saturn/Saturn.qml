import QtQuick 2.1

Item {
    id: jupiter;

    width: 34
    height: 15

    Component.onCompleted: {
    }

    Image {
        anchors.fill: parent

        smooth: true
        source: "./saturn.png"

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
