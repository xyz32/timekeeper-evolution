import QtQuick 2.3
import QtQuick.Layouts 1.0
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

    readonly property int mainWidth: 478 //540
    readonly property int mainHeight: 478

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

    property string nonRealTimeColour: "#00C0A3"
    property double nonRealTimeOpacity: 0.5

    property bool isRealTime: true
    property var realDateTime
    property int hours: -1
    property int minutes: -1
    property int seconds: -1
    property int dayOfMonthNumber: -1

    property int dayCounter: 0
    property int minuteCounter: 0

    property int standardTimezoneOffset: {
        //solve for daylight saving time gap.
        var janDate = new Date((new Date).getFullYear(), 0, 1);
        var julDate = new Date((new Date).getFullYear(), 6, 1);
        return Math.max(janDate.getTimezoneOffset(), julDate.getTimezoneOffset());
    }

    Timer {
        id: tickTimer
        interval: (sounds.playSounds && sounds.secondsCogSoundOdd.hasSound) ? 100 : 1000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            realDateTime = new Date();

            var tmpSeconds = realDateTime.getSeconds();

            if (seconds !== tmpSeconds) {
                seconds  = tmpSeconds;
                onTimeTick(realDateTime);
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

    function setToRealTime() {
        dayCounter = 0;
        minuteCounter = 0;
        isRealTime = true;
        clock.ringDegree = 0;
        onTimeTick(new Date(), true);
    }

    function updateDayCounter(counter) {
        isRealTime = false;
        dayCounter += counter;
        onTimeTick(new Date(), true);
    }

    function updateMinuteCounter(counter) {
        isRealTime = false;
        minuteCounter += counter;
        onTimeTick(new Date(), true);
    }

    function onTimeTick(realtime, forceUpdate) {
        var updateRequired = forceUpdate ? forceUpdate : false;
        var tmpMinutes = realtime.getMinutes();
        var tmpHours = realtime.getHours();

        var showingTime = realtime;
        if (isRealTime) {
            showingTime = realtime;
        } else {
            showingTime.setDate(showingTime.getDate() + dayCounter);
            showingTime.setMinutes(showingTime.getMinutes() + (minuteCounter*2));
        }

        if (minutes !== tmpMinutes) {
            minutes  = tmpMinutes;
            updateRequired = true;
            //orrery needs an update every minute for planet rotations and month ring position
        }

        if (hours !== tmpHours) {
            hours  = tmpHours;
        }

        if (updateRequired) {
            timekeeper.onCosmosTick(showingTime);
            updateRequired = false;
        }
    }

    //utility methods
    function inner(x, y, parent) {
        var dx = x - parent.center.x;
        var dy = y - parent.center.y;
        var xy = (dx * dx + dy * dy)

        var out = parent.outerRingRadiusSquare >   xy;
        var inn = parent.innerRingRadiusSquare <=  xy;

        return (out && inn) ? true : false;
    }

    function triAngle(x, y, parent) {
        x = x - parent.center.x;
        y = y - parent.center.y;

        if(x === 0) {
            return (y>0) ? 180 : 0;
        }

        var angle = Math.atan(y/x)*180/Math.PI;
        angle = (x > 0) ? angle + 90 : angle + 270;

        return angle;
    }

    function angleDifference(angle1, angle2)
    {
        var diff = ( angle2 - angle1 + 180 ) % 360 - 180;
        return diff < -180 ? diff + 360 : diff;
    }
}
