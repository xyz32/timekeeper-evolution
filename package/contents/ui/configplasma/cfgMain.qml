import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.0


ColumnLayout {

    property alias cfg_userBackgroundImage:  backImg.text
    property alias cfg_clockOpacity:  clockOpacity.value
    property alias cfg_calendarOpacity:  calendarOpacity.value
    property alias cfg_soundVolume: soundVolume.value

    property alias cfg_secondHandSound: secondHandSound.checked
    property alias cfg_minuteHandSound: minuteHandSound.checked
    property alias cfg_hourHandSound: hourHandSound.checked
    property alias cfg_cogsSound: cogsSound.checked
    property alias cfg_chimeSound: chimeSound.checked

    GridLayout {
        Layout.alignment: Qt.AlignTop
        columns: 1

        GroupBox {

            title: i18n("Custom background image")
            Layout.fillWidth:  true

            GridLayout {
                Layout.alignment: Qt.AlignCenter
                columns: 3

                Label {
                    text: i18n("Image path:")
                    Layout.alignment: Qt.AlignRight
                }

                TextField {
                    id: backImg
                    Layout.minimumWidth: 300
                    placeholderText: qsTr("Path")
                }

                Button {
                    id: btnSignals
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
                Layout.alignment: Qt.AlignCenter
                columns: 3
                rows: 2

                Label {
                    text: i18n("Clock opacity:")
                    Layout.alignment: Qt.AlignRight
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
                    Layout.alignment: Qt.AlignRight
                    text: {
                        return clockOpacity.value.toFixed(2);
                    }
                }

                Label {
                    text: i18n("Calendar opacity:")
                    Layout.alignment: Qt.AlignRight
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
                    Layout.alignment: Qt.AlignRight
                    text: {
                        return calendarOpacity.value.toFixed(2);
                    }
                }
            }
        }

        GroupBox {

            title: i18n("Sound")
            Layout.fillWidth:  true

            GridLayout {
                Layout.alignment: Qt.AlignCenter
                columns: 1
                rows: 2

                GridLayout {
                    Layout.alignment: Qt.AlignCenter
                    columns: 3
                    rows: 2

                    Label {
                        text: i18n("Sound volume:")
                        Layout.alignment: Qt.AlignRight
                    }

                    Slider {
                        id: soundVolume
                        Layout.minimumWidth: 300
                        live:true
                        snapMode: "SnapAlways"
                        stepSize: 0.05
                        from: 0
                        value: 1
                        to: 1

                        onMoved: {
                            soundVolumeValue.text = soundVolume.value.toFixed(2);
                        }
                    }

                    Label {
                        id: soundVolumeValue
                        Layout.alignment: Qt.AlignRight
                        text: {
                            return soundVolume.value.toFixed(2);
                        }
                    }
                }

                GroupBox {
                    title: i18n("Enabeled Sound")
                    Layout.fillWidth:  true

                    GridLayout {
                        columns: 2

                        ColumnLayout {
                            Layout.alignment: Qt.AlignTop
                            CheckBox {
                                id: secondHandSound
                                checked: true
                                text: i18n("Seconds hand sound")
                            }

                            CheckBox {
                                id: minuteHandSound
                                checked: true
                                text: i18n("Minutes hand sound")
                            }

                            CheckBox {
                                id: hourHandSound
                                checked: true
                                text: i18n("Hours hand sound")
                            }
                        }

                        ColumnLayout {
                            Layout.alignment: Qt.AlignTop
                            CheckBox {
                                id: cogsSound
                                checked: true
                                text: i18n("Cogs sound")
                            }

                            CheckBox {
                                id: chimeSound
                                checked: true
                                text: i18n("Chime sound")
                            }
                        }

                    }
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

