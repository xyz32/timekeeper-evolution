import QtQuick 2.1

Item {
    id: uranus;

    width: 16
    height: 16

    Component.onCompleted: {
    }

    Image {
        x: 0
        y: - shadowOffset
        width: parent.width
        height: parent.height

        smooth: true
        source: "../underShadow.png"
    }

    Image {
        anchors.fill: parent

        smooth: true
        source: "./uranus_big.png"

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