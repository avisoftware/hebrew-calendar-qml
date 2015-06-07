import QtQuick 2.4
import Ubuntu.Components 1.2
import Ubuntu.Components.Popups 1.0
import Ubuntu.Components.Themes.Ambiance 1.1

import QtPositioning 5.2
import U1db 1.0 as U1db

Dialog {
    id: dialogue
    property string locationDocId: "";
    property string locationName: "";
    property string locationTimeZone: "";
    property double locationLongitude ;
    property double locationLatitude;

    title: locationName !="" ? i18n.tr("Edit Location"):i18n.tr("New Location")
    TextField {
        id: nameTextFiled
        placeholderText: i18n.tr("Some Place")
        text: locationName

    }
    Label{
        text:i18n.tr("You can find long and lat <a href='http://www.latlong.net/'>here</a><br>if you get wrong times, check this.")
        textFormat: Text.StyledText
        linkColor: UbuntuColors.orange
        onLinkActivated: Qt.openUrlExternally(link)
    }
    Button {
        text: i18n.tr("use you GPS")
        color: UbuntuColors.warmGrey
        onClicked:{
            pos.start();
            longitudeTextField.text= pos.position.coordinate.longitude;
            latitudeTextField.text=   pos.position.coordinate.latitude;
            pos.stop();
        }
    }
    PositionSource {
        id: pos
        updateInterval: 1000
        active: false
    }
    TextField {
        id:longitudeTextField
        placeholderText: "35.22"
        validator: DoubleValidator{bottom: -180.0; top: 180.0;notation: DoubleValidator.StandardNotation;}
        errorHighlight:true
        text:locationLongitude!=0.0?locationLongitude:""
    }
    TextField {
        id:latitudeTextField
        placeholderText: "31.78"
        errorHighlight:true
        validator: DoubleValidator{bottom: -90.0; top: 90.0;notation: DoubleValidator.StandardNotation;}
        text: locationLatitude!=0.0?locationLatitude:""
    }
    Label{
        text:i18n.tr("You can find TimeZone <a href='http://en.wikipedia.org/wiki/List_of_tz_database_time_zones'>here</a><br>if you get wrong times, check this.")
        textFormat: Text.StyledText
        linkColor: UbuntuColors.orange
        onLinkActivated: Qt.openUrlExternally(link)
    }
    TextField {
        id: timeZoneTextField
        placeholderText: "Asia/Jerusalem"
        text: locationTimeZone
    }
    U1db.Document
    {id: aDcoument;
        database: loacationDatabase;
        create: false;
        defaults: { 'name':[nameTextFiled.text],
                    'latitude':[latitudeTextField.text],
                    'longitude':[longitudeTextField.text],
                    'timeZone':[timeZoneTextField.text]}
    }
    Label{
        id:emptyLabel
        text:i18n.tr("Dont leave empty fileds!")
        visible: false
        color: UbuntuColors.red
    }
    Button {
        text: i18n.tr("save")
        color: UbuntuColors.orange
        onClicked:{
            if(locationName!==""){
                if(fieldsAreEmpty()===0){
                    var doc = loacationDatabase.getDoc(locationDocId);
                    doc.name[0]=nameTextFiled.text
                    doc.latitude[0]=latitudeTextField.text
                    doc.longitude[0]=longitudeTextField.text
                    doc.timeZone[0] = timeZoneTextField.text

                    loacationDatabase.putDoc(doc,locationDocId);
                    locationSelector.updateSettings("");
                    PopupUtils.close(dialogue)
                }else{
                    emptyLabel.visible =true;
                }
            }else{
                if(fieldsAreEmpty()===0){
                    emptyLabel.visible =false;
                    if(findLocation()){
                        emptyLabel.text = i18n.tr("Location Name already exist");
                        emptyLabel.visible =true;
                    }else{
                        aDcoument.create=true;
                        locationSelector.updateSettings(nameTextFiled.text);
                        PopupUtils.close(dialogue)
                    }
                }else{
                    emptyLabel.visible =true;
                }
            }
            function findLocation(){
                var model =allQuery
                for(var i=0;i<model.results.length;i++){
                    if(model.results[i].name[0]===nameTextFiled.text){
                        return 1;
                    }
                }
                return 0;
            }

            function fieldsAreEmpty(){
                emptyLabel.visible =false;
                if(nameTextFiled.text===""){
                    return 1;
                }
                if(latitudeTextField.text===""){
                    return 1;
                }
                if(longitudeTextField.text===""){
                    return 1;
                }
                if(timeZoneTextField.text===""){
                    return 1;
                }
                return 0;
            }
        }
    }
    Button {
        text: i18n.tr("cancel")
        onClicked: PopupUtils.close(dialogue)
    }
}

