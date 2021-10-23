import QtQuick 2.1
import QtMultimedia 5.15

Item{
    id:clockCogs
    property int ang: 0
    property bool hide: false
    property bool lock: false

    width: 132; height: 93

    function setDateTime(date) {
        if (!clockCogs.lock) {
            ang = (ang + 10) % 360
        }
    }

    state: "in"

    states: [
        State {
            name: "hide"; PropertyChanges { target: clockCogs; x: 10;  y: 25; }
            when: hide
        },
        State {
            name: "in";   PropertyChanges { target: clockCogs; x: -26; y: 137; }
            when: {clock.state === "in" && !hide}
        },
        State {
            name: "out";  PropertyChanges { target: clockCogs; x: -5; }
            when: {clock.state === "out" && !hide}
        }
    ]
    transitions: Transition {
        NumberAnimation { properties: "x"; duration: 1500 }
        NumberAnimation { properties: "y"; duration: 800  }
    }

    Image {
        id: cogShadow
        x: 43; y: -5;
        source: "cogShadow.png"
        smooth: true;
        transform: Rotation {
            angle: 360 - ang
            origin.x: cogShadow.width/2; origin.y: cogShadow.height/2;
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
    }
    Image {
        id: cog
        x: 50; y: -17;
        width: 82; height: 84;
        source: "cog.png"
        smooth: true;

        SoundEffect {
            id: wheelCogSound
            source: "clockWheelCog.wav"
        }

        transform: Rotation {
            angle: 360 - ang
            origin.x: cog.width/2; origin.y: cog.height/2;
            Behavior on angle {
                ParallelAnimation {
                    SpringAnimation {
                        spring: 2;
                        damping: 0.2;
                        modulus: 360
                    }
                    ScriptAction { script: {
                            playSound(wheelCogSound);
                        }
                    }
                }
            }
        }
    }
    Image {
        id: wheelShadow
        x: 3; y: 2;
        source: "wheelShadow.png"
        smooth: true;
        transform: Rotation {
            angle: ang
            origin.x: wheelShadow.width/2; origin.y: wheelShadow.height/2;
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
    }
    Image {
        id: wheel
        source: "wheel.png"
        smooth: true;
        transform: Rotation {
            angle: ang
            origin.x: wheel.width/2; origin.y: wheel.height/2;
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
    }
    Image {
        x: 26
        y: 2
        source: "driveBand.png"
        smooth: true

        MouseArea {
            id: tiktak_ma
            x: 16; y: 36
            width: 14; height: 14
            cursorShape: Qt.PointingHandCursor

            Component.onCompleted: {
                debugMouseArea(this);
            }

            onClicked: {
                if(!wheels.lock){
                    wheels.ang = -10
                    wheels.lock = !wheels.lock
                } else if(!timekeeper.lock){
                    timekeeper.countAngle = 10
                    timekeeper.lock = !timekeeper.lock
                } else {
                    wheels.lock = !wheels.lock
                    timekeeper.lock = !timekeeper.lock

                    wheels.ang = 0
                    calendar.cogAngle = 0
                    timekeeper.countAngle = 0
                }
                plasmoid.configuration.calendarLock = timekeeper.lock
                plasmoid.configuration.whellLock = wheels.lock
            }
        }
    }
}
