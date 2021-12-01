import QtQuick 2.3

Item {
    id: sun;

    width: 48
    height: 48

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
