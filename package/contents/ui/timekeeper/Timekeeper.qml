import QtQuick 2.3

import "orrery"

Item {
    id: frame
    width: parent.width
    height: parent.height

    readonly property var backgroundImages: [
        "frame/backgrounds/glassImmage.png",
        "frame/backgrounds/glassImmage1.png",
        "frame/backgrounds/glassImmage2.png",
        "frame/backgrounds/glassImmage3.png",
        "frame/backgrounds/glassImmage4.png",
        "frame/backgrounds/glassImmage5.png",
        "frame/backgrounds/backSky.png",
        plasmoid.configuration.userBackgroundImage,
        "frame/backgrounds/glassTransparent.png"
    ]

    property double ringDegree
    property int countAngle
    property bool lock: plasmoid.configuration.timekeeprLock

    property var monthRingAngles: [0, -31, -62, -93, -123, -153, -182.5, -212, -241.5, -270.5, -299.5, -329.2]

    function onCosmosTick(date) {
        var month = date.getMonth()
        var dayOfMonth  = date.getDate()-1
        frame.ringDegree = monthRingAngles[month] - dayOfMonth;
        orrery.setDateTime(date);
        calendar.setDateTime(date);
        clock.setDate(date);
    }

    function onAnimationTick() {
        if (!frame.lock && parseInt(main.realDateTime.getTime()/1000) % 7 == 0) {
            frame.countAngle = (frame.countAngle + 10) % 360;
            calendar.cogAngle = (calendar.cogAngle + 10) % 360;
        }
    }

    Component.onCompleted: {

        //set the background based on what is stored in the configs, and remove the user defined backgorund if empoty.
        for (var i = 0; i < frame.backgroundImages.length; i++) {
            if (frame.backgroundImages[i] && plasmoid.configuration.backgroundImage === frame.backgroundImages[i]) {
                backgroundImgAnimator.selectedImg = i;
                break;
            }
        }

        backgroundImg.source = frame.backgroundImages[backgroundImgAnimator.selectedImg];
        backgroundImg.selected = frame.backgroundImages[backgroundImgAnimator.selectedImg];
    }
    
    Image {
        id: backgroundImg
        x: 0
        y: 0
        width: 298
        height: 298
        smooth: true
        mipmap: true
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit
        sourceSize.width: 298
        sourceSize.height: 298
        property string selected: plasmoid.configuration.backgroundImage
    }
    
    Rectangle {
        id: backgroundImgAnimator
        x: 0
        y: 0
        opacity: 0
        width: 298
        height: 298
        anchors.centerIn: parent
        color: "black"

        property int selectedImg: 0

        function changeImage() {
            if (!imageFlipAnnimation.running) {
                do {
                    if (selectedImg < frame.backgroundImages.length) {
                        selectedImg ++;
                    } else {
                        selectedImg = 0;
                    }
                }
                while (frame.backgroundImages[selectedImg] === "" || !frame.backgroundImages[selectedImg]);
                backgroundImg.selected = frame.backgroundImages[selectedImg];

                state = "onChangeIn";
            }
        }
    
        states: [
            State {
                name: "onChangeIn";
                PropertyChanges { target: backgroundImgAnimator; opacity: 1}
            },
            State {
                name: "onChangeOut";
                PropertyChanges { target: backgroundImgAnimator; opacity: 0}
            }
        ]
        
        transitions: Transition {
            id: imageFlipAnnimation
            NumberAnimation { properties: "opacity"; easing.type: Easing.InOutQuad; duration: 500  }
            onRunningChanged: {

                if (!imageFlipAnnimation.running) {
                    if (backgroundImgAnimator.state != "onChangeIn") return;

                    backgroundImg.source = backgroundImg.selected;
                    plasmoid.configuration.backgroundImage = backgroundImg.selected;

                    backgroundImgAnimator.state = "onChangeOut";
                }
            }
        }

    }
    
    Image {
        id: innerMetalFrame
        x: 92
        y: 94
        width: 294
        height: 294
        sourceSize.width: 294
        sourceSize.height: 294
        source: "frame/innerMetalFrame.png"
        smooth: true
        mipmap: true
    }
    
    Image {
        width: 475
        height: 475
        source: "frame/innerFrame.png"

        smooth: true
        mipmap: true
        anchors.centerIn: parent
    }

    Image {
        width: 478
        height: 478

        source: "frame/woodSurround.png"

        smooth: true
        mipmap: true
    }

    Image {
        id:monthRing
        x: 16
        y: 18
        width: 446
        height: 446
        source: "frame/monthRing.png"

        smooth: true
        mipmap: true

        rotation: 122
        transform: Rotation {
            origin.x: 223; origin.y: 223;
            angle: {return (frame.ringDegree + 360) % 360;}
            Behavior on angle {
                SpringAnimation { 
                    spring: 2
                    damping: 0.2
                    modulus: 360
                }
            }
        }

        MouseArea {//date cog rotation
            id: mouseRotate
            anchors.fill: parent

            property int outerRingRadius: monthRing.paintedWidth/ 2
            property int innerRingRadius: (monthRing.paintedWidth/ 2) - 40

            property int startAngle: 0
            property int ostanov
            property int aPred

            function inner(x, y) {
                var dx = x - outerRingRadius;
                var dy = y - outerRingRadius;
                var xy = (dx * dx + dy * dy)

                var out = (outerRingRadius * outerRingRadius) >   xy;
                var inn = (innerRingRadius * innerRingRadius) <=  xy;

                return (out && inn) ? true : false;
            }

            function triAngle(x,y) {
                x = x - outerRingRadius;
                y = y - outerRingRadius;
                if(x === 0) return (y>0) ? 180 : 0;
                var a = Math.atan(y/x)*180/Math.PI;
                a = (x > 0) ? a+90 : a+270;

                return Math.round(a);
            }

            onPressed: {
                if( inner(mouse.x, mouse.y) ){
                    startAngle = triAngle(mouse.x, mouse.y)
                    ostanov     = frame.ringDegree
                    aPred      = startAngle
                }
            }

            onReleased: {

            }

            onPositionChanged: {
                var a, b, c
                if( inner(mouse.x, mouse.y) ){
                    a = triAngle(mouse.x, mouse.y)

                    b = ostanov + (a - startAngle)
                    frame.ringDegree = b
                    frame.countAngle = b
                    calendar.cogAngle = b

                    c = (aPred - a)
                    if(c < 90 && -90 < c ) {
                        updateDayCounter(c);
                    }
                    aPred = a;

                } else {
                    startAngle = triAngle(mouse.x, mouse.y)
                    ostanov     = frame.ringDegree
                    aPred      = startAngle
                }
                if(ostanov >  360) ostanov -= 360;
                if(ostanov < -360) ostanov += 360;
                // console.log(b, ostanov, a, start_angle)
            }
        }

    }
    Image {
        x: 69
        y: 71
        source: "frame/counterWheel.png"
        smooth: true
        mipmap: true

        transform: Rotation {
            origin.x: 170.5; origin.y: 170.5;
            angle: {return (360 - frame.countAngle + 360) % 360;}
            Behavior on angle {
                ParallelAnimation {
                    SpringAnimation {
                        spring: 2;
                        damping: 0.2;
                        modulus: 360
                    }
                    ScriptAction {
                        script: {
                            sounds.playSound(sounds.bigWheelCogSound);
                        }
                    }
                }
            }
        }
    }

    Image {
        id: backgroundSwitchImage
        source: "./frame/knob.png"
        x: 331
        y: 85
        width: 11
        height: 11

        smooth: true
        mipmap: true

        transform: Rotation {
            origin.x: backgroundSwitchImage.width / 2
            origin.y: backgroundSwitchImage.height / 2
            angle: (backgroundImgAnimator.selectedImg * (360 / backgroundImages.length)) % 360
            Behavior on angle {
                SpringAnimation {
                    spring: 2;
                    damping: 0.2;
                    modulus: 360
                }
            }
        }

        MouseArea {
            /*
             * Background switch button
             */
            id: backgroundPictureSwitch
            anchors.fill: parent
            visible: true

            Component.onCompleted: {
                debugMouseArea(this);
            }

            cursorShape: Qt.PointingHandCursor
            onClicked: {
                backgroundImgAnimator.changeImage();
            }
        }
    }

    Image {
        id: soundSwitchImage
        source: "./frame/knob.png"
        x: 136
        y: 387
        width: 11
        height: 11

        smooth: true
        mipmap: true

        transform: Rotation {
            origin.x: backgroundSwitchImage.width / 2
            origin.y: backgroundSwitchImage.height / 2
            angle: sounds.playSounds ? 0 : 180
            Behavior on angle {
                SpringAnimation {
                    spring: 2;
                    damping: 0.2;
                    modulus: 360
                }
            }
        }

        MouseArea {
            // turn sounds on and off
            id: soundSwitch
            anchors.fill: parent
            visible: true

            Component.onCompleted: {
                debugMouseArea(this);
            }

            cursorShape: Qt.PointingHandCursor
            onClicked: {
                sounds.toggleSoundOnOff()
            }
        }
    }

    Image {
        id: soundThemeSwitchImage
        source: "./frame/knob.png"
        x: 331
        y: 387
        width: 11
        height: 11

        smooth: true
        mipmap: true

        transform: Rotation {
            origin.x: backgroundSwitchImage.width / 2
            origin.y: backgroundSwitchImage.height / 2
            angle: (sounds.soundTheem * (360 / sounds.soundTheems.length)) % 360
            Behavior on angle {
                SpringAnimation {
                    spring: 2;
                    damping: 0.2;
                    modulus: 360
                }
            }
        }

        MouseArea {
            // switch sound theme
            id: soundThemeSwitch
            anchors.fill: parent
            visible: true

            Component.onCompleted: {
                debugMouseArea(this);
            }

            cursorShape: Qt.PointingHandCursor
            onClicked: {
                sounds.nextSoundTheme();
            }
        }
    }

    states: [
        State {
            name: "orrery"
        }
    ]

    Orrery {
        id: orrery
        x: innerMetalFrame.x
        y: innerMetalFrame.y
        z: 5
        width: 294
        height: 294
    }
}
