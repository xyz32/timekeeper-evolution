import QtQuick 2.1

Item {
    id: mars;

    width: 13
    height: 13

    Component.onCompleted: {
    }

    Image {
        anchors.fill: parent

        smooth: true
        source: "./mars.png"

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
