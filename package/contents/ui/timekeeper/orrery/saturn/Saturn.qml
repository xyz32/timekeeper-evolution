import QtQuick 2.3

Item {
    id: saturn;

    width: smallWidth
    height: smallHeight

    readonly property int smallWidth: 26 * parentContainer.scaleFactor //bigger then jupiter if we include rings
    readonly property int smallHeight: 26 * parentContainer.scaleFactor

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
        x: saturn.width / 4 //(parent.width - parent.height) / 2
        y: saturn.height / 4 - shadowOffset

        width: saturn.width / 2
        height: saturn.height / 2

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
            anchors.fill: parent

            smooth: true
            mipmap: true
            source: "./saturnTop.png"
        }

        back: Image {
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit

            smooth: true
            mipmap: true
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
