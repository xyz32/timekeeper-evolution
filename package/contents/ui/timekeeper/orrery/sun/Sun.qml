import QtQuick 2.1

Item {
    id: sun;

    width: 28
    height: 28

    Component.onCompleted: {
    }

    Image {
        anchors.fill: parent

        smooth: true
        source: "./sun.png"

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
