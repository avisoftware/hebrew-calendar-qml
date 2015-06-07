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

Item{
    id: header
    width: parent.width
    height: monthLabel.height

    property int month;
    property int year;

    property string monthLabelFontSize: "x-large"
    property string yearLabelFontSize: "large"
    HDate{
        id:hebrewDate
    }
    Label{
        id: monthLabel
        objectName: "monthLabel"
        fontSize: monthLabelFontSize
        text: hebrewDate.getHebMonthStr(month)
        anchors.leftMargin: units.gu(1)
        anchors.left: parent.left
        color:"black"
        anchors.verticalCenter: parent.verticalCenter
    }

    Label{
        id: yearLabel
        objectName: "yearLabel"
        fontSize: yearLabelFontSize
        text: hebrewDate.intToHebStr(year)
        anchors.right: parent.right
        anchors.rightMargin: units.gu(1)
        color:"black"
        anchors.verticalCenter: parent.verticalCenter
    }
}
