import QtQuick 2.3

Item {
    id: sun;

    width: smallWidth
    height: smallHeight

    readonly property int smallWidth: 48
    readonly property int smallHeight: 48

    readonly property int largeWidth: smallWidth * planetSmallLargeRasio
    readonly property int largeHeight: smallHeight * planetSmallLargeRasio

    property double sunRotation: 0;
    state: plasmoid.configuration.sunState

    transitions: [
        Transition {
            SequentialAnimation {
                ParallelAnimation {
                    NumberAnimation {
                        target: sun
                        property: "width"
                        duration: zoomAnimationDurationMS / 2
                    }

                    NumberAnimation {
                        target: sun
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
                target: sun
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
                target: sun
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
        var seconds = date.getTime() / 1000;

        sunRotation = 360 - (seconds * 0.0001666) % 360; // 0.0001666 averege deg per seconds sun rotation
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
            mipmap: true
            source: "./sunTop.png"

            transform: Rotation {
               origin.x: width / 2
               origin.y: height / 2
               angle: sunRotation
            }
        }

        back: Image {
            anchors.fill: parent

            smooth: true
            mipmap: true
            source: "./sunTop.png"
        }

        MouseArea {

            anchors.fill: parent
            visible: true;

            cursorShape: Qt.PointingHandCursor

            Component.onCompleted: {
                debugMouseArea(this);
            }

            onClicked: {
                sun.state = sun.state === "small" ? "big" : "small"
                plasmoid.configuration.sunState = sun.state;
            }
        }
    }
}
