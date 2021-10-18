import QtQuick 2.1

import "planets.js" as Planets

Item {
    id: home;

    Component.onCompleted: {

    }

    property var showingDate: new Date();

    function setDateTime(date) {
        for (var i = 0; i < planetarium.planets.length; i++) {
            var planet = planetarium.planets[i];
            planet.planetTrueAnomaly = 360 - Planets.getTrueAnomaly(i, date)
        }

        var offest   = date.getTimezoneOffset();
        var hours    = date.getHours();
        var minutes  = date.getMinutes();

        earth.rot = (hours * earth.framesPerHour + Math.round((minutes + offest) / earth.framesPerMin)) % earth.earthNumFrames;
    }
    
    Item {
        id:planetarium
        width: parent.width
        height: parent.height
        property var planets: [mercury, venus, earth, mars, jupiter, saturn, uranus, neptune]

        Image {
            id: sun;
            x: parent.width/2 - width/2;
            y: parent.height/2 - height/2;
            smooth: true;
            source: "./images/sun.png"

            MouseArea {
                anchors.fill: parent
                visible: true;

                cursorShape: Qt.PointingHandCursor
                onClicked: {
                }
            }
        }

        Image {
            id: mercury

            property int planetoffset: 38
            property int planetTrueAnomaly: 0

            x: sun.x + (sun.width / 2) - (this.width / 2)
            y: sun.y + (sun.height / 2) - (this.height / 2) - planetoffset

            smooth: true
            source: "./images/mercury.png"

            MouseArea {
                anchors.fill: parent
                visible: true;

                cursorShape: Qt.PointingHandCursor
                onClicked: {
                }
            }

            transform: Rotation {
                origin.x: mercury.width / 2
                origin.y: mercury.height / 2 + mercury.planetoffset
                angle: mercury.planetTrueAnomaly
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360}
                }
            }
        }

        Image {
            id: venus;

            property int planetoffset: 56
            property int planetTrueAnomaly: 0

            x: sun.x + (sun.width / 2) - (this.width / 2)
            y: sun.y + (sun.height / 2) - (this.height / 2) - planetoffset

            smooth: true;
            source: "./images/venus.png"

            MouseArea {
                anchors.fill: parent
                visible: true;

                cursorShape: Qt.PointingHandCursor
                onClicked: {
                }
            }

            transform: Rotation {
                origin.x: venus.width / 2
                origin.y: venus.height / 2 + venus.planetoffset
                angle: venus.planetTrueAnomaly
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                }
            }
        }

        Image {
            id: earth;

            property int rot: 0
            property int earthNumFrames: 96
            property int planetTrueAnomaly: 0

            property int framesPerHour: earthNumFrames / 24
            property int framesPerMin: 60 / framesPerHour

            property int planetoffset: 74

            x: sun.x + (sun.width / 2) - (this.width / 2)
            y: sun.y + (sun.height / 2) - (this.height / 2) - planetoffset

            width: 15
            height: 15

            smooth: true;
            source: "../../terra/animation/earth"+ rot + ".png"

            MouseArea {
                anchors.fill: parent
                visible: true;

                cursorShape: Qt.PointingHandCursor
                onClicked: {
                }
            }

            transform: Rotation {
                origin.x: earth.width / 2
                origin.y: earth.height / 2 + earth.planetoffset
                angle: earth.planetTrueAnomaly
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                }
            }
        }

        Image {
            id: mars;

            property int planetoffset: 88
            property int planetTrueAnomaly: 0

            x: sun.x + (sun.width / 2) - (this.width / 2)
            y: sun.y + (sun.height / 2) - (this.height / 2) - planetoffset

            smooth: true;
            source: "./images/mars.png"

            MouseArea {
                anchors.fill: parent
                visible: true;

                cursorShape: Qt.PointingHandCursor
                onClicked: {
                }
            }

            transform: Rotation {
                origin.x: mars.width / 2
                origin.y: mars.height / 2 + mars.planetoffset
                angle: mars.planetTrueAnomaly
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                }
            }
        }

        Image {
            id: jupiter;

            property int planetoffset: 104
            property int planetTrueAnomaly: 0

            x: sun.x + (sun.width / 2) - (this.width / 2)
            y: sun.y + (sun.height / 2) - (this.height / 2) - planetoffset

            smooth: true;
            source: "./images/jupiter.png"

            MouseArea {
                anchors.fill: parent
                visible: true;

                cursorShape: Qt.PointingHandCursor
                onClicked: {
                }
            }

            transform: Rotation {
                origin.x: jupiter.width / 2
                origin.y: jupiter.height / 2 + jupiter.planetoffset
                angle: jupiter.planetTrueAnomaly
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                }
            }

        }

        Image {
            id: saturn;

            property int planetoffset: 118
            property int planetTrueAnomaly: 0

            x: sun.x + (sun.width / 2) - (this.width / 2)
            y: sun.y + (sun.height / 2) - (this.height / 2) - planetoffset

            smooth: true;
            source: "./images/saturn.png"

            MouseArea {
                anchors.fill: parent
                visible: true;

                cursorShape: Qt.PointingHandCursor
                onClicked: {
                }
            }

            transform: Rotation {
                origin.x: saturn.width / 2
                origin.y: saturn.height / 2 + saturn.planetoffset
                angle: saturn.planetTrueAnomaly
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                }
            }
        }

        Image {
            id: uranus;

            property int planetoffset: 132
            property int planetTrueAnomaly: 0

            x: sun.x + (sun.width / 2) - (this.width / 2)
            y: sun.y + (sun.height / 2) - (this.height / 2) - planetoffset

            smooth: true;
            source: "./images/uranus.png"

            MouseArea {
                anchors.fill: parent
                visible: true;

                cursorShape: Qt.PointingHandCursor
                onClicked: {
                }
            }

            transform: Rotation {
                origin.x: uranus.width / 2
                origin.y: uranus.height / 2 + uranus.planetoffset
                angle: uranus.planetTrueAnomaly
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                }
            }
        }

        Image {
            id: neptune;

            property int planetoffset: 144
            property int planetTrueAnomaly: 0

            x: sun.x + (sun.width / 2) - (this.width / 2)
            y: sun.y + (sun.height / 2) - (this.height / 2) - planetoffset

            smooth: true;
            source: "./images/neptune.png"

            MouseArea {
                anchors.fill: parent
                visible: true;

                cursorShape: Qt.PointingHandCursor
                onClicked: {
                }
            }
            transform: Rotation {
                origin.x: neptune.width / 2
                origin.y: neptune.height / 2 + neptune.planetoffset
                angle: neptune.planetTrueAnomaly
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                }
            }
        }
    }
}
