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
import "dateExt.js" as DateExt
import HebrewCalendar 1.0

Row{
    id: header

    property var startDay: hebrewDate.today();
    property bool isCurrentItem: false
    property var currentDay

    signal dateSelected(var date);

    width: parent.width
    HDate{
        id:hebrewDate
    }
    Repeater{
        model: 7

        delegate: HeaderDateComponent{
            date: hebrewDate.addDays(startDay,index);
            dayFormat: Locale.ShortFormat

            dayColor: {
                if(  date === currentDay ) {
                    UbuntuColors.orange
                } else {
                    UbuntuColors.darkGrey
                }
            }

            width: header.width/7

            onDateSelected: {
                header.dateSelected(date);
            }
        }
    }
}

