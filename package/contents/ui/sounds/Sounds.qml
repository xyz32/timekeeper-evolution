import QtQuick 2.1
import QtMultimedia 5.15

Item {
    id: sounds

    readonly property string soundTheem: "grandfather-clock"

    //exported sounds:
    property alias secondsCogSoundOdd: secondsCogSoundOdd
    property alias secondsCogSoundEven: secondsCogSoundEven
    property alias hourCogSound: hourCogSound
    property alias minutesCogSound: minutesCogSound
    property alias bellSound: bellSound
    property alias clockMechanismCogSound: clockMechanismCogSound
    property alias bigWheelCogSound: bigWheelCogSound
    property alias springSound: springSound

    function playSound(soundEfect) {
        if (main.playSounds) {
            soundEfect.volume = soundVolume;
            soundEfect.play();
        }
    }

    SoundEffect {
        id: secondsCogSoundOdd
        source: "./" + soundTheem + "/secondsCogOdd.wav"
    }

    SoundEffect {
        id: secondsCogSoundEven
        source: "./" + soundTheem + "/secondsCogEven.wav"
    }

    SoundEffect {
        id: hourCogSound
        source: "./" + soundTheem + "/hourCog.wav"
    }

    SoundEffect {
        id: minutesCogSound
        source: "./" + soundTheem + "/minutesCog.wav"
    }

    SoundEffect {
        id: bellSound
        source: "./" + soundTheem + "/minutesCog.wav"
    }

    SoundEffect {
        id: clockMechanismCogSound
        source: "./" + soundTheem + "/clockMechanismCogSound.wav"
    }

    SoundEffect {
        id: bigWheelCogSound
        source: "./" + soundTheem + "/bigWheelcog.wav"
    }

    SoundEffect {
        id: springSound
        source: "./" + soundTheem + "/bigWheelcog.wav"
    }

}
