import QtQuick 2.1
import QtMultimedia 5.15

Item {
    id: sounds

    readonly property var soundTheems: [
        "wooden-clock",
        "smooth-clock",
        "grandfather-clock"
    ]

    property int soundTheem: plasmoid.configuration.soundTheme

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
        if (main.playSounds && soundEfect && soundEfect.source && soundEfect.hasSound) {
            soundEfect.volume = soundVolume;
            if (!repeat) {
                repeat = 0;
            }

            soundEfect.loops = repeat;

            soundEfect.play();
        }
    }

    function nextSounfTheme() {
        soundTheem = (soundTheem + 1) % soundTheems.length
        plasmoid.configuration.soundTheme = soundTheem;
    }

    SoundEffect {
        id: secondsCogSoundOdd
        property bool hasSound: plasmoid.configuration.secondHandSound
        source: "./" + soundTheemPath + "/secondsCogOdd.wav"
    }

    SoundEffect {
        id: secondsCogSoundEven
        property bool hasSound: plasmoid.configuration.secondHandSound
        source: "./" + soundTheemPath + "/secondsCogEven.wav"
    }

    SoundEffect {
        id: minutesCogSound
        property bool hasSound: plasmoid.configuration.minuteHandSound
        source: "./" + soundTheemPath + "/minutesCog.wav"
    }

    SoundEffect {
        id: hourCogSound
        property bool hasSound: plasmoid.configuration.hourHandSound
        source: "./" + soundTheemPath + "/hourCog.wav"
    }

    SoundEffect {
        id: chimeSound
        property bool hasSound: plasmoid.configuration.chimeSound
        source: "./" + soundTheemPath + "/chime.wav"
    }

    SoundEffect {
        id: clockMechanismCogSound
        property bool hasSound: plasmoid.configuration.cogsSound
        source: "./" + soundTheemPath + "/clockMechanismCog.wav"
    }

    SoundEffect {
        id: bigWheelCogSound
        property bool hasSound: plasmoid.configuration.cogsSound
        source: "./" + soundTheemPath + "/bigWheelCog.wav"
    }

    SoundEffect {
        id: switchingSound
        property bool hasSound: true
        source: "./switching.wav"
    }
}
