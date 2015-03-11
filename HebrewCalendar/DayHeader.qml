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

PathViewBase {
    id: header

//    property int type: ViewType.ViewTypeWeek

    interactive: false
    model:3

    height: units.gu(4)
    width: parent.width

    property var date;
    property var currentDay;

    signal dateSelected(var date);
    HDate{
        id:hebrewDate
    }
    delegate: DayHeaderComponent{
//        type: header.type

        isCurrentItem: index == header.currentIndex
        currentDay: header.currentDay

        width: parent.width

        startDay:hebrewDate.addDays( date,7*header.indexType(index))

        onDateSelected: {
            header.dateSelected(date);
        }
    }
}

