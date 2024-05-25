import QtQuick
import org.kde.plasma.configuration

ConfigModel {
    ConfigCategory {
         name: i18n("General")
         icon: Qt.resolvedUrl('../screenshot.png')
         source: "configplasma/cfgMain.qml"
    }

    ConfigCategory {
         name: i18n("Support")
         icon: Qt.resolvedUrl('./support.png')
         source: "configplasma/cfgSupport.qml"
    }
}
