import QtQuick 2.1

Item {
    id: mercury;

    width: 10
    height: 10

    Component.onCompleted: {
    }

    Image {
        anchors.fill: parent

        smooth: true
        source: "./mercury.png"

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
