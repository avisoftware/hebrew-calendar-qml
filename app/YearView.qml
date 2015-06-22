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
    id: yearViewPage
    objectName: "yearViewPage"

    property int currentYear: hebrewDate.getYear(hebrewDate.today());
    signal monthSelected(var date);

    Keys.forwardTo: [yearPathView]

    Action {
        id: calendarTodayAction
        objectName:"todaybutton"
        iconName: "calendar-today"
        text: i18n.tr("Today")
        onTriggered: {
            currentYear = hebrewDate.getYear(hebrewDate.today())
        }
    }

    head {
        actions: [
            calendarTodayAction
        ]
        contents: Label {
            id:year
            objectName:"yearLabel"
            fontSize: "x-large"
            text: i18n.tr("Year %1").arg(hebrewDate.intToHebStr(currentYear))
           // anchors.leftMargin: units.gu(1)
        }
    }
    HDate{
        id:hebrewDate
    }
    Settings{
        id:settings
    }
    PathViewBase {
        id: yearPathView
        objectName: "yearPathView"

        anchors.fill: parent

        onNextItemHighlighted: {
            currentYear = currentYear + 1;
        }

        onPreviousItemHighlighted: {
            currentYear = currentYear - 1;
        }

        delegate: Loader {
            width: parent.width
            height: parent.height
            anchors.top: parent.top

            asynchronous: index !== yearPathView.currentIndex
            sourceComponent: delegateComponent

            Component{
                id: delegateComponent

                YearViewDelegate{
                    focus: index == yearPathView.currentIndex

                    scrollMonth: 0;
                    isCurrentItem: index == yearPathView.currentIndex
                    year: (yearViewPage.currentYear + yearPathView.indexType(index))

                    anchors.fill: parent
                }
            }
        }
    }
}
