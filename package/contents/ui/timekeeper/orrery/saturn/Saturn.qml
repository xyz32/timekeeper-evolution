import QtQuick 2.1

Item {
    id: saturn;

    width: smallWidth
    height: smallHeight

    readonly property int smallWidth: 26 //bigger then jupiter if we include rings
    readonly property int smallHeight: 26

    readonly property int largeWidth: smallWidth * (planetSmallLargeRasio - 1) * 2.8985
    readonly property int largeHeight: smallHeight * (planetSmallLargeRasio - 1)

    state: plasmoid.configuration.saturnState

    transitions: [
        Transition {
            SequentialAnimation {
                ParallelAnimation {
                    NumberAnimation {
                        target: saturn
                        property: "width"
                        duration: zoomAnimationDurationMS / 2
                    }

                    NumberAnimation {
                        target: saturn
                        property: "height"
                        duration: zoomAnimationDurationMS / 2
                    }
                }

                NumberAnimation {
                    target: rotation;
                    property: "angle";
                    duration: zoomAnimationDurationMS / 2
                }
            }
        }
    ]

    states: [
        State {
            name: "small"
            PropertyChanges {
                target: saturn
                width: smallWidth;
                height: smallHeight;
                z: 0
            }

            PropertyChanges {
                target: rotation
                angle: 0
            }
        },
        State {
            name: "big"
            PropertyChanges {
                target: saturn
                width: largeWidth;
                height: largeHeight;
                z: 7
            }

            PropertyChanges {
                target: rotation
                angle: 180
            }
        }
    ]

    Component.onCompleted: {
    }

    function setDateTime(date) {

    }

    Image {
        x: 0 //(parent.width - parent.height) / 2
        y: - shadowOffset
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent

        smooth: true
        source: "../underShadow.png"
    }

    Flipable {
        id: planetFlip
        anchors.fill: parent

        transform: Rotation {
            id: rotation
            origin.x: planetFlip.width/2
            origin.y: planetFlip.height/2
            axis.x: 0; axis.y: 1; axis.z: 0     // set axis.y to 1 to rotate around y-axis
            angle: 0    // the default angle
        }

        front: Image {
            anchors.fill: parent

            smooth: true
            source: "./saturnTop.png"
        }

        back: Image {
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit

            smooth: true
            source: "./saturnFront.png"
        }

        MouseArea {

            anchors.fill: parent
            visible: true;

            cursorShape: Qt.PointingHandCursor

            Component.onCompleted: {
                debugMouseArea(this);
            }

            onClicked: {
                saturn.state = saturn.state === "small" ? "big" : "small"
                plasmoid.configuration.saturnState = saturn.state;
            }
        }
    }
}
