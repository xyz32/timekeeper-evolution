import QtQuick

//moon
import "moon"

Item {
    id: earth;
    width: smallWidth
    height: smallHeight

    property int daytimeRotation: 0
    property int earthNumFrames: 96
    property int framesPerHour: earthNumFrames / 24
    property int framesPerMin: 60 / framesPerHour

    readonly property int smallWidth: 15 * parentContainer.scaleFactor
    readonly property int smallHeight: 15 * parentContainer.scaleFactor

    readonly property int largeWidth: smallWidth * planetSmallLargeRasio
    readonly property int largeHeight: smallHeight * planetSmallLargeRasio

    state: plasmoid.configuration.earthState

    transitions: [
        Transition {
            SequentialAnimation {
                ParallelAnimation {
                    NumberAnimation {
                        target: earth
                        property: "width"
                        duration: zoomAnimationDurationMS / 2
                    }

                    NumberAnimation {
                        target: earth
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
                target: earth
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
                target: earth
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
        moon.setDateTime(date);

        var hours    = date.getHours();
        var minutes  = date.getMinutes();

        earth.daytimeRotation = (hours * earth.framesPerHour + Math.round((minutes + standardTimezoneOffset) / earth.framesPerMin)) % earth.earthNumFrames;

        moon.planetTrueAnomaly = 360 - (moon.degreesPerPhase * moon.phase);
    }

    Image {
        x: 0
        y: - shadowOffset
        width: parent.width
        height: parent.height

        smooth: true
        mipmap: true
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
            id: terraTop
            anchors.fill: parent

            smooth: true
            mipmap: true
            source: "./earthTop.png"
        }

        back: Image {
            id: terra24
            anchors.fill: parent

            smooth: true
            mipmap: true
            source: "./animation/earth"+ daytimeRotation + ".png"
        }

        MouseArea {

            anchors.fill: parent
            visible: true;

            cursorShape: Qt.PointingHandCursor

            Component.onCompleted: {
                debugMouseArea(this);
            }

            onClicked: {
                earth.state = earth.state === "small" ? "big" : "small"
                plasmoid.configuration.earthState = earth.state;
            }
        }
    }

    Moon {
        id: moon
        width: planetFlip.width / 3
        height: planetFlip.width / 3

        property int planetoffset: (planetFlip.height / 2) + (moon.height / 2)
        property int planetTrueAnomaly: 0

        x: planetFlip.x + (planetFlip.width / 2) - (moon.width / 2)
        y: planetFlip.y + (planetFlip.height / 2) - (moon.height / 2) + moon.planetoffset

        transform: [
            Rotation {
                origin.x: moon.width / 2
                origin.y: moon.height / 2
                angle: 180
            },
            Rotation {
                origin.x: moon.width / 2
                origin.y: moon.height / 2 - moon.planetoffset
                angle: moon.planetTrueAnomaly
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                }
            }
        ]
    }
}
