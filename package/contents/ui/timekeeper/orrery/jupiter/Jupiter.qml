import QtQuick 2.1

Item {
    id: jupiter;

    width: 24
    height: 24

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
        source: "./jupiter_big.png"

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