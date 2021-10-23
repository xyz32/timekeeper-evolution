import QtQuick 2.1
import QtQuick.Layouts 1.1
import org.kde.plasma.components 3.0
import org.kde.plasma.plasmoid 2.0

//background
import "timekeeper"

//time keeping
import "clock"
import "calendar"

Item {
    id: main

    readonly property bool debug: false

    readonly property int mainWidth: 478 * units.devicePixelRatio //540
    readonly property int mainHeight: 478 * units.devicePixelRatio

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
    property bool playSounds: plasmoid.configuration.playSounds
    property double soundVolume: plasmoid.configuration.soundVolume

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

    function stdTimezoneOffset () {
        var janDate = new Date((new Date).getFullYear(), 0, 1);
        var julDate = new Date((new Date).getFullYear(), 6, 1);
        return Math.max(janDate.getTimezoneOffset(), julDate.getTimezoneOffset());
    }

    function playSound(soundEfect) {
        if (main.playSounds) {
            soundEfect.volume = soundVolume;
            soundEfect.play();
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
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            var date = new Date;
            clock.setTime(date);
        }
    }

    Timer {
        id: minuteTimer
        interval: 60000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            if (!timekeeper.isRealTime) {
                return;
            }

            var date = new Date;
            timekeeper.setDateTime(date);
            calendar.setDateTime(date);
            clock.setDate(date);
        }
    }

    function setToRealTime() {
        //used to reset time to realtime

        timekeeper.isRealTime = true;
        timekeeper.count = 0;

        var date = new Date;
        clock.setTime(date);
        clock.setDate(date);
        timekeeper.setDateTime(date);
        calendar.setDateTime(date);
    }

    Flipable { //main container
        id: container
        property bool flipped: false
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        front: Item {
            width: mainWidth;
            height: mainHeight

            Timekeeper{ // frame backgroound
                id: timekeeper;
                z: 1
            }

            Clock {
                id: clock;
                x: 29; y: 60;
                z: 10
            }

            Calendar{
                id: calendar;
                x: 285;y: 186;
                z: 10
            }
        }
    }
}
