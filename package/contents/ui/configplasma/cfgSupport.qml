import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs


ColumnLayout {

    function isValidURL(str) {
      var regexp = /(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/
      return regexp.test(str);
    }

    GridLayout {
        Layout.alignment: Qt.AlignTop
        columns: 1

        GroupBox {
            title: i18n("Support and creddit")
            Layout.fillWidth:  true

            GridLayout {
                Layout.alignment: Qt.AlignCenter
                columns: 1
                rows: 2

                GridLayout {
                    Layout.alignment: Qt.AlignJustify
                    columns: 2

                    Label {
                        text: i18n("Support me on Patreon:")
                        Layout.alignment: Qt.AlignRight
                    }

                    Label {
                        property string textUrl: "https://www.patreon.com/climb_the_world"
                        text: isValidURL(textUrl) ? ("<a href='"+textUrl+"'>"+textUrl+"</a>") : textUrl
                        onLinkActivated:{
                           if (isValidURL(textUrl)){
                              Qt.openUrlExternally(textUrl)
                           }
                        }

                        Layout.alignment: Qt.AlignRight
                    }
                }

                GridLayout {
                    Layout.alignment: Qt.AlignJustify
                    columns: 2

                    Label {
                        text: i18n("Original graphics by:")
                        Layout.alignment: Qt.AlignRight
                    }

                    Label {
                        property string textUrl: "https://www.deviantart.com/yereverluvinuncleber/art/Steampunk-Orrery-Calendar-Clock-Yahoo-Widget-MkII-455720507"
                        property string textString: "yereverluvinunclebert"
                        text: isValidURL(textUrl) ? ("<a href='"+textUrl+"'>"+textString+"</a>") : textUrl
                        onLinkActivated:{
                           if (isValidURL(textUrl)){
                              Qt.openUrlExternally(textUrl)
                           }
                        }

                        Layout.alignment: Qt.AlignRight
                    }
                }
            }
        }
    }
}

