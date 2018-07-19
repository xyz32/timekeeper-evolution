import QtQuick 2.1

Item {
    id: glass
    width: 478; height: 478
    
    property string userBackgroundImage: plasmoid.configuration.userBackgroundImage
    property string transparentBackgroundImage: "backgrounds/glassTransparent.png"
    property string originalBackgroundImage: "backgrounds/glassImmage.png"
    property string universBackgroundImage: "backgrounds/wikipediaPabloImmage.png"

    property double ring_degree
    property int    count_angle
    property bool   lock: false
    property alias  sa  : mouse_rotate.start_angle
    // TODO marble
    // property alias  mar : marble
    property bool   ch  : true

    property alias  moon_l  : moon1
    property alias  moon_r  : moon2
    
    Image  {
        id: backgroundImg
        x: 0
        y: 0
        width: 294
        height: 294
        source: plasmoid.configuration.backgroundImage
        smooth: true
        anchors.centerIn: parent
        sourceSize.width: 294
        sourceSize.height: 294
        property string selected: plasmoid.configuration.backgroundImage
    }
    
    Image  {
        x: 0
        y: 0
        source: "innerMetalFrame.png"
        smooth: true
        anchors.centerIn: parent
    }
    
    Image  {
        x: 0
        y: 0
        source: "innerFrame.png"
        smooth: true
        anchors.centerIn: parent
    }

    Image {
        source: "woodSurround.png"
        smooth: true
    }

    Image {
        id:month_ring
        x: 16
        y: 18
        source: "rotatingring.png"
        smooth: true
        rotation: 122
        transform: Rotation {
            origin.x: 223; origin.y: 223;
            angle: glass.ring_degree
            Behavior on angle {
                SpringAnimation { 
                    spring: 2
                    damping: 0.2
                    modulus: 360
                }
            }
        }

    }
    Image {
        x: 69
        y: 71
        source: "counterWheel.png"
        smooth: true
        transform: Rotation {
            origin.x: 170.5; origin.y: 170.5;
            angle: glass.count_angle * -1
            Behavior on angle {
                SpringAnimation {
                    spring: 2
                    damping: 0.2
                    modulus: 360
                }
            }
        }
    }

    MouseArea {
        id: mouse_rotate
        x: 16; y: 18
        width: 446; height: 445
        property int start_angle:0
        property int ostanov
        property int a_pred


        function inner(x, y){
            var dx = x - 223;
            var dy = y - 223;
            var xy = (dx * dx + dy * dy)

            var out = (223 * 223) >   xy;
            var inn = (150 * 150) <=  xy;

            return (out && inn) ? true : false;
        }
        function ringUpdated(count) {
            var today = new Date();
            today.setDate(today.getDate()+count)
            nowTimeAndMoonPhase(today)
        }
        function tri_angle(x,y){
            x = x - 223;
            y = y - 223;
            if(x == 0) return (y>0) ? 180 : 0;
            var a = Math.atan(y/x)*180/Math.PI;
            a = (x > 0) ? a+90 : a+270;

            return Math.round(a);
        }

        onPressed: {
            if( inner(mouse.x, mouse.y) ){
                glass.lock  = false;

                start_angle = tri_angle(mouse.x, mouse.y)
                ostanov     = glass.ring_degree
                a_pred      = start_angle
            }
        }
        onReleased: {
            glass.lock = whell.lock
        }
        onPositionChanged: {
            var a, b, c
            if( inner(mouse.x, mouse.y) ){
                a = tri_angle(mouse.x, mouse.y)

                b = ostanov + (a - start_angle)
                glass.ring_degree = b
                glass.count_angle = b

                c = (a_pred - a)
                if(c < 90 && -90 < c ) count += c
                a_pred = a

                ringUpdated(count)
            } else {
                start_angle = tri_angle(mouse.x, mouse.y)
                ostanov     = glass.ring_degree
                a_pred      = start_angle
            }
            if(ostanov >  360) ostanov -= 360;
            if(ostanov < -360) ostanov += 360;
            // console.log(b, ostanov, a, start_angle)
        }
    }
    MouseArea {
        id: moon1; x: 137; y: 386; width: 11; height: 11; visible: false
        cursorShape: Qt.PointingHandCursor
        onClicked: { }
    }
    MouseArea {
        id: moon2; x: 331; y: 386; width: 11; height: 11; visible: false
        cursorShape: Qt.PointingHandCursor
        onClicked: { }
    }


    MouseArea {
        id: on_off_citylights; x: 137; y: 386; width: 11; height: 11; visible: false
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (!glass.ch)
                marble.citylights_on();
            else
                marble.citylights_off();
            glass.ch = !glass.ch
        }
    }
    MouseArea {
        id: on_off_clouds; x: 331; y: 386; width: 11; height: 11; visible: false
        property bool ch: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (!ch)
                marble.clouds_data_on();
            else
                marble.clouds_data_off();
            ch = !ch
        }
    }
    
    MouseArea {
        /*
         * Background switch button
         */
        id: marble_latlon; x: 332; y: 84;  width: 11; height: 11; visible: true
        cursorShape: Qt.PointingHandCursor
        onClicked: { 
            if (backgroundImg.selected == userBackgroundImage) {
                backgroundImg.selected = transparentBackgroundImage;
            } else if (backgroundImg.selected == transparentBackgroundImage) {
                backgroundImg.selected = originalBackgroundImage;
            } else if (backgroundImg.selected == originalBackgroundImage) {
                backgroundImg.selected = universBackgroundImage;
            } else if (userBackgroundImage != "" && backgroundImg.selected == universBackgroundImage) {
                backgroundImg.selected = userBackgroundImage;
            } else {
                backgroundImg.selected = transparentBackgroundImage;
            }
            
            backgroundImg.source = backgroundImg.selected;
            plasmoid.configuration.backgroundImage = backgroundImg.selected;
        }
    }
    
    MouseArea {
        id: save_latlon;   x: 388; y: 401; width: 11; height: 11; visible: false
        cursorShape: Qt.PointingHandCursor
        onClicked: { marble.saveLatLon() }
    }

    states: [
        State {
            name: "earth"
            // TODO marble
            /*
            PropertyChanges { target: marble;       visible: true }
            PropertyChanges { target: mouse_rotate; visible: false }

            PropertyChanges { target: on_off_citylights; visible: true }
            PropertyChanges { target: on_off_clouds;     visible: true }
            PropertyChanges { target: marble_latlon;     visible: true }
            PropertyChanges { target: save_latlon;       visible: true }
            // */
        }
    ]
    //transform: Rotation { origin.x: 239; origin.y: 239; axis { x: 1; y: 1; z: 0 } angle: 0 }
}
