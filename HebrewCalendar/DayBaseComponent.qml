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
import Ubuntu.Components.ListItems 1.0 as ListItem
import HebrewCalendar 1.0
import "timeCalc.js" as TimeCalc

Item {
    id: root    
    property var keyboardEventProvider;

    property var startDay: hebrewDate.today();
    property bool isActive: false
    property alias contentY: timeLineView.contentY
    property alias contentInteractive: timeLineView.interactive

    property string firstLigthMga;
    property string firstLigth;
    property string talit;
    property string sunrise;
    property string sunset

   onStartDayChanged: {
       hebrewDate.calcTimes(startDay);
       firstLigthMga= TimeCalc.timeString(hebrewDate.getFirstLightMga());
       firstLigth= TimeCalc.timeString(hebrewDate.getFirstLight());
       talit= TimeCalc.timeString(hebrewDate.getTalit());
       sunrise = TimeCalc.timeString(hebrewDate.getSunrise());
       sunset=TimeCalc.timeString(hebrewDate.getSunset());

   }

    HDate{
        id:hebrewDate
    }
   Flickable {
        id: timeLineView

       contentHeight: units.gu(8) * 24
       contentWidth: width
       anchors.fill: parent
       clip: true


        Column {

            anchors.fill: parent
            anchors.topMargin: units.gu(1)
            spacing: units.gu(1)




            Label {
                    id: dateLabel
                    anchors.horizontalCenter:  parent.horizontalCenter
                    text: i18n.tr("Day times")
                    fontSize: "large"
                    horizontalAlignment:Text.horizontalCenter
                    color:"#5D5D5D"
                }
            ListItem.SingleValue {
                text: i18n.tr("First ligth (mga)")
                value: firstLigthMga

            }
            ListItem.SingleValue {
                text: i18n.tr("First light")
                value: firstLigth

            }
            ListItem.SingleValue {
                text: i18n.tr("Talit")
                value: talit

            }
            ListItem.SingleValue {
                text: i18n.tr("Sunrise")
                value: sunrise

            }
            ListItem.SingleValue {
               text: i18n.tr("Sunset")
                value: sunset
            }
        }
   }
}
