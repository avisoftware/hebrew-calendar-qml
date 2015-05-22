import QtQuick 2.4
import Ubuntu.Components 1.2
import Ubuntu.Components.ListItems 1.0 as ListItem
import Ubuntu.Components.Popups 1.0
import U1db 1.0 as U1db
Page {
    id: settingsViewPage
    objectName: "settingsViewPage"
    property bool isCurrentPage: false
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
    U1db.Database {
                   id: loacationDatabase
                   path: "lU1DbDatabase"
    }
    U1db.Document {
                    id: nameDocument
                    database: loacationDatabase
                    docId: 'name'
                    create: true
                    defaults: { "name":["jerusalem","tel-aviv"]}
    }
    U1db.Document {
                    id: latitudeDocument
                    database: loacationDatabase
                    docId: 'latitude'
                    create: true
                    defaults: { "latitude": [31.78,32.06]}
    }
    U1db.Document {
                    id: longitudeDocument
                    database: loacationDatabase
                    docId: 'longitude'
                    create: true
                    defaults: { "longitude": [35.22,34.77]}
    }
    // http://en.wikipedia.org/wiki/List_of_tz_database_time_zones
    U1db.Document {
                    id: timeZoneDocument
                    database: loacationDatabase
                    docId: 'timeZone'
                    create: true
                    defaults: { "timeZone": ["Asia/Jerusalem","Asia/Tel_Aviv"]}
    }
    Column {
        anchors.fill: parent
        anchors.margins:  units.gu(3)
        spacing: units.gu(2)
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
                }
            }
        }
        ListItem.Header  {
            text: i18n.tr("Location")
        }

        OptionSelector {
            id:locationSelector

           // text: i18n.tr("")
            model: nameDocument.contents.name
            selectedIndex:model.indexOf(settings.locationName.toString())
            containerHeight: itemHeight * 4
            onSelectedIndexChanged: {
                settings.locationName =model[selectedIndex];
                settings.locationLongitude=longitudeDocument.contents.longitude[selectedIndex];
                settings.locationLatitude=latitudeDocument.contents.latitude[selectedIndex];
                settings.locationTimeZone=timeZoneDocument.contents.timeZone[selectedIndex];
            }
        }
        Row {
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: units.gu(2)
            Button {
                iconName: "edit"
                text: i18n.tr("Edit location")
                onClicked:{
                  PopupUtils.open(Qt.resolvedUrl("LocationDialog.qml"),parent, {
                                        locationName: locationSelector.model[locationSelector.selectedIndex]})
                }
            }
            Button {
                iconName: "add"
                text: i18n.tr("New loaction")
                onClicked:{
                    PopupUtils.open(Qt.resolvedUrl("LocationDialog.qml"),parent)
                }
            }
        }


        ListItem.Header  {
            text: i18n.tr("Times Of Day")
        }
        OptionSelector {
            id:candelLightSelector
            text: i18n.tr("Candel Light")
            model: ["15", "18", "20", "22", "30", "40", "50", "60"]
            selectedIndex:model.indexOf(settings.candelLight.toString())
            containerHeight: itemHeight * 4
            onSelectedIndexChanged: {
                settings.candelLight =model[selectedIndex];
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
