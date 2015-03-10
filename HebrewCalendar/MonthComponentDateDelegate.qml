import QtQuick 2.0
import Ubuntu.Components 1.1
import HebrewCalendar 1.0

Item{
    id: dateRootItem

    property int date;
    property bool isCurrentMonth;
    property bool isToday;
    property bool showEvent;
    property alias fontSize: dateLabel.font.pixelSize
    HDate{
        id:hebrewDate
    }

    Loader {
        sourceComponent: isToday && isCurrentMonth ? highLightComp : undefined
        onSourceComponentChanged: {
            width = Qt.binding( function() { return ( dateRootItem.height / 1.5 ); });
            height = Qt.binding ( function() { return width} );
            anchors.centerIn = Qt.binding( function() { return dateLabel});
        }
    }

    Label {
        id: dateLabel
        anchors.centerIn: parent
//        text: date
        text: isYearView ? hebrewDate.intToHebStr(date) : hebrewDate.intToHebStr(date)+"\n"+date
        fontSize: root.dateLabelFontSize
        horizontalAlignment:Text.AlignHCenter
        color: {
            if( isCurrentMonth ) {
                if(isToday) {
                    "white"
                } else {
                    "#5D5D5D"
                }
            } else {
                "#AEA79F"
            }
        }
    }

    Loader{
        width: units.gu(1)
        height: width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: dateLabel.bottom
        anchors.topMargin: dateRootItem.height/4
        sourceComponent: showEvent ? eventIndicatorComp : undefined
    }

    Component{
        id: eventIndicatorComp
        Rectangle {
            anchors.fill: parent
            radius: height/2
            color:"#5E2750"
        }
    }

    Component{
        id: highLightComp
        UbuntuShape{
            color: "#DD4814"
        }
    }

    MouseArea {
        anchors.fill: parent

        onClicked: {
//            var selectedDate = hebrewDate.setHebDate(intern.monthStartYear,
//                                        intern.monthStartMonth+1,
//                                         hebrewDate.getDay(hebrewDate.addDays(intern.monthStart,index)))

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
