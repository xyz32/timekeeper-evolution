import QtQuick 2.1

Item {
    id: calendar
    width: 193
    height: 131

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
                target: calendar
                x: 354
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
                target: calendar
            }
            PropertyChanges {
                target: cogAnimationTimer
                dirrection: -1
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
        width: 84
        height: 84

        Image {
            id: cogShadowImage
            x: -6
            y: -5
            source: "monthCogShadow.png"
            smooth: true
            transform: Rotation {
                angle: cogAngle
                origin.x: cogShadowImage.width / 2
                origin.y: cogShadowImage.height / 2
                Behavior on angle {
                    SpringAnimation {
                        spring: 2
                        damping: 0.2
                        modulus: 360
                    }
                }
            }
        }

        Image {
            id: cogImage
            x: 1
            y: 0
            width: 82
            height: 84
            source: "monthCog.png"
            smooth: true
            transform: Rotation {
                angle: cogAngle
                origin.x: cogImage.width / 2
                origin.y: cogImage.height / 2
                Behavior on angle {
                    SpringAnimation {
                        spring: 2
                        damping: 0.2
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
                cogAngle = (cogAngle + (angleStep * dirrection)) % 360
            }
        }
    }

    Item {
        id: calendarFrame
        state: plasmoid.configuration.calendarGlassState

        property double glassOpacity: 0.65

        states: [
            State {
                name: "infoTransparent"

                PropertyChanges {
                    target: monthBackground
                    opacity: calendarFrame.glassOpacity
                }
                PropertyChanges {
                    target: dayBackground
                    opacity: calendarFrame.glassOpacity
                }
                PropertyChanges {
                    target: yearBackground
                    opacity: calendarFrame.glassOpacity
                }

                PropertyChanges {
                    target: clock.weekBackgroundImage
                    opacity: calendarFrame.glassOpacity
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
                source: "./textBackgroundRound.png"

                Rectangle {
                    id: rectangleDayBackground
                    anchors.fill: dayBackground
                    visible: !timekeeper.isRealTime
                    color: timekeeper.nonRealTimeColour
                    opacity: timekeeper.nonRealTimeOpacity
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
                color: "#333333"
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
                source: "../clock/textBackground.png"

                Rectangle {
                    id: rectangleMonthBackground
                    anchors.fill: monthBackground
                    visible: !timekeeper.isRealTime
                    color: timekeeper.nonRealTimeColour
                    opacity: timekeeper.nonRealTimeOpacity
                }
            }

            Text {
                anchors.fill: monthBackground
                text: month
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 14
                font.family: fixedFont.name
                color: "#333333"
            }
        }

        Item {
            id: yearItem
            state: plasmoid.configuration.yearState

            states: [
                State {
                    name: "yy"
                    PropertyChanges {
                        target: yearText
                        text: shortYear
                        x: 100
                        width: 28
                    }
                    PropertyChanges {
                        target: yearBackground
                        x: 95
                        width: 36
                    }
                    PropertyChanges {
                        target: calendarImage
                        source: "calendar.png"
                    }
                },
                State {
                    name: "yyyy"
                    PropertyChanges {
                        target: yearText
                        text: fullYear
                        x: 71
                        width: 58
                    }
                    PropertyChanges {
                        target: yearBackground
                        x: 65
                        width: 66
                    }
                    PropertyChanges {
                        target: calendarImage
                        source: "calendar_yyyy.png"
                    }
                }
            ]

            Image {
                id: yearBackground
                x: 65
                y: 71
                width: 66
                height: 36
                smooth: true
                source: "./textBackgroundRound.png"

                Rectangle {
                    id: rectangleYearBackground
                    anchors.fill: yearBackground
                    visible: !timekeeper.isRealTime
                    color: timekeeper.nonRealTimeColour
                    opacity: timekeeper.nonRealTimeOpacity
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
                color: "#333333"
            }
        }

        Image {
            id: calendarImage
            x: 0
            y: 0
            smooth: true
            source: "calendar_yyyy.png"

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
                    if (yearItem.state === "yyyy")
                        yearItem.state = "yy"
                    else
                        yearItem.state = "yyyy"

                    plasmoid.configuration.yearState = yearItem.state
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
                x: 2
                y: 2

                smooth: true
                source: "lookingGlassShadow.png"

                transform: Rotation {
                    id: lookingGlassShadowImageRotation
                    origin.x: lookingGlassShadowImage.width / 2
                    origin.y: 39
                    angle: 0
                    Behavior on angle {
                        SpringAnimation { spring: 4; damping: 0.3; modulus: 360 }
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
                source: "../clock/clockglass.png"
            }

            Image {
                id: lookingGlassImage
                smooth: true
                source: "lookingGlass.png"

                transform: Rotation {
                    id: lookingGlassImageRotation
                    origin.x: lookingGlassImage.width / 2
                    origin.y: 33
                    angle: 0
                    Behavior on angle {
                        SpringAnimation { spring: 4; damping: 0.3; modulus: 360 }
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
