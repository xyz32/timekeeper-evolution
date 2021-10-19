import QtQuick 2.1

//moon
import "moon"

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
        moon.setDateTime(date);

        var offest   = date.getTimezoneOffset();
        var hours    = date.getHours();
        var minutes  = date.getMinutes();

        earth.rot = (hours * earth.framesPerHour + Math.round((minutes + offest) / earth.framesPerMin)) % earth.earthNumFrames;

        moon.planetTrueAnomaly = 180 + 12.41 * moon.phase;
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
        id: terra
        anchors.fill: parent

        smooth: true
        source: "./earth_big.png" //"./animation/earth"+ rot + ".png"

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

    Moon {
        id: moon

        property int planetoffset: 10
        property int planetTrueAnomaly: 0

        x: terra.x + (terra.width / 2) - (moon.width / 2)
        y: terra.y + (terra.height / 2) - (moon.height / 2) + planetoffset

        transform: Rotation {
            origin.x: moon.width / 2
            origin.y: moon.height / 2 - moon.planetoffset
            angle: moon.planetTrueAnomaly
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
    }
}
