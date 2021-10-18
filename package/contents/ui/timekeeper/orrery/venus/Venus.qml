import QtQuick 2.1

Item {
    id: venus;

    width: 15
    height: 15

    Component.onCompleted: {
    }

    Image {
        anchors.fill: parent

        smooth: true
        source: "./venus.png"

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
