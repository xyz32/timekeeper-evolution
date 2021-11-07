import QtQuick 2.3

Item {
    id: calendarView

    opacity: plasmoid.configuration.calendarOpacity
    state: plasmoid.configuration.calendarState

    property string day: "31"
    property string month: "NOV"
    property string shortYear: "54"
    property string fullYear: "1854"

    property int cogAngle: 0

    states: [
        State {
            name: "out"
            PropertyChanges {
                target: calendarView
                x: 345
                y: 186
            }
            PropertyChanges {
                target: cogAnimationTimer
                dirrection: 1
            }

            PropertyChanges {
                target: lookingGlassImageRotation
                angle: 90
            }

            PropertyChanges {
                target: lookingGlassShadowImageRotation
                angle: 90
            }
        },
        State {
            name: "in"
            PropertyChanges {
                target: calendarView
                x: 285
                y: 186
            }
            PropertyChanges {
                target: cogAnimationTimer
                dirrection: -1
            }

            PropertyChanges {
                target: lookingGlassImageRotation
                angle: 0
            }

            PropertyChanges {
                target: lookingGlassShadowImageRotation
                angle: 0
            }
        }
    ]

    transitions: [
        Transition {
            SequentialAnimation {
                PropertyAction {
                    target: cogAnimationTimer
                    property: "running"
                    value: "true"
                }
                NumberAnimation {
                    properties: "x"
                    duration: 1000
                }
                PropertyAction {
                    target: cogAnimationTimer
                    property: "running"
                    value: "false"
                }
            }
        }
    ]

    function setDateTime(date) {
        var dtime = Qt.formatDateTime(date, "dd,MMM,yy,yyyy")
        var now = dtime.toString().split(",")
        calendar.day = now[0]
        calendar.month = now[1]
        calendar.shortYear = now[2]
        calendar.fullYear = now[3]
    }

    Item {
        id: cogWithShadow
        x: 29
        y: 13

        Image {
            id: cogShadowImage
            x: 4
            y: 4
            width: 84
            height: 84

            source: "monthCogShadow.png"

            smooth: true
            mipmap: true

            transform: Rotation {
                angle: {return (cogAngle + 360) % 360;}
                origin.x: cogShadowImage.width / 2
                origin.y: cogShadowImage.height / 2
                Behavior on angle {
                    SpringAnimation {
                        spring: 2
                        damping: 0.2
                        epsilon: 2
                        modulus: 360
                    }
                }
            }
        }

        Image {
            id: cogImage
            x: 0
            y: 0
            width: 84
            height: 84

            source: "monthCog.png"

            smooth: true
            mipmap: true

            transform: Rotation {
                angle: {return (cogAngle + 360) % 360;}
                origin.x: cogImage.width / 2
                origin.y: cogImage.height / 2
                Behavior on angle {
                    SpringAnimation {
                        spring: 2;
                        damping: 0.2;
                        modulus: 360
                    }
                }
            }
        }

        Timer {
            id: cogAnimationTimer
            property int angleStep: 12
            property int dirrection: 1
            triggeredOnStart: true
            interval: 20
            repeat: true
            onTriggered: {
                cogAngle += angleStep * dirrection
            }
        }
    }

    Item {
        id: calendarFrame
        state: plasmoid.configuration.calendarGlassState

        states: [
            State {
                name: "infoTransparent"

                PropertyChanges {
                    target: monthBackground
                    opacity: main.glassOpacity
                }
                PropertyChanges {
                    target: dayBackground
                    opacity: main.glassOpacity
                }
                PropertyChanges {
                    target: yearBackground
                    opacity: main.glassOpacity
                }

                PropertyChanges {
                    target: clock.weekBackgroundImage
                    opacity: main.glassOpacity
                }
            },

            State {
                name: "infoOpaque"

                PropertyChanges {
                    target: monthBackground
                    opacity: 1
                }
                PropertyChanges {
                    target: dayBackground
                    opacity: 1
                }
                PropertyChanges {
                    target: yearBackground
                    opacity: 1
                }

                PropertyChanges {
                    target: clock.weekBackgroundImage
                    opacity: 1
                }
            }
        ]

        Item {
            id: dayItem

            Image {
                id: dayBackground
                x: 95
                y: 7
                width: 36
                height: 36
                smooth: true
                mipmap: true
                source: "./textBackgroundRound.png"

                Rectangle {
                    id: rectangleDayBackground
                    anchors.fill: dayBackground
                    visible: !main.isRealTime
                    color: main.nonRealTimeColour
                    opacity: main.nonRealTimeOpacity
                    radius: width * 0.5
                }
            }

            Text {
                anchors.fill: dayBackground
                text: day
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 13
                font.family: fixedFont.name
                color: main.textColour
            }
        }

        Item {
            id: monthItem

            Image {
                id: monthBackground
                x: 24
                y: 44
                width: 72
                height: 24
                smooth: true
                mipmap: true
                source: "../clock/textBackground.png"

                Rectangle {
                    id: rectangleMonthBackground
                    anchors.fill: monthBackground
                    visible: !main.isRealTime
                    color: main.nonRealTimeColour
                    opacity: main.nonRealTimeOpacity
                }
            }

            Text {
                anchors.fill: monthBackground
                text: month
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 14
                font.family: fixedFont.name
                color: main.textColour
            }
        }

        Item {
            id: yearItem
            x: 58
            y: 68
            z: -1

            state: plasmoid.configuration.yearState

            states: [
                State {
                    name: "yy"
                    PropertyChanges {
                        target: yearText
                        text: shortYear
                        x: 42
                        width: 28
                    }
                    PropertyChanges {
                        target: yearBackground
                        x: 37
                        width: 36
                    }
                    PropertyChanges {
                        target: yearFrame
                        x: 29
                        yearFormatString: "Short"
                    }
                },
                State {
                    name: "yyyy"
                    PropertyChanges {
                        target: yearText
                        text: fullYear
                        x: 3
                        width: 58
                    }
                    PropertyChanges {
                        target: yearBackground
                        x: 7
                        width: 66
                    }
                    PropertyChanges {
                        target: yearFrame
                        x: 0
                        yearFormatString: "Long"
                    }
                }
            ]

            transform: Rotation {
                id: yearFrameRotation
                axis { x: 1; y: 0; z: 0 }
                origin.x: 0
                origin.y: 0
                angle: 0
                Behavior on angle {
                    SpringAnimation {
                        spring: 4
                        damping: 0.3
                        epsilon: 2
                        modulus: 360
                        onRunningChanged: {
                            if (!running) {
                                if (yearFrameRotation.angle == 90) {
                                    yearFrameRotation.angle = 0

                                    if (yearItem.state === "yyyy")
                                        yearItem.state = "yy"
                                    else
                                        yearItem.state = "yyyy"

                                    plasmoid.configuration.yearState = yearItem.state
                                }
                            }
                        }
                    }
                }
            }

            Image {
                id: yearBackground
                x: 7
                y: 3
                width: 66
                height: 36
                smooth: true
                mipmap: true
                source: "./textBackgroundRound.png"

                Rectangle {
                    id: rectangleYearBackground
                    anchors.fill: yearBackground
                    visible: !main.isRealTime
                    color: main.nonRealTimeColour
                    opacity: main.nonRealTimeOpacity
                    radius: width * 0.5
                }
            }

            Text {
                id: yearText
                anchors.fill: yearBackground
                text: fullYear

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                font.pointSize: 14
                font.family: fixedFont.name
                color: main.textColour
            }

            Item {
                id: yearFrame

                property string yearFormatString: "Long"

                Image {
                    id: yearFrameShadowImage
                    x: 2
                    y: 2
                    smooth: true
                    mipmap: true
                    source: "./calendar" + yearFrame.yearFormatString + "YearShadow.png"
                }

                Image {
                    id: yearFrameImage
                    smooth: true
                    mipmap: true
                    source: "./calendar" + yearFrame.yearFormatString + "Year.png"
                }
            }
        }

        Image {
            id: calendarImage
            x: 0
            y: 0
            smooth: true
            mipmap: true
            source: "calendar.png"

            MouseArea {
                id: yearFormat
                x: 129
                y: 81
                width: 8
                height: 8
                cursorShape: Qt.PointingHandCursor

                Component.onCompleted: {
                    debugMouseArea(this)
                }

                onClicked: {
                    yearFrameRotation.angle = 90
                }
            }

            MouseArea {
                id: colorSwitch
                x: 131
                y: 25
                width: 9
                height: 9
                cursorShape: Qt.PointingHandCursor

                Component.onCompleted: {
                    debugMouseArea(this)
                }

                onClicked: {
                    calendarFrame.state === "infoTransparent" ? calendarFrame.state = "infoOpaque" : calendarFrame.state = "infoTransparent"

                    plasmoid.configuration.calendarGlassState = calendarFrame.state
                }
            }

            MouseArea {
                id: realTimeSwitch
                x: 0
                y: 49
                width: 13
                height: 14
                cursorShape: Qt.PointingHandCursor

                Component.onCompleted: {
                    debugMouseArea(this)
                }

                onClicked: {
                    main.setToRealTime();
                }
            }
        }

        Item {
            id: lookingGlassItem
            x: 123
            y: 23

            Image {
                id: lookingGlassShadowImage
                x: 4
                y: 4

                width: 70
                height: 95

                smooth: true
                mipmap: true
                source: "lookingGlassShadow.png"

                transform: Rotation {
                    id: lookingGlassShadowImageRotation
                    origin.x: lookingGlassShadowImage.paintedWidth / 2
                    origin.y: 33
                    angle: 0
                    Behavior on angle {
                        SpringAnimation {
                            spring: 4
                            damping: 0.3
                            modulus: 360
                        }
                    }
                }
            }

            Image {
                id: lookingGlassGlassImage
                x: 12
                y: 10

                width: 46
                height: 30

                smooth: true
                mipmap: true
                source: "../clock/clockglass.png"
            }

            Image {
                id: lookingGlassImage
                smooth: true
                mipmap: true
                source: "lookingGlass.png"

                width: 70
                height: 95

                transform: Rotation {
                    id: lookingGlassImageRotation
                    origin.x: lookingGlassImage.paintedWidth / 2
                    origin.y: 33
                    angle: 0
                    Behavior on angle {
                        ParallelAnimation {
                            SpringAnimation {
                                spring: 4;
                                damping: 0.3;
                                modulus: 360
                            }
                            ScriptAction {
                                script: {
                                    sounds.playSound(sounds.switchingSound);
                                }
                            }
                        }
                    }
                }

                MouseArea {
                    id: lookingGlassHandleSwitch
                    x: 31
                    y: 70
                    width: 10
                    height: 24
                    cursorShape: Qt.PointingHandCursor

                    Component.onCompleted: {
                        debugMouseArea(this)
                    }

                    onClicked: {
                        calendar.state === "in" ? calendar.state = "out" : calendar.state = "in"
                        plasmoid.configuration.calendarState = calendar.state
                    }
                }

                MouseArea {
                    id: lookingGlassButtonSwitch
                    x: 54
                    y: 10
                    width: 12
                    height: 12
                    cursorShape: Qt.PointingHandCursor

                    visible: false

                    Component.onCompleted: {
                        debugMouseArea(this)
                    }

                    onClicked: {

                    }
                }
            }
        }
    }
}
