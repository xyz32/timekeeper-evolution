import QtQuick 2.1
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.0


ColumnLayout {

    property alias cfg_userBackgroundImage:  backImg.text
    property alias cfg_clockOpacity:  clockOpacity.value
    property alias cfg_calendarOpacity:  calendarOpacity.value

    GridLayout {
        anchors.verticalCenter:   parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        columns: 1

        GroupBox {

            title: i18n("Background image")
            Layout.fillWidth:  true

            GridLayout {
                anchors.verticalCenter:   parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                columns: 3

                Label {
                    text: i18n("Background image:")
                    Layout.alignment: Qt.AlignRight
                    anchors.verticalCenter: backImg.verticalCenter
                }

                TextField {
                    id: backImg
                    Layout.minimumWidth: 300
                    placeholderText: qsTr("Path")
                }

                Button {
                    id: btnSignals
                    anchors.verticalCenter: backImg.verticalCenter
                    text: i18n("Browse")

                    onClicked: {
                        fileDialog.visible = true
                    }
                }
            }
        }

        GroupBox {

            title: i18n("Opacity")
            Layout.fillWidth:  true

            GridLayout {
                anchors.verticalCenter:   parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                columns: 3
                rows: 2

                Label {
                    text: i18n("Clock opacity:")
                    Layout.alignment: Qt.AlignRight
                    anchors.verticalCenter: clockOpacity.verticalCenter
                }

                Slider {
                    id: clockOpacity
                    Layout.minimumWidth: 300
                    live:true
                    snapMode: "SnapAlways"
                    stepSize: 0.05
                    from: 0
                    value: 1
                    to: 1

                    onMoved: {
                        clockOpacityValue.text = clockOpacity.value.toFixed(2);
                    }
                }

                Label {
                    id: clockOpacityValue
                    text: "1.00"
                    Layout.alignment: Qt.AlignRight
                    anchors.verticalCenter: clockOpacity.verticalCenter
                }


                Label {
                    text: i18n("Calendar opacity:")
                    Layout.alignment: Qt.AlignRight
                    anchors.verticalCenter: calendarOpacity.verticalCenter
                }

                Slider {
                    id: calendarOpacity
                    Layout.minimumWidth: 300
                    live:true
                    snapMode: "SnapAlways"
                    stepSize: 0.05
                    from: 0
                    value: 1
                    to: 1

                    onMoved: {
                        calendarOpacityValue.text = calendarOpacity.value.toFixed(2);
                    }
                }

                Label {
                    id: calendarOpacityValue
                    text: "1.00"
                    Layout.alignment: Qt.AlignRight
                    anchors.verticalCenter: calendarOpacity.verticalCenter
                }
            }
        }
    }
    
    FileDialog {
        id: fileDialog
        title: i18n("Please choose a file")
        nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]
        selectMultiple: false
        onAccepted: {
            backImg.text = fileDialog.fileUrls[0]
            Qt.quit()
        }
        onRejected: {
            Qt.quit()
        }
    }
}

