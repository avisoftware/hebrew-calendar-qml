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


Item {
    id: root
    property var keyboardEventProvider;

    property var startDay: hebrewDate.today();
    //    property bool isActive: false
    property alias contentY: timeLineView.contentY
    property alias contentInteractive: timeLineView.interactive

    property string firstLigthMga;
    property string firstLigth;
    property string talit;
    property string sunrise;

    property string endShemaMga;
    property string endShema;
    property string endTefilaMga;
    property string endTefila;

    property string midday;

    property string bigMincha;
    property string littleMincha;
    property string plugMincha;
    property string candelLight;
    property string sunset;

    property string firstStars;
    property string threeStars;
    property string threeStarsCzhish;
    property string shabatEndRT;

    property bool isHoliday: false;
    property bool isTomorrowHoliday: false;



    HDate{
        id:hebrewDate
    }
    Flickable {
        id: timeLineView
        contentHeight: units.gu(8) * 14
        contentWidth: width
        anchors.fill: parent
        clip: true
        boundsBehavior:Flickable.StopAtBounds
        Column {
            anchors.fill: parent
            anchors.topMargin: units.gu(0)
            spacing: units.gu(0)

            ListItem.Header  {
                text: i18n.tr("Shabat Times")
                visible:isHoliday||isTomorrowHoliday
            }
            ListItem.SingleValue {
                text: i18n.tr("Candel light")
                value: candelLight
                visible:isTomorrowHoliday
            }

            ListItem.SingleValue {
                text: i18n.tr("Three stars")
                value: threeStars
                visible:isHoliday
            }
            ListItem.SingleValue {
                text: i18n.tr("Three stars czhish")
                value: threeStarsCzhish
                visible:isHoliday
            }
            ListItem.SingleValue {
                text: i18n.tr("Shabat end RT (72 minute)")
                value: shabatEndRT
                visible:isHoliday
            }


            ListItem.Header  {
                text: i18n.tr("Day times")
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
                text: i18n.tr("End shema (mga)")
                value: endShemaMga
            }
            ListItem.SingleValue {
                text: i18n.tr("End shema")
                value: endShema
            }
            ListItem.SingleValue {
                text: i18n.tr("End tefila mga")
                value: endTefilaMga
            }
            ListItem.SingleValue {
                text: i18n.tr("End tefila")
                value: endTefila
            }
            ListItem.SingleValue {
                text: i18n.tr("Midday")
                value: midday
            }
            ListItem.SingleValue {
                text: i18n.tr("Big mincha")
                value: bigMincha
            }
            ListItem.SingleValue {
                text: i18n.tr("Little mincha")
                value: littleMincha
            }
            ListItem.SingleValue {
                text: i18n.tr("Plug mincha")
                value: plugMincha
            }
            ListItem.SingleValue {
                text: i18n.tr("Sunset")
                value: sunset
            }
            ListItem.SingleValue {
                text: i18n.tr("First stars")
                value: firstStars
            }


        }
    }
}
