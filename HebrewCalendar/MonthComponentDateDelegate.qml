import QtQuick 2.0
import Ubuntu.Components 1.1
import HebrewCalendar 1.0

Item{
    id: dateRootItem

    property int date;
    property bool isCurrentMonth;
    property bool isToday;
    property int isHoliday:0
    property alias fontSize: dateLabel.font.pixelSize
    HDate{
        id:hebrewDate
    }

    Loader {
        sourceComponent: {
            if(isToday && isCurrentMonth ){
                 highLightComp
            }else if((isHoliday>0 && isHoliday<10) && isCurrentMonth ){
            holidayComp
        }else{
                  undefined
            }

        }
        onSourceComponentChanged: {
            width = Qt.binding( function() { return ( dateRootItem.height / 1.5 ); });
            height = Qt.binding ( function() { return width} );
            anchors.centerIn = Qt.binding( function() { return dateLabel});
        }
    }

    Label {
        id: dateLabel
        anchors.centerIn: parent
        text: isYearView ? hebrewDate.intToHebStr(date) : hebrewDate.intToHebStr(date)+"<br>"+"<span style='font-size:10px'>"+date+"</span>"
        textFormat: Text.RichText
        fontSize: root.dateLabelFontSize
        horizontalAlignment:Text.AlignHCenter
        color: {
            if( isCurrentMonth ) {
                if(isToday) {
                    "white"
                } else if(isHoliday){
                       "purple"
                }else {
                    "#5D5D5D"
                }
            } else {
                "#AEA79F"
            }
        }
    }

    Component{
        id: highLightComp
        UbuntuShape{
            color: "#DD4814"
        }
    }
    Component{
        id: holidayComp
        UbuntuShape{
            color: "lightblue"
        }
    }

    MouseArea {
        anchors.fill: parent

        onClicked: {
            var selectedDate = hebrewDate.addDays(intern.monthStart,index);

            //If monthView is clicked then open selected DayView
            if ( isYearView === false ) {
                root.dateSelected(selectedDate);
            }
            //If yearView is clicked then open selected MonthView
            else {
                root.monthSelected(selectedDate);
            }
        }
    }
}
