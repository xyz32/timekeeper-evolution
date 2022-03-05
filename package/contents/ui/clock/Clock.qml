import QtQuick 2.3

import "cogs"

Item {
    id: clock

    opacity: plasmoid.configuration.clockOpacity
    state: plasmoid.configuration.clockState
    property string weekDay

    readonly property int handCenterX: 83
    readonly property int handCenterY: 83

    property double ringDegree: 0

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
                x: 31;
                y: 60;
            }
        }
    ]

    transitions: Transition {
        NumberAnimation { properties: "x"; duration: 1000 }
        NumberAnimation { properties: "y"; duration: 700  }
    }

    function setDate(date) {
        clock.weekDay = Qt.formatDateTime(date, "ddd");
    }

    Cogs {
        id: cogs
        x: -26
        y: 137
    }

    Item {
        id: clockItem

        property int ojectWidth: 164
        property int ojectHeight: 164

        Image {
            id: backgroundShadow;

            x:12
            y:12

            width: parent.ojectWidth
            height: parent.ojectHeight

            smooth: true
            mipmap: true
            source: "clockShadow.png"
        }

        Item {
            id: cloackWeekDay
            Image {
                id: weekBackgroundImage;
                x: 60
                y: 102
                width: 47
                height: 20

                smooth: true
                mipmap: true
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
        }

        Image {
            id: background;

            property point center : Qt.point(width / 2, height / 2);
            width: parent.ojectWidth
            height: parent.ojectHeight

            smooth: true
            mipmap: true
            source: "clock.png"
        }

        Image {
            id: clockTimeRing;

            x: (parent.ojectWidth / 2 - center.x)
            y: (parent.ojectHeight / 2 - center.y)

            width: 130 // 108 for inner radius
            height: 130 // 108 for inner radius

            property point center : Qt.point(width / 2, height / 2);
            property int outerRingRadius: clockTimeRing.paintedWidth / 2
            property int outerRingRadiusSquare: outerRingRadius * outerRingRadius
            property int innerRingRadius: clockTimeRing.paintedWidth / 2 - 20
            property int innerRingRadiusSquare: innerRingRadius * innerRingRadius

            smooth: true
            mipmap: true
            source: "timeRing.png"

            transform: Rotation {
                origin.x: clockTimeRing.center.x
                origin.y: clockTimeRing.center.y
                angle: {return (clock.ringDegree + 360) % 360;}
                Behavior on angle {
                    SpringAnimation {
                        spring: 2
                        damping: 0.2
                        modulus: 360
                    }
                }
            }

            MouseArea {//date cog rotation
                id: mouseRotate
                anchors.fill: parent

                property double cumulatedAngle
                property double prevAngle
                property double startAngle

                onPressed: {
                    if( inner(mouse.x, mouse.y, clockTimeRing) )
                    {
                        mouse.accepted = true;
                        var point =  mapToItem (background, mouse.x, mouse.y);
                        prevAngle = triAngle(point.x, point.y, background);

                        cumulatedAngle = 0;
                        startAngle = prevAngle;
                    } else {
                        mouse.accepted = false;
                    }
                }

                onReleased: {
                }

                onPositionChanged: {
                    var angle, delta
                    var point =  mapToItem (background, mouse.x, mouse.y);
                    if( inner(mouse.x, mouse.y, clockTimeRing) ){
                        angle = triAngle(point.x, point.y, background)

                        delta = angleDifference(angle, prevAngle);
                        cumulatedAngle += delta;
                        clock.ringDegree = (clock.ringDegree - delta) % 360;

                        if(Math.abs(cumulatedAngle) > 1) {
                            updateMinuteCounter(Math.floor(cumulatedAngle));
                            cumulatedAngle -= Math.floor(cumulatedAngle);
                        }

                        prevAngle = angle;
                    } else {
                        prevAngle = triAngle(point.x, point.y, clockTimeRing)
                    }
                }
            }
        }

        Image {
            id: buttonLeftImage

            x: 57
            y: 85

            width: 12
            height: 12

            smooth: true
            mipmap: true
            source: "button.png"

            MouseArea {
                id: inOutSwitch
                anchors.fill: parent

                cursorShape: Qt.PointingHandCursor

                Component.onCompleted: {
                    debugMouseArea(this);
                }

                onClicked: {
                    clock.state === "out" ? clock.state = "in" : clock.state = "out";
                    plasmoid.configuration.clockState = clock.state
                }
            }
        }

        Image {
            id: buttonRightImage

            x: 97
            y: 85

            width: 12
            height: 12

            smooth: true
            mipmap: true
            rotation: 180
            source: "button.png"

            MouseArea {
                id: hideClockMechanismSwitch
                anchors.fill: parent

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
            id: secondsHandImage
            x: 82 - (width / 2)
            y: 53 - height + 2

            height: 20
            fillMode: Image.PreserveAspectFit

            source: "second.png"
            smooth: true
            mipmap: true

            transform: Rotation {
                id: secondRotation
                origin.x: secondsHandImage.paintedWidth / 2
                origin.y: secondsHandImage.paintedHeight - 2
                angle: main.seconds * 6
                Behavior on angle {
                    ParallelAnimation {
                        SpringAnimation {
                            spring: 2
                            damping: 0.2
                            epsilon: 15
                            modulus: 360
                        }
                        ScriptAction {
                            script: {
                                cogs.onAnimationTick();
                                timekeeper.onAnimationTick();

                                if (main.seconds % 2 == 0) {
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

        Item {
            id: hourItem

            property int handSize: 55
            property int pivotOffset: 3

            Image {
                id: hourHandShadowImage
                x: clock.handCenterX + 2 - (width / 2)
                y: clock.handCenterY + 2 - height + hourItem.pivotOffset

                height: hourItem.handSize
                fillMode: Image.PreserveAspectFit
                smooth: true
                mipmap: true

                source: "hourShadow.png"

                transform: Rotation {
                    id: hourShadowRotation
                    origin.x: hourHandShadowImage.paintedWidth / 2
                    origin.y: hourHandShadowImage.paintedHeight - hourItem.pivotOffset
                    angle: (main.hours * 30) + (main.minutes * 0.5)
                    Behavior on angle {
                        SpringAnimation {
                            spring: 2;
                            damping: 0.2;
                            modulus: 360
                        }
                    }
                }
            }

            Image {
                id: hourHandImage
                x: clock.handCenterX - (width / 2)
                y: clock.handCenterY - height + hourItem.pivotOffset

                height: hourItem.handSize
                fillMode: Image.PreserveAspectFit
                smooth: true
                mipmap: true

                source: "hour.png"

                transform: Rotation {
                    id: hourRotation
                    origin.x: hourHandImage.paintedWidth / 2
                    origin.y: hourHandImage.paintedHeight - hourItem.pivotOffset
                    angle: (main.hours * 30) + (main.minutes * 0.5)
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

                                    if (main.seconds === 0 && main.minutes === 0) {
                                        sounds.playSound(sounds.chimeSound, ((main.hours) % 12) || 12);
                                    }
                                }
                            }
                        }
                    }
                }
            }

        }

        Item {
            id: minuteItem
            property int handSize: 68
            property int pivotOffset: 4

            Image {
                id: minuteHandShadowImage
                x: clock.handCenterX + 2 - (width / 2)
                y: clock.handCenterY + 2 - height + minuteItem.pivotOffset

                height: minuteItem.handSize
                fillMode: Image.PreserveAspectFit
                smooth: true
                mipmap: true

                source: "minuteShadow.png"

                transform: Rotation {
                    id: minuteShadowRotation
                    origin.x: minuteHandShadowImage.paintedWidth / 2
                    origin.y: minuteHandShadowImage.paintedHeight - minuteItem.pivotOffset
                    angle: main.minutes * 6
                    Behavior on angle {
                        SpringAnimation {
                            spring: 2;
                            damping: 0.2;
                            modulus: 360
                        }
                    }
                }
            }

            Image {
                id: minuteHandImage
                x: clock.handCenterX - (width / 2)
                y: clock.handCenterY - height + minuteItem.pivotOffset

                height: minuteItem.handSize
                fillMode: Image.PreserveAspectFit
                smooth: true
                mipmap: true

                source: "minute.png"

                transform: Rotation {
                    id: minuteRotation
                    origin.x: minuteHandImage.paintedWidth / 2
                    origin.y: minuteHandImage.paintedHeight - minuteItem.pivotOffset
                    angle: main.minutes * 6
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
                                    if (main.seconds === 0 && main.minutes === 30) {
                                        sounds.playSound(sounds.chimeSound);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        Item {
            id: centerItem

            x: clock.handCenterX - (ojectWidth / 2)
            y: clock.handCenterY - (ojectHeight / 2)

            property int ojectWidth: 14
            property int ojectHeight: 14

            Image {
                id: centerShadowImage
                x: 2
                y: 2
                width: parent.ojectWidth
                height: parent.ojectHeight

                smooth: true
                mipmap: true
                source: "centerShadow.png"
            }

            Image {
                id: centerImage

                width: parent.ojectWidth
                height: parent.ojectHeight

                smooth: true
                mipmap: true
                source: "center.png"

                MouseArea {
                    id: centerSwitch
                    anchors.fill: parent

                    cursorShape: Qt.PointingHandCursor

                    Component.onCompleted: {
                        debugMouseArea(this);
                    }

                    onClicked:{
                        main.state = main.state === "small" ? "" : "small";
                        plasmoid.configuration.mainState = main.state;
                    }
                }
            }
        }

        Image {
            x: 26
            y: 10

            width: 122
            height: 74

            source: "clockglass.png"
            smooth: true
            mipmap: true
        }
    }
}
