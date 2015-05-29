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
        id: locationTemplate1
        database: loacationDatabase
        docId: 'firstRun1'
        create: true
        defaults: { "name":["Jerusalem"],
                    "latitude":["31.78"],
                    "longitude":["35.22"],
                    "timeZone":["Asia/Jerusalem"]}
    }
    U1db.Document {
        id: locationTemplate2
        database: loacationDatabase
        docId: 'firstRun2'
        create: true
        defaults: { "name":["Tel-Aviv"],
                    "latitude":["32.06"],
                    "longitude":["34.77"],
                    "timeZone":["Asia/Tel_Aviv"]}
    }
    U1db.Index{
        database: loacationDatabase
        id: loacationIndex
        expression: [["name"],["latitude"],["longitude"],["timeZone"]]
    }
    U1db.Query{
        id: allQuery
        index: loacationIndex
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
            model:allQuery
            delegate: OptionSelectorDelegate {
                                text: i18n.tr(contents.name)
                            }
            Component.onCompleted: {
                selectedIndex=getIndexOf(settings.locationName.toString())
            }
            //get the index of settings from results
            function getIndexOf(text){
                var model1=model;
                for(var i=0;i<model.results.length;i++){
                        if(model.results[i].name[0]===text)
                            return i;
                }
                return 0;
            }

            containerHeight: itemHeight * 4

            onSelectedIndexChanged: {
                    updateSettings("");
            }
            function updateSettings(select){
                //if we add new entry we should update the selected index
                if(select!==""){
                    locationSelector.selectedIndex=getIndexOf(select);
                }
                var selectedIndex = locationSelector.selectedIndex
                var m = model;
                var s =locationSelector.selectedIndex;
                settings.locationName =locationSelector.model.results[selectedIndex].name[0]
                settings.locationLongitude=locationSelector.model.results[selectedIndex].longitude[0]
                settings.locationLatitude=locationSelector.model.results[selectedIndex].latitude[0]
                settings.locationTimeZone=locationSelector.model.results[selectedIndex].timeZone[0]
                console.log(settings.locationName+" "+settings.locationLongitude+" "+settings.locationLatitude+" "
                            +settings.locationTimeZone)
            }
        }

        Row {
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: units.gu(2)
            Button {
                iconName: "edit"
              //  text: i18n.tr("Edit location")
                onClicked:{
                    PopupUtils.open(Qt.resolvedUrl("LocationDialog.qml"),parent, {
                                        locationDocId:locationSelector.model.documents[locationSelector.selectedIndex],
                                        locationName: locationSelector.model.results[locationSelector.selectedIndex].name[0],
                                        locationLongitude:locationSelector.model.results[locationSelector.selectedIndex].longitude[0],
                                        locationLatitude:locationSelector.model.results[locationSelector.selectedIndex].longitude[0],
                                        locationTimeZone:locationSelector.model.results[locationSelector.selectedIndex].timeZone[0]})

                }
            }
            Button {
                iconName: "add"
               // text: i18n.tr("New loaction")
                onClicked:{
                    PopupUtils.open(Qt.resolvedUrl("LocationDialog.qml"),parent)
                }
            }
            Button {
                iconName: "delete"
                //text: i18n.tr("Delete loaction")
                onClicked:{
                        loacationDatabase.deleteDoc(locationSelector.model.documents[locationSelector.selectedIndex]);
                        locationSelector.updateSettings("")
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
