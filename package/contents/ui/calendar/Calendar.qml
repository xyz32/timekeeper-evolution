import QtQuick 2.1

Item {
    id: calendar
    width: 193; height: 131

    opacity: plasmoid.configuration.calendarOpacity

    property string day:   "31"
    property string month: "NOV"
    property string shortYear:  "54"
    property string fullYear:  "1854"

    property int cogAngle: 0

    property alias stained_glass: stglass.state
    property alias color:         color.extend

    property bool lock: false
    property bool sw:   true

    property string yearState: plasmoid.configuration.yearState

    states: [
       State {
            name: "out"
            PropertyChanges { target: calendar; x: 354;}
            PropertyChanges { target: cogAnimationTimer; dirrection: 1}
        },
        State {
             name: "in"
             PropertyChanges { target: calendar;}
             PropertyChanges { target: cogAnimationTimer; dirrection: -1}
         }
    ]

    transitions: [
        Transition {
            SequentialAnimation {
                PropertyAction  { target: cogAnimationTimer; property: "running"; value: "true"  }
                NumberAnimation { properties: "x"; duration: 1000                      }
                PropertyAction  { target: cogAnimationTimer; property: "running"; value: "false" }
            }
        }
    ]

    Component.onCompleted: {
        yearText.state = yearState
    }

    Behavior on x {
        SpringAnimation { spring: 1; damping: 0.2; modulus: 360 }
    }

    function setDateTime(date) {
        var dtime = Qt.formatDateTime(date, "dd,MMM,yy,yyyy")
        var now = dtime.toString().split(",")
        calendar.day   = now[0]
        calendar.month = now[1]
        calendar.shortYear  = now[2]
        calendar.fullYear  = now[3]
    }

    Item {
        id:cogWithShadow
        x: 29;     y: 13
        width: 84; height: 84

        Image {
            id: cogShadowImage
            x: -6; y: -5;
            source: "monthCogShadow.png"
            smooth: true;
            transform: Rotation {
                angle: cogAngle
                origin.x: cogShadowImage.width/2; origin.y: cogShadowImage.height/2;
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                }
            }
        }

        Image {
            id: cogImage
            x: 1; y: 0;
            width: 82; height: 84;
            source: "monthCog.png"
            smooth: true;
            transform: Rotation {
                angle: cogAngle
                origin.x: cogImage.width/2; origin.y: cogImage.height/2;
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                }
            }
        }

        Timer {
            id: cogAnimationTimer
            property int angleStep: 12
            property int dirrection: 1
            triggeredOnStart: true
            interval: 100
            repeat: true
            onTriggered: { cogAngle = (cogAngle + (angleStep * dirrection)) % 360; }
        }
    }

    Item {
        id:stglass

        states: [
            State {
                name: "green"
                PropertyChanges { target: gradientstop1; position: 0; color: "#206f4a" }
                PropertyChanges { target: gradientstop4; position: 1; color: "#206f4a" }

                PropertyChanges { target: gradientstop5; position: 0.16; color: "#206f4a" }
                PropertyChanges { target: gradientstop7; position: 0.51; color: "#8ac0a6" }
                PropertyChanges { target: gradientstop8; position: 0.7 ; color: "#ffffff" }

                PropertyChanges { target: rectangleLookingGlass;  color: "#206f4a"; visible: true }

                PropertyChanges { target: clock.week_glass; visible: true }
                PropertyChanges { target: clock.week_bgd;   visible: false }
                PropertyChanges { target: clock;            gradient: "#206f4a" }

                PropertyChanges { target: monthBackground; opacity: 0.65 }
                PropertyChanges { target: dayBackground;   opacity: 0.65 }
                PropertyChanges { target: yearBackground;  opacity: 0.65 }
            },

            State {
                name: "purple"
                PropertyChanges { target: gradientstop1; position: 0; color: "#187c8b" }
                PropertyChanges { target: gradientstop4; position: 1; color: "#187c8b" }

                PropertyChanges { target: gradientstop5; position: 0.16; color: "#187c8b" }
                PropertyChanges { target: gradientstop7; position: 0.51; color: "#66b7c2" }
                PropertyChanges { target: gradientstop8; position: 0.68; color: "#ffffff" }

                PropertyChanges { target: rectangleLookingGlass;  color: "#187c8b"; visible: true }

                PropertyChanges { target: clock.week_glass; visible: true }
                PropertyChanges { target: clock.week_bgd;   visible: false }
                PropertyChanges { target: clock;            gradient: "#187c8b" }

                PropertyChanges { target: monthBackground; opacity: 0.65 }
                PropertyChanges { target: dayBackground;   opacity: 0.65 }
                PropertyChanges { target: yearBackground;  opacity: 0.65 }
            },

            State {
                id: color
                name: "color"
                extend: "green"
                when: timekeeper.count != 0
            }
        ]
    }

    Image {
        id:calendarImage
        x: 0
        y: 0
        smooth: true
        source: "calendar_yyyy.png"

        Item {
            id: dayItem
            z: -1 //show below the frame

            Rectangle {
                id: dayBackground
                x: 95
                y: 5
                z: 1
                width: 36
                height: 36
                radius: width*0.5
                gradient: Gradient {
                    GradientStop {
                        id: gradientstop7
                        position: 0.46
                        color: "#b8a38b"
                    }
                    GradientStop {
                        id: gradientstop8
                        position: 1
                        color: "#ffffff"
                    }
                }
            }

            Text {
                x: 99
                y: 14
                z: 2
                width: 28;
                height: 22
                text: day
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 15
                font.family: fixedFont.name
                color: "#333333"

            }
        }

        Item {
            id: monthItem
            z: -1

            Rectangle {
                id: monthBackground
                x: 50
                y: 17
                width: 21
                height: 76

                gradient: Gradient {
                    GradientStop {
                        id: gradientstop1
                        position: 0
                        color: "#766139"
                    }
                    GradientStop {
                        id: gradientstop2
                        position: 0.35
                        color: "#ffffff"
                    }
                    GradientStop {
                        id: gradientstop3
                        position: 0.58
                        color: "#ffffff"
                    }
                    GradientStop {
                        id: gradientstop4
                        position: 1
                        color: "#766139"
                    }
                }
                rotation: 270
            }

            Text {
                x: 25; y: 45
                width: 69; height: 19
                text: month
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 15
                font.family: fixedFont.name
                color: "#333333"

            }
        }

        Item {
            id: yearItem
            z: -1

            Rectangle {
                    id: yearBackground
                    x: 65;y: 70
                    width: 66;height: 36
                    radius: width*0.5
                    gradient: Gradient {
                        GradientStop {
                            id: gradientstop5
                            position: 0.16
                            color: "#766139"
                        }
                        GradientStop {
                            id: gradientstop6
                            position: 0.68
                            color: "#ffffff"
                        }
                    }
                }

            Text {
                id: yearText
                x: 71; y: 78
                width: 58; height: 22
                text: fullYear

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                font.pointSize: 15
                font.family: fixedFont.name
                color: "#333333"
                states: [
                    State {
                        name: "yy"
                        PropertyChanges { target: yearText; text: shortYear; x:100; width:28; }
                        PropertyChanges { target: yearBackground; x:95; width:36; }
                        PropertyChanges { target: calendarImage; source: "calendar.png"; }
                    },
                    State {
                        name: "yyyy"
                        PropertyChanges { target: yearText; text: fullYear; x:71; width:58; }
                        PropertyChanges { target: yearBackground; x:65; width:66; }
                        PropertyChanges { target: calendarImage; source: "calendar_yyyy.png"; }
                    }
                ]
            }
        }

        Rectangle {
            id: rectangleLookingGlass
            x: 139; y: 36
            opacity: 0.53
            visible: false
            width: 40;height: 40
            radius: width*0.5
        }

        MouseArea {
            id: yearFormat
            x: 129; y: 81
            width: 8; height: 8
            cursorShape: Qt.PointingHandCursor

            Component.onCompleted: {
                debugMouseArea(this);
            }

            onClicked: {
                if(sw) yearText.state = "yy"
                else   yearText.state = "yyyy"

                sw = !sw

                plasmoid.configuration.yearState = yearText.state
            }
        }

        MouseArea {
            id: colorSwitch
            x: 131; y: 25
            width: 9; height: 11
            cursorShape: Qt.PointingHandCursor

            Component.onCompleted: {
                debugMouseArea(this);
            }

            onClicked: {
                if(calendar.stained_glass == "purple" ) {
                    calendar.color = "purple";
                    calendar.stained_glass = "green"
                } else if (calendar.stained_glass == "green") {
                    calendar.color = "";
                    calendar.stained_glass = ""
                } else if (calendar.stained_glass == "") {
                    calendar.color = "green";
                    calendar.stained_glass = "purple"
                }

                plasmoid.configuration.stainedglassState = calendar.stained_glass
            }
        }

        MouseArea {
            id: realTimeSwitch
            x: 154; y: 96
            width: 10; height: 24
            cursorShape: Qt.PointingHandCursor

            Component.onCompleted: {
                debugMouseArea(this);
            }

            onClicked: {
                main.setToRealTime()
            }
        }

        MouseArea {
            id: topButtonSwitch
            x: 178; y: 32
            width: 12; height: 14
            cursorShape: Qt.PointingHandCursor

            Component.onCompleted: {
                debugMouseArea(this);
            }

            onClicked: {

            }
        }

        MouseArea {
            id: inOutSwitch
            x: 0; y: 49
            width: 13; height: 14
            cursorShape: Qt.PointingHandCursor

            Component.onCompleted: {
                debugMouseArea(this);
            }

            onClicked: {
                calendar.state === "out" ? calendar.state = "in" : calendar.state = "out";
                plasmoid.configuration.calendarState = calendar.state
            }
        }
    }
}
