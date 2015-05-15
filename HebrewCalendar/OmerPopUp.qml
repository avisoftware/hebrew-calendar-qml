import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0
import Ubuntu.Components.ListItems 1.0 as ListItem
import HebrewCalendar 1.0
import Qt.labs.settings 1.0

Popover {
    id: popover
    property int dayInOmer;
    property string nosach: "a";
        Label {
           horizontalAlignment:Text.AlignHCenter
           width: parent.width
            text: hebrewDate.getDayOmerFullStr(dayInOmer,settings.nosach)
            fontSize: "large"
        }
}
