import QtQuick 2.1
import "phase.js" as Luna

Item {
    id: moon
    width: 5
    height: 5

    property int phase: 28;
    property real degreesPerPhase: 12.41

    Component.onCompleted: {
    }

    function setDateTime(date) {
        Luna.touch(date)
        var age = Math.round(Luna.AGE)
        if( age === 0 || age === 30 ) {
            moon.phase = 29
        } else {
            moon.phase = age
        }
    }

    Image {
        x: 0
        y: 2
        width: parent.width
        height: parent.height

        smooth: true
        source: "moonUnderShadow.png"
    }

    Image {
        sourceSize.width:  parent.width
        sourceSize.height: parent.height

        smooth: true;
        source: "luna_" + phase + ".svg"

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