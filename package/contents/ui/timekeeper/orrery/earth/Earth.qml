import QtQuick 2.1

Item {
    id: earth;

    property int rot: 0
    property int earthNumFrames: 96
    property int framesPerHour: earthNumFrames / 24
    property int framesPerMin: 60 / framesPerHour

    width: 15
    height: 15

    Component.onCompleted: {
    }

    function setDateTime(date) {
        var offest   = date.getTimezoneOffset();
        var hours    = date.getHours();
        var minutes  = date.getMinutes();

        earth.rot = (hours * earth.framesPerHour + Math.round((minutes + offest) / earth.framesPerMin)) % earth.earthNumFrames;
    }

    Image {
        anchors.fill: parent

        smooth: true
        source: "./animation/earth"+ rot + ".png"

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
