import QtQuick 2.1
import QtGraphicalEffects 1.0

import "wheels"

Item {
    id: clock
    width: 182; height: 182

    opacity: plasmoid.configuration.clockOpacity

    property int hours
    property int minutes
    property int seconds

    property string weekDay

    property alias weekBackgroundImage: weekBackgroundImage

    states: [
        State { name: "out"; PropertyChanges { target: clock; x: -9; y: 42; } },
        State { name: "in";  PropertyChanges { target: clock; x: 29; y: 60; } }
    ]

    transitions: Transition {
        NumberAnimation { properties: "x"; duration: 1000 }
        NumberAnimation { properties: "y"; duration: 700  }
    }

    function setTime(date) {
        clock.hours    = date.getHours();
        clock.minutes  = date.getMinutes();
        clock.seconds  = date.getSeconds();
    }

    function setDate(date) {
        clock.weekDay = Qt.formatDateTime(date, "ddd");
    }

    Wheels {
        id: whell
        x: -26;y: 137;
    }

    Image {
        id: weekBackgroundImage;
        x: 65;
        y: 102;
        width: 45;
        height: 20
        smooth: true
        source: "textBackground.png"

        Rectangle {
            id: rectangleWeekBackgroundImage
            anchors.fill: weekBackgroundImage
            visible: !timekeeper.isRealTime
            color: timekeeper.nonRealTimeColour
            opacity: timekeeper.nonRealTimeOpacity
        }
    }

    Text {
        anchors.fill: weekBackgroundImage

        text: clock.weekDay

        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter

        font.pointSize: 9
        font.family: fixedFont.name
        font.bold: true
        color: "#333333"
    }

    Image {
        id: background;
        z: 5
        smooth: true
        source: "clock.png"

        MouseArea {
            id: inOutSwitch
            x: 62; y: 86
            z: 7
            width: 11; height: 12
            cursorShape: Qt.PointingHandCursor

            Component.onCompleted: {
                debugMouseArea(this);
            }

            onClicked: {
                clock.state === "out" ? clock.state = "in" : clock.state = "out";
                plasmoid.configuration.clockState = clock.state
            }
        }

        MouseArea {
            id: hideClockMechanismSwitch
            x: 101; y: 86
            z: 7
            width: 11; height: 12
            cursorShape: Qt.PointingHandCursor

            Component.onCompleted: {
                debugMouseArea(this);
            }

            onClicked: {
                whell.hide = !whell.hide
                plasmoid.configuration.whellState = whell.hide
            }
        }
    }

    Image {
        x: 77
        y: 74
        z: 5
        smooth: true
        source: "center.png"

        MouseArea {
            id: centerSwitch
            x: 3
            y: 3
            z: 7
            width: 14
            height: 14
            cursorShape: Qt.PointingHandCursor

            Component.onCompleted: {
                debugMouseArea(this);
            }

            onClicked:{
            }
        }
    }

    Image {
        x: 75; y: 29; z: 5
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
        x: 79; y: 13; z: 5
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
        x: 85; y: 32; z: 5
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

    Image {
        x: 26; y
        : 10;
        z: 5;
        source: "clockglass.png"
        smooth: true
    }
}
