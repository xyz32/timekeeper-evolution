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

    property string nonRealTimeColour: "#ffff00"
    property double nonRealTimeOpacity: 0.2

    property bool isRealTime: true
    property var currentDateTime
    property int hours
    property int minutes
    property int seconds
    property int dayOfMonthNumber

    property bool playSounds: plasmoid.configuration.playSounds
    property double soundVolume: plasmoid.configuration.soundVolume



    property int standardTimezoneOffset: {
        //solve for daylight saving time gap.
        var janDate = new Date((new Date).getFullYear(), 0, 1);
        var julDate = new Date((new Date).getFullYear(), 6, 1);
        return Math.max(janDate.getTimezoneOffset(), julDate.getTimezoneOffset());
    }

    Timer {
        id: tickTimer
        interval: (playSounds && sounds.secondsCogSoundOdd.hasSound) ? 500 : 1000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            currentDateTime = new Date();

            var tmpSeconds = currentDateTime.getSeconds();
            var tmpMinutes = currentDateTime.getMinutes();
            var tmpHours = currentDateTime.getHours();
            var tmpDate = currentDateTime.getDate()

            if (seconds !== tmpSeconds) {
                seconds  = tmpSeconds;
                timekeeper.onSecondTick();
            }

            if (minutes !== tmpMinutes) {
                minutes  = tmpMinutes;
                //orrery needs an update every minute for planet rotations and month ring position
                timekeeper.onMinutTick(currentDateTime)
            }

            if (hours !== tmpHours) {
                hours  = tmpHours;
            }

            if (dayOfMonthNumber !== tmpDate) {
                dayOfMonthNumber = tmpDate;
                if (isRealTime) {
                    timekeeper.onDayTick(currentDateTime);
                    calendar.setDateTime(currentDateTime);
                    clock.setDate(currentDateTime);
                }
            }
        }
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
            NumberAnimation { properties: "scale"; duration: 700 }
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

    Sounds {
        id: sounds
    }

    function setToRealTime() {
        //used to reset time to realtime

        main.isRealTime = true;
        timekeeper.count = 0;

        clock.setDate(currentDateTime);
        timekeeper.onDayTick(currentDateTime);
        timekeeper.onMinutTick(currentDateTime);
        calendar.setDateTime(currentDateTime);
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
