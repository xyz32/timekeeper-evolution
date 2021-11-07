import QtQuick 2.3

Item {
    id: venus;

    width: smallWidth
    height: smallHeight

    readonly property int smallWidth: 15
    readonly property int smallHeight: 15

    readonly property int largeWidth: smallWidth * planetSmallLargeRasio
    readonly property int largeHeight: smallHeight * planetSmallLargeRasio

    state: plasmoid.configuration.venusState

    transitions: [
        Transition {
            SequentialAnimation {
                ParallelAnimation {
                    NumberAnimation {
                        target: venus
                        property: "width"
                        duration: zoomAnimationDurationMS / 2
                    }

                    NumberAnimation {
                        target: venus
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
                target: venus
                width: smallWidth;
                height: smallWidth;
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
                target: venus
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
            anchors.fill: parent

            smooth: true
            mipmap: true
            source: "./venusTop.png"
        }

        back: Image {
            anchors.fill: parent

            smooth: true
            mipmap: true
            source: "./venusFront.png"
        }

        MouseArea {

            anchors.fill: parent
            visible: true;

            cursorShape: Qt.PointingHandCursor

            Component.onCompleted: {
                debugMouseArea(this);
            }

            onClicked: {
                venus.state = venus.state === "small" ? "big" : "small"
                plasmoid.configuration.venusState = venus.state;
            }
        }
    }
}
