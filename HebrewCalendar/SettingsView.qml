import QtQuick 2.4
import Ubuntu.Components 1.2
import Ubuntu.Components.ListItems 1.0 as ListItem

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
        ListItem.Header  {
            text: i18n.tr("Global")
        }

        Row {
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: units.gu(2)
            Label {
                text: i18n.tr("Second Yom Tov:")
            }
            CheckBox {
                id: diasporaCheckBox
                checked: settings.diaspora
                onTriggered:  {
                    settings.diaspora = diasporaCheckBox.checked;
                    needRestartLabel.visible =true;
                }
            }
            Label {
                id: needRestartLabel
                text: i18n.tr("This Change will be affected after restart")
                visible:false
            }

        }
        ListItem.Header  {
            text: i18n.tr("Sefirat HaOmer")

        }
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
