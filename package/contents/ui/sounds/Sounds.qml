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
        if (main.playSounds && soundEfect && soundEfect.source) {
            soundEfect.volume = soundVolume;
            if (repeat) {
                soundEfect.loops = repeat;
            }

            soundEfect.play();
        }
    }

    function nextSounfTheme() {
        soundTheem = (soundTheem + 1) % soundTheems.length
        plasmoid.configuration.soundTheme = soundTheem;
    }

    SoundEffect {
        id: secondsCogSoundOdd
        source: "./" + soundTheemPath + "/secondsCogOdd.wav"
    }

    SoundEffect {
        id: secondsCogSoundEven
        source: "./" + soundTheemPath + "/secondsCogEven.wav"
    }

    SoundEffect {
        id: hourCogSound
        source: "./" + soundTheemPath + "/hourCog.wav"
    }

    SoundEffect {
        id: minutesCogSound
        source: "./" + soundTheemPath + "/minutesCog.wav"
    }

    SoundEffect {
        id: chimeSound
        source: "./" + soundTheemPath + "/chime.wav"
    }

    SoundEffect {
        id: clockMechanismCogSound
        source: "./" + soundTheemPath + "/clockMechanismCog.wav"
    }

    SoundEffect {
        id: bigWheelCogSound
        source: "./" + soundTheemPath + "/bigWheelCog.wav"
    }

    SoundEffect {
        id: switchingSound
        source: "./switching.wav"
    }

}
