import QtQuick 2.15
import QtMultimedia 5.15

Item{
    id:clockCogs
    width: 132;
    height: 93

    state: plasmoid.configuration.cogsState

    property int ang: 0
    property bool lock: plasmoid.configuration.cogsLock

    function onTick() {
        if (!clockCogs.lock && clockCogs.state !== "hide") {
            ang = (ang + 10) % 360
        }
    }

    states: [
        State {
            name: "hide";
            PropertyChanges {
                target: clockCogs;
                x: 10;
                y: 25;
            }
        },
        State {
            name: "in";
            PropertyChanges {
                target: clockCogs;
                x: -26;
                y: 137;
            }
            when: {
                clock.state === "in" && clockCogs.state != "hide"
            }
        },
        State {
            name: "out";
            PropertyChanges {
                target: clockCogs;
                x: -5;
            }
            when: {
                clock.state === "out" && clockCogs.state != "hide"
            }
        }
    ]
    transitions: Transition {
        NumberAnimation { properties: "x"; duration: 1500 }
        NumberAnimation { properties: "y"; duration: 800  }
    }

    Item {
        id: cogItem
        x: 50
        y: -17

        Image {
            id: cogShadowImage
            x: 10
            y: 10

            width: 82
            height: 82

            source: "cogShadow.png"
            smooth: true
            mipmap: true
            transform: Rotation {
                angle: 360 - ang
                origin.x: cogShadowImage.width/2
                origin.y: cogShadowImage.height/2
                Behavior on angle {
                    SpringAnimation {
                        spring: 2
                        damping: 0.2
                        epsilon: 0.25
                        modulus: 360
                    }
                }
            }
        }

        Image {
            id: cogImage
            width: 82
            height: 82

            source: "cog.png"
            smooth: true
            mipmap: true

            transform: Rotation {
                angle: 360 - ang
                origin.x: cogImage.width/2; origin.y: cogImage.height/2;
                Behavior on angle {
                    ParallelAnimation {
                        SpringAnimation {
                            spring: 2
                            damping: 0.2
                            epsilon: 0.25
                            modulus: 360
                        }
                        ScriptAction { script: {
                                sounds.playSound(sounds.clockMechanismCogSound);
                            }
                        }
                    }
                }
            }
        }
    }

    Item {
        id: wheelItem

        Image {
            id: wheelShadowImage
            x: 10
            y: 10
            source: "wheelShadow.png"
            smooth: true
            mipmap: true
            transform: Rotation {
                angle: ang
                origin.x: wheelShadowImage.width/2; origin.y: wheelShadowImage.height/2;
                Behavior on angle {
                    SpringAnimation {
                        spring: 2
                        damping: 0.2
                        epsilon: 0.25
                        modulus: 360
                    }
                }
            }
        }

        Image {
            id: wheelImage
            source: "wheel.png"
            smooth: true
            mipmap: true
            transform: Rotation {
                angle: ang
                origin.x: wheelImage.width/2; origin.y: wheelImage.height/2;
                Behavior on angle {
                    SpringAnimation {
                        spring: 2
                        damping: 0.2
                        epsilon: 0.25
                        modulus: 360
                    }
                }
            }
        }
    }

    Image {
        x: 26
        y: 2
        source: "driveBand.png"
        smooth: true
        mipmap: true

        MouseArea {
            id: tiktak_ma
            x: 16; y: 36
            width: 14; height: 14
            cursorShape: Qt.PointingHandCursor

            Component.onCompleted: {
                debugMouseArea(this);
            }

            onClicked: {
                if(cogs.lock){
                    cogs.ang = (cogs.ang - 10) % 360
                    cogs.lock = !cogs.lock
                } else if(timekeeper.lock){
                    timekeeper.countAngle = (timekeeper.countAngle + 10) % 360
                    timekeeper.lock = !timekeeper.lock
                } else {
                    cogs.lock = true;
                    timekeeper.lock = true;

                    cogs.ang = (cogs.ang - 10) % 360
                    timekeeper.countAngle = (timekeeper.countAngle - 10) % 360;
                }
                plasmoid.configuration.timekeeprLock = timekeeper.lock
                plasmoid.configuration.cogsLock = cogs.lock
            }
        }
    }
}
