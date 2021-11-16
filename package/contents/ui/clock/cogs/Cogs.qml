import QtQuick 2.3

Item{
    id:clockCogs
    width: 132;
    height: 93

    state: plasmoid.configuration.cogsState

    property int ang: 0
    property bool lock: plasmoid.configuration.cogsLock

    function onAnimationTick() {
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
        NumberAnimation {
            properties: "x"
            duration: 1500
        }
        NumberAnimation {
            properties: "y"
            duration: 800
        }
    }

    Item {
        id: cogItem
        x: 50
        y: -17

        property int ojectWidth: 82
        property int ojectHeight: 82

        Image {
            id: cogShadowImage
            x: 10
            y: 10

            width: parent.ojectWidth
            height: parent.ojectHeight

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
            width: parent.ojectWidth
            height: parent.ojectHeight

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

        property int ojectWidth: 92
        property int ojectHeight: 92

        Image {
            id: wheelShadowImage
            x: 10
            y: 10

            width: parent.ojectWidth
            height: parent.ojectHeight


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

            width: parent.ojectWidth
            height: parent.ojectHeight

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

    Item {
        id: drivebeltItem

        x: 23
        y: -5

        property int ojectWidth: 73
        property int ojectHeight: 73

        Image {
            x: 5
            y: 5

            width: parent.ojectWidth
            height: parent.ojectHeight


            source: "driveBandShadow.png"
            smooth: true
            mipmap: true
        }

        Image {

            width: parent.ojectWidth
            height: parent.ojectHeight

            source: "driveBand.png"
            smooth: true
            mipmap: true

            MouseArea {
                id: tiktak_ma
                x: 15
                y: 44
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
                        timekeeper.bigCogRingAngle = (timekeeper.bigCogRingAngle + 10) % 360
                        timekeeper.lock = !timekeeper.lock
                    } else {
                        cogs.lock = true;
                        timekeeper.lock = true;

                        cogs.ang = (cogs.ang - 10) % 360
                        timekeeper.bigCogRingAngle = (timekeeper.bigCogRingAngle - 10) % 360;
                    }
                    plasmoid.configuration.timekeeprLock = timekeeper.lock
                    plasmoid.configuration.cogsLock = cogs.lock
                }
            }
        }

    }
}
