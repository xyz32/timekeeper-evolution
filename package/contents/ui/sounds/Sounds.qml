import QtQuick 2.3
import QtMultimedia 5.0

Item {
    id: sounds

    readonly property var soundTheems: [
        "wooden-clock",
        "smooth-clock",
        "grandfather-clock"
    ]

    property int soundTheem: plasmoid.configuration.soundTheme
    property bool playSounds: plasmoid.configuration.playSounds
    property double soundVolume: plasmoid.configuration.soundVolume

    //exported sounds:
    property alias secondsCogSoundOdd: secondsCogSoundOdd
    property alias secondsCogSoundEven: secondsCogSoundEven
    property alias hourCogSound: hourCogSound
    property alias minutesCogSound: minutesCogSound
    property alias chimeSound: chimeSound
    property alias clockMechanismCogSound: clockMechanismCogSound
    property alias bigWheelCogSound: bigWheelCogSound
    property alias switchingSound: switchingSound

    property string soundTheemPath: soundTheems[soundTheem]

    function playSound(soundEfect, repeat) {
        if (playSounds && soundEfect && soundEfect.source && !soundEfect.muted) {
            soundEfect.volume = soundVolume;
            if (!repeat) {
                repeat = 0;
            }

            soundEfect.loops = repeat;

            soundEfect.source = soundEfect.src;

            soundEfect.play();
        }
    }

    function toggleSoundOnOff() {
        playSounds = !playSounds;
        plasmoid.configuration.playSounds = playSounds;

        if (!playSounds) {
            for (var i = 0; i < sounds.resources.length; i++)
            {
                sounds.resources[i].stop();
                sounds.resources[i].source = "";
            }
        } else {
            for (var j = 0; j < sounds.resources.length; j++)
            {
                sounds.resources[j].source = sounds.resources[j].src;
            }
        }
    }

    function nextSoundTheme() {
        soundTheem = (soundTheem + 1) % soundTheems.length
        plasmoid.configuration.soundTheme = soundTheem;
    }

    Audio {
        id: secondsCogSoundOdd
        muted: !plasmoid.configuration.secondHandSound
        property string src: "./" + soundTheemPath + "/secondsCogOdd.wav"
    }

    Audio {
        id: secondsCogSoundEven
        muted: !plasmoid.configuration.secondHandSound
        property string src: "./" + soundTheemPath + "/secondsCogEven.wav"
    }

    Audio {
        id: minutesCogSound
        muted: !plasmoid.configuration.minuteHandSound
        property string src: "./" + soundTheemPath + "/minutesCog.wav"
    }

    Audio {
        id: hourCogSound
        muted: !plasmoid.configuration.hourHandSound
        property string src: "./" + soundTheemPath + "/hourCog.wav"
    }

    Audio {
        id: chimeSound
        muted: !plasmoid.configuration.chimeSound
        property string src: "./" + soundTheemPath + "/chime.wav"
    }

    Audio {
        id: clockMechanismCogSound
        muted: !plasmoid.configuration.cogsSound
        property string src: "./" + soundTheemPath + "/clockMechanismCog.wav"
    }

    Audio {
        id: bigWheelCogSound
        muted: !plasmoid.configuration.cogsSound
        property string src: "./" + soundTheemPath + "/bigWheelCog.wav"
    }

    Audio {
        id: switchingSound
        muted: false
        property string src: "./switching.wav"
    }
}
