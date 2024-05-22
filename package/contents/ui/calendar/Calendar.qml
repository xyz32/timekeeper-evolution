import QtQuick

Item {
    id: calendarView

    width: 368 * parentContainer.scaleFactor
    height: 180 * parentContainer.scaleFactor

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
                x: 345 * parentContainer.scaleFactor
                y: 188 * parentContainer.scaleFactor
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
                x: 285 * parentContainer.scaleFactor
                y: 188 * parentContainer.scaleFactor
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
        x: 29 * parentContainer.scaleFactor
        y: 13 * parentContainer.scaleFactor

        property int ojectWidth: 86 * parentContainer.scaleFactor
        property int ojectHeight: 86 * parentContainer.scaleFactor

        Image {
            id: cogShadowImage
            x: 6 * parentContainer.scaleFactor
            y: 6 * parentContainer.scaleFactor
            width: parent.ojectWidth
            height: parent.ojectHeight

            source: "../clock/cogs/cogShadow.png"

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
            x: 0 * parentContainer.scaleFactor
            y: 0 * parentContainer.scaleFactor
            width: parent.ojectWidth
            height: parent.ojectHeight

            source: "../clock/cogs/cog.png"

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
                x: 95 * parentContainer.scaleFactor
                y: 7 * parentContainer.scaleFactor
                width: 36 * parentContainer.scaleFactor
                height: 36 * parentContainer.scaleFactor
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
                font.pixelSize: 14 * parentContainer.scaleFactor
                font.family: fixedFont.name
                color: main.textColour
            }
        }

        Item {
            id: monthItem

            Image {
                id: monthBackground
                x: 24 * parentContainer.scaleFactor
                y: 43 * parentContainer.scaleFactor
                width: 72 * parentContainer.scaleFactor
                height: 24 * parentContainer.scaleFactor
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
                font.pixelSize: 14 * parentContainer.scaleFactor
                font.family: fixedFont.name
                color: main.textColour
            }
        }

        Item {
            id: yearItem
            x: 58 * parentContainer.scaleFactor
            y: 68 * parentContainer.scaleFactor
            z: -1

            state: plasmoid.configuration.yearState

            states: [
                State {
                    name: "yy"
                    PropertyChanges {
                        target: yearText
                        text: shortYear
                        x: 42 * parentContainer.scaleFactor
                        width: 28 * parentContainer.scaleFactor
                    }
                    PropertyChanges {
                        target: yearBackground
                        x: 37 * parentContainer.scaleFactor
                        width: 36 * parentContainer.scaleFactor
                    }
                    PropertyChanges {
                        target: yearFrame
                        x: 29 * parentContainer.scaleFactor
                        ojectWidth: 49 * parentContainer.scaleFactor
                        ojectHeight: 43 * parentContainer.scaleFactor
                        yearFormatString: "Short"
                    }
                },
                State {
                    name: "yyyy"
                    PropertyChanges {
                        target: yearText
                        text: fullYear
                        x: 3 * parentContainer.scaleFactor
                        width: 58 * parentContainer.scaleFactor
                    }
                    PropertyChanges {
                        target: yearBackground
                        x: 7 * parentContainer.scaleFactor
                        width: 66 * parentContainer.scaleFactor
                    }
                    PropertyChanges {
                        target: yearFrame
                        x: 0 * parentContainer.scaleFactor
                        ojectWidth: 78 * parentContainer.scaleFactor
                        ojectHeight: 43 * parentContainer.scaleFactor
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
                x: 7 * parentContainer.scaleFactor
                y: 3 * parentContainer.scaleFactor
                width: 66 * parentContainer.scaleFactor
                height: 36 * parentContainer.scaleFactor
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

                font.pixelSize: 14 * parentContainer.scaleFactor
                font.family: fixedFont.name
                color: main.textColour
            }

            Item {
                id: yearFrame

                property int ojectWidth: 78 * parentContainer.scaleFactor
                property int ojectHeight: 43 * parentContainer.scaleFactor

                property string yearFormatString: "Long"

                Image {
                    id: yearFrameShadowImage
                    x: 2 * parentContainer.scaleFactor
                    y: 2 * parentContainer.scaleFactor
                    width: parent.ojectWidth
                    height: parent.ojectHeight

                    smooth: true
                    mipmap: true
                    source: "./calendar" + yearFrame.yearFormatString + "YearShadow.png"
                }

                Image {
                    id: yearFrameImage

                    width: parent.ojectWidth
                    height: parent.ojectHeight

                    smooth: true
                    mipmap: true
                    source: "./calendar" + yearFrame.yearFormatString + "Year.png"
                }
            }
        }

        Image {
            id: calendarImage
            x: 0 * parentContainer.scaleFactor
            y: 0 * parentContainer.scaleFactor

            width: 182 * parentContainer.scaleFactor
            height: 90 * parentContainer.scaleFactor

            smooth: true
            mipmap: true
            source: "calendar.png"

            MouseArea {
                id: yearFormat
                x: 129 * parentContainer.scaleFactor
                y: 81 * parentContainer.scaleFactor
                width: 8 * parentContainer.scaleFactor
                height: 8 * parentContainer.scaleFactor
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
                x: 131 * parentContainer.scaleFactor
                y: 25 * parentContainer.scaleFactor
                width: 9 * parentContainer.scaleFactor
                height: 9 * parentContainer.scaleFactor
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
                x: 0 * parentContainer.scaleFactor
                y: 49 * parentContainer.scaleFactor
                width: 13 * parentContainer.scaleFactor
                height: 14 * parentContainer.scaleFactor
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
            x: 123 * parentContainer.scaleFactor
            y: 23 * parentContainer.scaleFactor

            property int ojectWidth: 70 * parentContainer.scaleFactor
            property int ojectHeight: 95 * parentContainer.scaleFactor

            Image {
                id: lookingGlassShadowImage
                x: 3 * parentContainer.scaleFactor
                y: 3 * parentContainer.scaleFactor

                width: parent.ojectWidth
                height: parent.ojectHeight

                smooth: true
                mipmap: true
                source: "lookingGlassShadow.png"

                transform: Rotation {
                    id: lookingGlassShadowImageRotation
                    origin.x: lookingGlassShadowImage.width / 2
                    origin.y: 33 * parentContainer.scaleFactor
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
                x: 12 * parentContainer.scaleFactor
                y: 10 * parentContainer.scaleFactor

                width: 46 * parentContainer.scaleFactor
                height: 30 * parentContainer.scaleFactor

                smooth: true
                mipmap: true
                source: "../clock/clockglass.png"
            }

            Image {
                id: lookingGlassImage
                smooth: true
                mipmap: true
                source: "lookingGlass.png"

                width: parent.ojectWidth
                height: parent.ojectHeight

                transform: Rotation {
                    id: lookingGlassImageRotation
                    origin.x: lookingGlassImage.width / 2
                    origin.y: 33 * parentContainer.scaleFactor
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
                    x: 31 * parentContainer.scaleFactor
                    y: 70 * parentContainer.scaleFactor
                    width: 10 * parentContainer.scaleFactor
                    height: 24 * parentContainer.scaleFactor
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
                    x: 54 * parentContainer.scaleFactor
                    y: 10 * parentContainer.scaleFactor
                    width: 12 * parentContainer.scaleFactor
                    height: 12 * parentContainer.scaleFactor
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
