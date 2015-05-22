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
import HebrewCalendar 1.0
import "timeCalc.js" as TimeCalc
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
    Settings{
        id:settings
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
                 hebrewDate.calcTimes(dayViewPage.currentDay,settings.locationLongitude,settings.locationLatitude);
            }

            function nextDay() {
                if(hebrewDate.bigOrEquel(currentDay,hebrewDate.addDays(date,7))) {
                    date = hebrewDate.weekStart(dayViewPage.currentDay);
                    dayHeader.incrementCurrentIndex();
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

                        contentInteractive: parent.PathView.isCurrentItem
                        startDay: hebrewDate.addDays(dayViewPath.startDay,dayViewPath.indexType(index))
                        dayFullStr:hebrewDate.getDayFullStr(dayViewPage.currentDay)
                         dayHolidayStr:hebrewDate.getDayHolidayStr(dayViewPage.currentDay,settings.diaspora)
                         dayParashaStr:hebrewDate.getDayParashaStr(dayViewPage.currentDay,settings.diaspora)
                         dayOmerStr:hebrewDate.getDayOmerStr(dayViewPage.currentDay)
                        dayOmer:hebrewDate.getDayOmer(dayViewPage.currentDay)

                        // times
                        //firstLigthMga: TimeCalc.timeString(dateG, hebrewDate.getFirstLightMga(),settings.locationTimeZone)
                        firstLigthMga: getTimeString( hebrewDate.getFirstLightMga())
                        firstLigth:getTimeString(hebrewDate.getFirstLight())
                        talit:getTimeString(hebrewDate.getTalit())
                        sunrise:getTimeString(hebrewDate.getSunrise())

                        endShemaMga:getTimeString(hebrewDate.getFirstLightMga()+ (3 * getSunHouerMga()))
                        function getSunHouerMga(){
                            return (hebrewDate.getFirstStarsMga() - hebrewDate.getFirstLightMga()) / 12;
                        }
                        endShema:getTimeString(hebrewDate.getSunrise()+(3*hebrewDate.getSunHour()))
                        endTefilaMga:getTimeString(hebrewDate.getFirstLightMga()+ (4 * getSunHouerMga()))
                        endTefila:getTimeString(hebrewDate.getSunrise()+(4*hebrewDate.getSunHour()))
                        midday:getTimeString( hebrewDate.getMidday())
                        bigMincha:getTimeString(hebrewDate.getSunrise()+(6.5*hebrewDate.getSunHour()))
                        littleMincha:getTimeString(hebrewDate.getSunrise()+(9.5*hebrewDate.getSunHour()))
                        plugMincha:getTimeString(hebrewDate.getSunrise()+(10.75*hebrewDate.getSunHour()))
                        candelLight:getTimeString(hebrewDate.getSunset()-settings.candelLight)
                        sunset:getTimeString(hebrewDate.getSunset())

                        firstStars:getTimeString(hebrewDate.getFirstStars())
                        threeStars:getTimeString(hebrewDate.getThreeStars())
                        threeStarsCzhish:getTimeString(hebrewDate.getThreeStarsCzhish())
                        shabatEndRT:getTimeString(hebrewDate.getSunset()+72)
                        function getTimeString(min){
                            return(hebrewDate.getTimeString(dayViewPage.currentDay,min,settings.locationTimeZone));
                        }

                        // end times
                        isHoliday:hebrewDate.isDateHoliday(currentDay,settings.diaspora)
                        isTomorrowHoliday:hebrewDate.isDateBeforeHoliday(currentDay,settings.diaspora)

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
