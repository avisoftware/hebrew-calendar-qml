import QtQuick 2.0
import Ubuntu.Components 1.2

Page {
    id: settingsViewPage
    objectName: "settingsViewPage"
    property bool isCurrentPage: false
    //    Keys.forwardTo: [dayViewPath]
    //    flickable: null
    Action {
        id: settingsReset
        objectName:"settingsReset"
        iconName: "reset"
        text: i18n.tr("Reset")
        onTriggered: {

        }
    }
    head {
        actions: [
            settingsReset
        ]
        contents: Label {
            fontSize: "x-large"
            text: i18n.tr("Settings")
        }
    }
    Settings{
        id:settings
    }
    Column {
        anchors.fill: parent
        anchors.margins:  units.gu(3)
        spacing: units.gu(3)

        OptionSelector {
            id:nosachSelector
            text: i18n.tr("Nosach Sefirat HaOmer:")
            model: [i18n.tr("Ashkenazi"),
                i18n.tr("Hasidic"),
                i18n.tr("Mizrachi")]
            selectedIndex:settings.nosach
            onSelectedIndexChanged: {
                settings.nosach = nosachSelector.selectedIndex;
            }
        }
    }
}
