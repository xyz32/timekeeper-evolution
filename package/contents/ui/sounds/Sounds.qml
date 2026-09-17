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

    function playSound(soundEffect, repeat) {
        if (!playSounds || !soundEffect || soundEffect.muted
                || soundEffect.status !== SoundEffect.Ready) {
            return;
        }

        soundEffect.loops = repeat || 1;
        soundEffect.play();
    }

    function stopAllSounds() {
        for (var i = 0; i < sounds.resources.length; i++) {
            var resource = sounds.resources[i];
            if (resource.stop) {
                resource.stop();
            }
        }
    }

    function toggleSoundOnOff() {
        playSounds = !playSounds;
        plasmoid.configuration.playSounds = playSounds;

        if (!playSounds) {
            stopAllSounds();
        }
    }

    function nextSoundTheme() {
        stopAllSounds();
        soundTheem = (soundTheem + 1) % soundTheems.length
        plasmoid.configuration.soundTheme = soundTheem;
    }

    SoundEffect {
        id: secondsCogSoundOdd
        volume: plasmoid.configuration.soundVolume
        muted: !plasmoid.configuration.secondHandSound
        property url src: Qt.resolvedUrl("./" + soundTheemPath + "/secondsCogOdd.wav")
        source: src
    }

    SoundEffect {
        id: secondsCogSoundEven
        volume: plasmoid.configuration.soundVolume
        muted: !plasmoid.configuration.secondHandSound
        property url src: Qt.resolvedUrl("./" + soundTheemPath + "/secondsCogEven.wav")
        source: src
    }

    SoundEffect {
        id: minutesCogSound
        volume: plasmoid.configuration.soundVolume
        muted: !plasmoid.configuration.minuteHandSound
        property url src: Qt.resolvedUrl("./" + soundTheemPath + "/minutesCog.wav")
        source: src
    }

    SoundEffect {
        id: hourCogSound
        volume: plasmoid.configuration.soundVolume
        muted: !plasmoid.configuration.hourHandSound
        property url src: Qt.resolvedUrl("./" + soundTheemPath + "/hourCog.wav")
        source: src
    }

    SoundEffect {
        id: chimeSound
        volume: plasmoid.configuration.soundVolume
        muted: !plasmoid.configuration.chimeSound
        property url src: Qt.resolvedUrl("./" + soundTheemPath + "/chime.wav")
        source: src
    }

    SoundEffect {
        id: clockMechanismCogSound
        volume: plasmoid.configuration.soundVolume
        muted: !plasmoid.configuration.cogsSound
        property url src: Qt.resolvedUrl("./" + soundTheemPath + "/clockMechanismCog.wav")
        source: src
    }

    SoundEffect {
        id: bigWheelCogSound
        volume: plasmoid.configuration.soundVolume
        muted: !plasmoid.configuration.cogsSound
        property url src: Qt.resolvedUrl("./" + soundTheemPath + "/bigWheelCog.wav")
        source: src
    }

    SoundEffect {
        id: switchingSound
        volume: plasmoid.configuration.soundVolume
        property url src: Qt.resolvedUrl("./switching.wav")
        source: src
    }
}
