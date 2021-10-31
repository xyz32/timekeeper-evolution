import QtQuick 2.1
import QtQuick.Layouts 1.1
import org.kde.plasma.components 3.0
import org.kde.plasma.plasmoid 2.0

//background
import "timekeeper"

//time keeping
import "clock"
import "calendar"

//Sounds
import "sounds"

Item {
    id: main

    readonly property bool debug: false

    readonly property int mainWidth: 478 * units.devicePixelRatio //540
    readonly property int mainHeight: 478 * units.devicePixelRatio

    state: plasmoid.configuration.mainState

    width: mainWidth
    height: mainHeight

    Layout.minimumWidth: mainWidth
    Layout.minimumHeight: mainHeight
    Layout.preferredWidth: mainWidth
    Layout.preferredHeight: mainHeight
    Layout.maximumWidth: mainWidth
    Layout.maximumHeight: mainHeight

    Plasmoid.backgroundHints: "NoBackground"

    readonly property string fontName:   "Engravers MT"
    readonly property string textColour:   "#111111"

    readonly property double glassOpacity: 0.65

    property bool isRealTime: true
    property string nonRealTimeColour: "#ffff00"
    property double nonRealTimeOpacity: 0.2

    property bool playSounds: plasmoid.configuration.playSounds
    property double soundVolume: plasmoid.configuration.soundVolume
    property int standardTimezoneOffset: {
        //solve for daylight saving time gap.
        var janDate = new Date((new Date).getFullYear(), 0, 1);
        var julDate = new Date((new Date).getFullYear(), 6, 1);
        return Math.max(janDate.getTimezoneOffset(), julDate.getTimezoneOffset());
    }

    states: [
            State {
                name: "small"
                PropertyChanges {
                    target: timekeeper
                    scale: 0.3
                    rotation: 360
                    x: -119;
                    y: -88
                }

                PropertyChanges {
                    target: calendar;
                    state: "in"
                    scale: 0.3
                    x: 40;
                    y: 100;
                }
            }
        ]

    transitions: [
            Transition {
                from: "small"; to: "*"
                NumberAnimation { properties: "scale"; duration: 2700 } //InOutBack
                NumberAnimation { properties: "x, y "; duration: 700 }
            },
            Transition {
                from: "*"; to: "small"
                NumberAnimation { properties: "scale"; duration: 1000 }
                NumberAnimation { properties: "rotation, x, y "; duration: 2700 }
            }
        ]

    function debugMouseArea(dbgParent) {
        if (main.debug) {

            Qt.createQmlObject("
                            import QtQuick 2.0

                            Rectangle {
                                anchors.fill: parent
                                color: \"transparent\"
                                border.color: \"white\"
                            }
                        ", dbgParent);
        }
    }

    FontLoader {
        id:   fixedFont;
        name: fontName;
        source: "font/Engravers_MT.ttf";
        onStatusChanged: {
            if (fixedFont.status == FontLoader.Error) console.log("Cannot load font");
            // console.log(fixedFont.name, fixedFont.source)
        }
    }

    Timer {
        id: secondTimer
        interval: 10 //(playSounds && sounds.secondsCogSoundOdd.hasSound) ? 250 : 1000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            var date = new Date;
            clock.setTime(date);
            timekeeper.setTime(date);
        }
    }

    Timer {
        id: minuteTimer
        interval: 60000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            if (!main.isRealTime) {
                return;
            }

            var date = new Date;
            timekeeper.setDate(date);
            calendar.setDateTime(date);
            clock.setDate(date);
        }
    }

    Sounds {
        id: sounds
    }

    function setToRealTime() {
        //used to reset time to realtime

        main.isRealTime = true;
        timekeeper.count = 0;

        var date = new Date;
        clock.setTime(date);
        clock.setDate(date);
        timekeeper.setDate(date);
        calendar.setDateTime(date);
    }

    Item { //main container
        width: mainWidth;
        height: mainHeight

        Timekeeper{ // frame backgroound
            id: timekeeper;
            z: 1
        }

        Clock {
            id: clock;
            z: 10
        }

        Calendar{
            id: calendar;
            z: 7
        }
    }
}
