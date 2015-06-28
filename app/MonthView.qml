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

Page {
    id: monthViewPage
    objectName: "monthViewPage"
    property var currentMonth: hebrewDate.today();
    signal dateSelected(var date);
    HDate{
        id:hebrewDate
    }
    Settings{
        id:settings
    }
    Keys.forwardTo: [monthViewPath]
    Action {
        id: calendarTodayAction
        objectName:"todaybutton"
        iconName: "calendar-today"
        text: i18n.tr("Today")
        onTriggered: {
            currentMonth = hebrewDate.today()
        }
    }

    head {
        actions: [
            calendarTodayAction
        ]
        contents: Label {
            fontSize: "x-large"
            text: hebrewDate.currentMonthStr(currentMonth)
            font.capitalization: Font.Capitalize
        }
    }

    PathViewBase{
        id: monthViewPath
        objectName: "monthViewPath"
        property var startMonth: currentMonth;
        anchors.top:parent.top
        width:parent.width
        height: parent.height
        onNextItemHighlighted: {
            nextMonth();
        }
        onPreviousItemHighlighted: {
            previousMonth();
        }

        function nextMonth() {
            currentMonth = addMonth(currentMonth, 1);
        }

        function previousMonth() {
            currentMonth = addMonth(currentMonth, -1);
        }

        function addMonth(date,month) {
            return hebrewDate.addMonths(date,month)
        }

        delegate: Loader {
            width: parent.width - units.gu(4)
            height: parent.height
            sourceComponent: delegateComponent
            asynchronous: index !== monthViewPath.currentIndex
            Component {
                id: delegateComponent
                MonthComponent {
                    isCurrentItem: index === monthViewPath.currentIndex
                    anchors.fill: parent
                    currentMonth: monthViewPath.addMonth(monthViewPath.startMonth,
                                                         monthViewPath.indexType(index));
                    isYearView: false
                    onDateSelected: {
                        monthViewPage.dateSelected(date);
                    }
                }
            }
        }
    }
}
