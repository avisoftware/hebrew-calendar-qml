/*
 * Copyright (C) 2013-2014 Canonical Ltd
 *
 * This file is part of Ubuntu Calendar App
 *
 * Ubuntu Calendar App is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * Ubuntu Calendar App is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.3
import Ubuntu.Components 1.1
//import "dateExt.js" as DateExt
import HebrewCalendar 1.0

Page{
    id: dayViewPage
    objectName: "dayViewPage"

    property var currentDay: hebrewDate.today()
    property bool isCurrentPage: false

    signal dateSelected(var date);

    Keys.forwardTo: [dayViewPath]
    flickable: null

    Action {
        id: calendarTodayAction
        objectName:"todaybutton"
        iconName: "calendar-today"
        text: i18n.tr("Today")
        onTriggered: {
            currentDay = hebrewDate.today()
        }
    }

    head {
        actions: [
            calendarTodayAction
        ]

        contents: Label {
            id:monthYear
            objectName:"monthYearLabel"
            fontSize: "x-large"
            text: hebrewDate.intToHebStr(hebrewDate.getDay(currentDay)) + " " +
                  hebrewDate.getHebMonthStr(hebrewDate.getMonth(currentDay))+" " +
                  hebrewDate.intToHebStr(hebrewDate.getYear(currentDay))
            font.capitalization: Font.Capitalize
        }
    }
    HDate{
        id:hebrewDate
    }
    Column {
        anchors.fill: parent
        anchors.topMargin: units.gu(1)
        spacing: units.gu(1)

        DayHeader{
            id: dayHeader
            objectName: "dayHeader"
//            type: ViewType.ViewTypeDay
            currentDay: dayViewPage.currentDay

            onDateSelected: {
                dayViewPage.currentDay = date;
                dayViewPage.dateSelected(date);
            }

            onCurrentDayChanged: {
                date = hebrewDate.weekStart(dayViewPage.currentDay);                
            }

            function nextDay() {
                if(hebrewDate.bigOrEquel(currentDay,hebrewDate.addDays(date,7))) {
                   date = hebrewDate.weekStart(dayViewPage.currentDay);
                    dayHeader.incrementCurrentIndex();
                    console.log("1")
                }
            }

            function previousDay() {
                if( hebrewDate.smallTo(currentDay,date) ) {
                    date = hebrewDate.weekStart(dayViewPage.currentDay);
                    dayHeader.decrementCurrentIndex();
                }
            }
        }

        PathViewBase{
            id: dayViewPath
            objectName: "dayViewPath"

            property var startDay: currentDay
            //This is used to scroll all view together when currentItem scrolls
            property var childContentY;

            width: parent.width
            height: dayViewPage.height - dayViewPath.y

            onNextItemHighlighted: {
                //next day
                currentDay = hebrewDate.addDays(currentDay,1);
                 dayHeader.nextDay();
                }

            onPreviousItemHighlighted: {
                //previous day
                currentDay = hebrewDate.addDays(currentDay,-1);
                  dayHeader.previousDay();
            }

            delegate: Loader {
                width: parent.width
                height: parent.height
                asynchronous: index !== dayViewPath.currentIndex
                sourceComponent: delegateComponent

                Component {
                    id: delegateComponent
                    DayBaseComponent {
                        id: timeLineView
                        objectName: "DayComponent-"+index

                        anchors.fill: parent

//                        isActive: parent.PathView.isCurrentItem
                        contentInteractive: parent.PathView.isCurrentItem
                        startDay: hebrewDate.addDays(dayViewPath.startDay,dayViewPath.indexType(index))
                        isHoliday:hebrewDate.isDateHoliday(currentDay)
                        isTomorrowHoliday:hebrewDate.isDateBeforeHoliday(currentDay)
                        keyboardEventProvider: dayViewPath

                        //get contentY value from PathView, if its not current Item
                        Binding{
                            target: timeLineView
                            property: "contentY"
                            value: dayViewPath.childContentY;
                            when: !parent.PathView.isCurrentItem
                        }

                        //set PathView's contentY property, if its current item
                        Binding{
                            target: dayViewPath
                            property: "childContentY"
                            value: contentY
                            when: parent.PathView.isCurrentItem
                        }
                    }
                }
            }
        }
    }
}
