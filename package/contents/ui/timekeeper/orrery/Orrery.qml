import QtQuick 2.1

import "planets.js" as Planets

//planets
import "sun"
import "mercury"
import "venus"
import "earth"
import "mars"
import "jupiter"
import "saturn"
import "uranus"
import "neptune"

Item {
    id: home;

    property int shadowOffset: 5;
    property int zoomAnimationDurationMS: 500
    property int planetSmallLargeRasio: 5

    Component.onCompleted: {

    }

    function setDateTime(date) {
        for (var i = 0; i < planetarium.planets.length; i++) {
            var planet = planetarium.planets[i];
            planet.planetTrueAnomaly = 360 - Planets.getTrueAnomaly(i, date)
            planet.setDateTime(date);
        }
    }
    
    Item {
        id:planetarium
        width: parent.width
        height: parent.height
        property var planets: [mercury, venus, earth, mars, jupiter, saturn, uranus, neptune]

        Sun {
            id: sun;
            x: parent.width/2 - width/2;
            y: parent.height/2 - height/2;
        }

        Mercury {
            id: mercury

            property int planetoffset: 36
            property int planetTrueAnomaly: 0

            x: sun.x + (sun.width / 2) - (this.width / 2)
            y: sun.y + (sun.height / 2) - (this.height / 2) - planetoffset

            transform: Rotation {
                origin.x: mercury.width / 2
                origin.y: mercury.height / 2 + mercury.planetoffset
                angle: mercury.planetTrueAnomaly
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                }
            }
        }

        Venus {
            id: venus;

            property int planetoffset: 54
            property int planetTrueAnomaly: 0

            x: sun.x + (sun.width / 2) - (this.width / 2)
            y: sun.y + (sun.height / 2) - (this.height / 2) - planetoffset

            transform: Rotation {
                origin.x: venus.width / 2
                origin.y: venus.height / 2 + venus.planetoffset
                angle: venus.planetTrueAnomaly
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                }
            }
        }

        Earth {
            id: earth;

            property int planetoffset: 72
            property int planetTrueAnomaly: 0

            x: sun.x + (sun.width / 2) - (this.width / 2)
            y: sun.y + (sun.height / 2) - (this.height / 2) - planetoffset

            transform: Rotation {
                origin.x: earth.width / 2
                origin.y: earth.height / 2 + earth.planetoffset
                angle: earth.planetTrueAnomaly
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                }
            }
        }

        Mars {
            id: mars;

            property int planetoffset: 88
            property int planetTrueAnomaly: 0

            x: sun.x + (sun.width / 2) - (this.width / 2)
            y: sun.y + (sun.height / 2) - (this.height / 2) - planetoffset

            transform: Rotation {
                origin.x: mars.width / 2
                origin.y: mars.height / 2 + mars.planetoffset
                angle: mars.planetTrueAnomaly
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                }
            }
        }

        Jupiter {
            id: jupiter;

            property int planetoffset: 104
            property int planetTrueAnomaly: 0

            x: sun.x + (sun.width / 2) - (this.width / 2)
            y: sun.y + (sun.height / 2) - (this.height / 2) - planetoffset

            transform: Rotation {
                origin.x: jupiter.width / 2
                origin.y: jupiter.height / 2 + jupiter.planetoffset
                angle: jupiter.planetTrueAnomaly
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                }
            }
        }

        Saturn {
            id: saturn;

            property int planetoffset: 118
            property int planetTrueAnomaly: 0

            x: sun.x + (sun.width / 2) - (this.width / 2)
            y: sun.y + (sun.height / 2) - (this.height / 2) - planetoffset

            transform: Rotation {
                origin.x: saturn.width / 2
                origin.y: saturn.height / 2 + saturn.planetoffset
                angle: saturn.planetTrueAnomaly
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                }
            }
        }

        Uranus {
            id: uranus;

            property int planetoffset: 132
            property int planetTrueAnomaly: 0

            x: sun.x + (sun.width / 2) - (this.width / 2)
            y: sun.y + (sun.height / 2) - (this.height / 2) - planetoffset

            transform: Rotation {
                origin.x: uranus.width / 2
                origin.y: uranus.height / 2 + uranus.planetoffset
                angle: uranus.planetTrueAnomaly
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                }
            }
        }

        Neptune {
            id: neptune;

            property int planetoffset: 144
            property int planetTrueAnomaly: 0

            x: sun.x + (sun.width / 2) - (this.width / 2)
            y: sun.y + (sun.height / 2) - (this.height / 2) - planetoffset

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
