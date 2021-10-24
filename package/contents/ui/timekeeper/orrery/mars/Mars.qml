import QtQuick 2.1

Item {
    id: mars;

    width: 13
    height: 13

    Component.onCompleted: {
    }

    function setDateTime(date) {

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
        source: "./marsTop.png"

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
