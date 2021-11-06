import QtQuick 2.15

Item {
    id: sun;

    width: 28
    height: 28

    Component.onCompleted: {
    }

    Image {
        anchors.fill: parent

        smooth: true
        mipmap: true
        source: "./sunTop.png"

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
