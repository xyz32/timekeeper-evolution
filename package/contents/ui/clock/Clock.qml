import QtQuick 2.1
import QtMultimedia 5.15

import "cogs"

Item {
    id: clock

    opacity: plasmoid.configuration.clockOpacity
    state: plasmoid.configuration.clockState

    property int hours
    property int minutes
    property int seconds
    property string weekDay

    property alias weekBackgroundImage: weekBackgroundImage

    states: [
        State {
            name: "out";
            PropertyChanges {
                target: clock;
                x: -9;
                y: 42;
            }
        },

        State {
            name: "in";
            PropertyChanges {
                target: clock;
                x: 29;
                y: 60;
            }
        }
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

    Cogs {
        id: cogs
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
            visible: !main.isRealTime
            color: main.nonRealTimeColour
            opacity: main.nonRealTimeOpacity
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
        color: main.textColour
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
                cogs.state = cogs.state == "hide"? clock.state : "hide";
                plasmoid.configuration.cogsState = cogs.state;
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
                main.state = main.state == "small" ? "" : "small";
                plasmoid.configuration.mainState = main.state;
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
                ParallelAnimation {
                    SpringAnimation {
                        spring: 2;
                        damping: 0.2;
                        modulus: 360
                    }
                    ScriptAction {
                        script: {
                            cogs.onTick();

                            if (clock.seconds % 2 == 0) {
                                sounds.playSound(sounds.secondsCogSoundEven);
                            } else {
                                sounds.playSound(sounds.secondsCogSoundOdd);
                            }
                        }
                    }
                }
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
                ParallelAnimation {
                    SpringAnimation {
                        spring: 2;
                        damping: 0.2;
                        modulus: 360
                    }
                    ScriptAction {
                        script: {
                            sounds.playSound(sounds.hourCogSound);
                        }
                    }
                }
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
                ParallelAnimation {
                    SpringAnimation {
                        spring: 2;
                        damping: 0.2;
                        modulus: 360
                    }
                    ScriptAction {
                        script: {
                            sounds.playSound(sounds.minutesCogSound);
                            if (clock.minutes % 60 == 0) {
                                sounds.playSound(sounds.chimeSound, ((clock.hours) % 12) || 12);
                            } else if (clock.minutes % 30 == 0) {
                                sounds.playSound(sounds.chimeSound);
                            }
                        }
                    }
                }
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
