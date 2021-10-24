import QtQuick 2.1

Item {
    id: jupiter;

    width: 24
    height: 24

    Component.onCompleted: {
    }

    function setDateTime(date) {

    }

    Image {
        x: 0 //(parent.width - parent.height) / 2
        y: - shadowOffset
        width: parent.height
        height: parent.height

        smooth: true
        source: "../underShadow.png"
    }

    Image {
        anchors.fill: parent

        smooth: true
        source: "./saturnTop.png"

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
