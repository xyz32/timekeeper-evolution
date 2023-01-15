import QtQuick 2.3

Item {
    id: sun;

    width: 48
    height: 48

    property double rotation: 0;

    Component.onCompleted: {
    }

    function setDateTime(date) {
        var seconds = date.getTime() / 1000;

        rotation = 360 - (seconds * 0.0001666) % 360; // 0.0001666 averege deg per seconds sun rotation
    }

    Image {
        anchors.fill: parent

        smooth: true
        mipmap: true
        source: "./sunTop.png"

        transform: Rotation {
            origin.x: width / 2
            origin.y: height / 2
            angle: rotation
        }

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
