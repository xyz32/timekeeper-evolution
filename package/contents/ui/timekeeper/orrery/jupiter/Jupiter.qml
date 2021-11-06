import QtQuick 2.1

Item {
    id: jupiter;

    width: smallWidth
    height: smallHeight

    readonly property int smallWidth: 24
    readonly property int smallHeight: 24

    readonly property int largeWidth: smallWidth * planetSmallLargeRasio
    readonly property int largeHeight: smallHeight * planetSmallLargeRasio

    state: plasmoid.configuration.jupiterState

    transitions: [
        Transition {
            SequentialAnimation {
                ParallelAnimation {
                    NumberAnimation {
                        target: jupiter
                        property: "width"
                        duration: zoomAnimationDurationMS / 2
                    }

                    NumberAnimation {
                        target: jupiter
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
                target: jupiter
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
                target: jupiter
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
        var time = date.getTime() / 60000; //utc time in minutes

        io.planetTrueAnomaly = getMoonAnomaly(time, 2547.36);
        europa.planetTrueAnomaly = getMoonAnomaly(time, 5113.44);
        ganymede.planetTrueAnomaly = getMoonAnomaly(time, 10303.2);
        callisto.planetTrueAnomaly = getMoonAnomaly(time, 24032.16);
    }

    function getMoonAnomaly(time, orbitPeriod) {
        var orbits = time / orbitPeriod;
        var percentOforbit = orbits - Math.floor(orbits);
        return 360 - (360 * percentOforbit);
    }

    Image {
        x: 0
        y: - shadowOffset
        width: parent.width
        height: parent.height

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
            source: "./jupiterTop.png"

        }

        back: Image {
            anchors.fill: parent

            smooth: true
            source: "./jupiterFront.png"

        }

        MouseArea {

            anchors.fill: parent
            visible: true;

            cursorShape: Qt.PointingHandCursor

            Component.onCompleted: {
                debugMouseArea(this);
            }

            onClicked: {
                jupiter.state = jupiter.state === "small" ? "big" : "small"
                plasmoid.configuration.jupiterState = jupiter.state;
            }
        }
    }

    Image {
        id: io
        width: planetFlip.width / 8
        height: planetFlip.width / 8

        source: "./io/ioFront.png"

        property int planetoffset: (planetFlip.height / 2) + (io.height / 2)
        property int planetTrueAnomaly: 0

        x: planetFlip.x + (planetFlip.width / 2) - (io.width / 2)
        y: planetFlip.y + (planetFlip.height / 2) - (io.height / 2) + io.planetoffset

        transform: Rotation {
            origin.x: io.width / 2
            origin.y: io.height / 2 - io.planetoffset
            angle: io.planetTrueAnomaly
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
    }

    Image {
        id: europa
        width: planetFlip.width / 9
        height: planetFlip.width / 9

        source: "./europa/europaFront.png"

        property int planetoffset: (planetFlip.height / 2) + io.height + (europa.height / 2)
        property int planetTrueAnomaly: 0

        x: planetFlip.x + (planetFlip.width / 2) - (europa.width / 2)
        y: planetFlip.y + (planetFlip.height / 2) - (europa.height / 2) + europa.planetoffset

        transform: Rotation {
            origin.x: europa.width / 2
            origin.y: europa.height / 2 - europa.planetoffset
            angle: europa.planetTrueAnomaly
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
    }

    Image {
        id: ganymede
        width: planetFlip.width / 5
        height: planetFlip.width / 5

        source: "./ganymede/ganymedeFront.png"

        property int planetoffset: (planetFlip.height / 2) + io.height + europa.height + (ganymede.height / 2)
        property int planetTrueAnomaly: 0

        x: planetFlip.x + (planetFlip.width / 2) - (ganymede.width / 2)
        y: planetFlip.y + (planetFlip.height / 2) - (ganymede.height / 2) + ganymede.planetoffset

        transform: Rotation {
            origin.x: ganymede.width / 2
            origin.y: ganymede.height / 2 - ganymede.planetoffset
            angle: ganymede.planetTrueAnomaly
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
    }

    Image {
        id: callisto
        width: planetFlip.width / 6
        height: planetFlip.width / 6

        source: "./calisto/calistoFront.png"

        property int planetoffset: (planetFlip.height / 2) + io.height + europa.height + ganymede.height + (callisto.height / 2)
        property int planetTrueAnomaly: 0

        x: planetFlip.x + (planetFlip.width / 2) - (callisto.width / 2)
        y: planetFlip.y + (planetFlip.height / 2) - (callisto.height / 2) + callisto.planetoffset

        transform: Rotation {
            origin.x: callisto.width / 2
            origin.y: callisto.height / 2 - callisto.planetoffset
            angle: callisto.planetTrueAnomaly
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
    }
}
