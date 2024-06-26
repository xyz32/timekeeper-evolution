import QtQuick
import QtMultimedia

Item {
    id: sounds

    readonly property var soundTheems: [
        "wooden-clock",
        "smooth-clock",
        "grandfather-clock"
    ]

    property int soundTheem: plasmoid.configuration.soundTheme
    property bool playSounds: plasmoid.configuration.playSounds

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

    SoundEffect {
        id: secondsCogSoundOdd
        volume: plasmoid.configuration.soundVolume
        property string src: "./" + soundTheemPath + "/secondsCogOdd.wav"
    }

    SoundEffect {
        id: secondsCogSoundEven
        volume: plasmoid.configuration.soundVolume
        property string src: "./" + soundTheemPath + "/secondsCogEven.wav"
    }

    SoundEffect {
        id: minutesCogSound
        volume: plasmoid.configuration.soundVolume
        property string src: "./" + soundTheemPath + "/minutesCog.wav"
    }

    SoundEffect {
        id: hourCogSound
        volume: plasmoid.configuration.soundVolume
        property string src: "./" + soundTheemPath + "/hourCog.wav"
    }

    SoundEffect {
        id: chimeSound
        volume: plasmoid.configuration.soundVolume
        property string src: "./" + soundTheemPath + "/chime.wav"
    }

    SoundEffect {
        id: clockMechanismCogSound
        volume: plasmoid.configuration.soundVolume
        property string src: "./" + soundTheemPath + "/clockMechanismCog.wav"
    }

    SoundEffect {
        id: bigWheelCogSound
        volume: plasmoid.configuration.soundVolume
        property string src: "./" + soundTheemPath + "/bigWheelCog.wav"
    }

    SoundEffect {
        id: switchingSound
        volume: plasmoid.configuration.soundVolume
        property string src: "./switching.wav"
    }
}
