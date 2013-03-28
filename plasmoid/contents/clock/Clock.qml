import QtQuick 1.1

Item {
    id: clock
    width: 182; height: 182

    property int hours
    property int minutes
    property int seconds
    property real shift


    function timeChanged() {
        var date = new Date;
        hours    = shift ? date.getUTCHours()   + Math.floor(clock.shift)  : date.getHours()
        minutes  = shift ? date.getUTCMinutes() + ((clock.shift % 1) * 60) : date.getMinutes()
        seconds  = date.getUTCSeconds();

    }

    Timer {
        interval: 100; running: true; repeat: true;
        onTriggered: clock.timeChanged()
    }

    Text {
        x: 67; y: 104
        text: Qt.formatDateTime(new Date(), "ddd")
        font.pointSize: 11
        font.family: "Engravers MT"
        color: "#333333"
    }

    Image { id: background; source: "clock.png"}

    Image { x: 77; y: 74;  source: "center.png"}  



    Image {
        x: 75; y: 29
        source: "hour.png"
        smooth: true

        transform: Rotation {
            id: hourRotation
            origin.x: 12; origin.y: 53;
            angle: (clock.hours * 30) + (clock.minutes * 0.5)
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
    }

    Image {
        x: 79; y: 13
        source: "minute.png"
        smooth: true

        transform: Rotation {
            id: minuteRotation
            origin.x: 8; origin.y: 69;
            angle: clock.minutes * 6
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
    }

    Image {
        x: 85; y: 32
        source: "second.png"
        smooth: true

        transform: Rotation {
            id: secondRotation
            origin.x: 2; origin.y: 21;
            angle: clock.seconds * 6
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
    }
}
