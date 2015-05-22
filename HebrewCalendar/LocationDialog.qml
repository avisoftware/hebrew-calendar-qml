import QtQuick 2.4
import Ubuntu.Components 1.2
import Ubuntu.Components.Popups 1.0


Dialog {
    id: dialogue
    property string locationName: "";
    property string locationTimeZone: "";
    property double locationLongitude: 0;
    property double locationLatitude: 0;

    title: locationName !="" ? i18n.tr("Edit Location"):i18n.tr("New Location")
    text: "??"
    TextField {
        placeholderText: "hint text"
        text: locationName
    }
    Button {
        text: "save"
        color: UbuntuColors.orange
        onClicked: PopupUtils.close(dialogue)
    }
    Button {
        text: "cancel"
        onClicked: PopupUtils.close(dialogue)
    }
}

