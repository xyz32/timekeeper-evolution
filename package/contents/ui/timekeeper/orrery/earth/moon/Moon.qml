import QtQuick 2.15
import "phase.js" as Luna

Item {
    id: moon
    width: 80
    height: 80

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
        mipmap: true
        source: "moonUnderShadow.png"
    }

    Image {
        sourceSize.width:  parent.width
        sourceSize.height: parent.height

        smooth: true
        mipmap: true
        source: "luna_" + phase + ".svg"
    }
}
