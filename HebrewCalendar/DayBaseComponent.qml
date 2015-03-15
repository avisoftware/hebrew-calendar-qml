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

    property string sunset;

    property bool isHoliday: false;
    property bool isTomorrowHoliday: false;

    property string firstStars;
    property string threeStars;
    property string threeStarsCzhish;


    onStartDayChanged: {
        //TODO: move it to dayview?
        hebrewDate.calcTimes(startDay);
        firstLigthMga= TimeCalc.timeString(hebrewDate.getFirstLightMga());
        firstLigth= TimeCalc.timeString(hebrewDate.getFirstLight());
        talit= TimeCalc.timeString(hebrewDate.getTalit());
        sunrise = TimeCalc.timeString(hebrewDate.getSunrise());

        endShemaMga= TimeCalc.timeString(hebrewDate.getFirstLightMga()+ (3 * getSunHouerMga()));
        function getSunHouerMga(){
            return (hebrewDate.getFirstStarsMga() - hebrewDate.getFirstLightMga()) / 12;
        }

        endShema= TimeCalc.timeString(hebrewDate.getSunrise()+(3*hebrewDate.getSunHour()));
        endTefilaMga= TimeCalc.timeString(hebrewDate.getFirstLightMga()+ (4 * getSunHouerMga()));
        endTefila= TimeCalc.timeString(hebrewDate.getSunrise()+(4*hebrewDate.getSunHour()));

        midday=TimeCalc.timeString(hebrewDate.getMidday());

        bigMincha= TimeCalc.timeString(hebrewDate.getSunrise()+(6.5*hebrewDate.getSunHour()));
        littleMincha= TimeCalc.timeString(hebrewDate.getSunrise()+(9.5*hebrewDate.getSunHour()));
        plugMincha= TimeCalc.timeString(hebrewDate.getSunrise()+(10.75*hebrewDate.getSunHour()));

        sunset=TimeCalc.timeString(hebrewDate.getSunset());

        firstStars=TimeCalc.timeString(hebrewDate.getFirstStars());
        threeStars=TimeCalc.timeString(hebrewDate.getThreeStars());
        threeStarsCzhish=TimeCalc.timeString(hebrewDate.getThreeStarsCzhish());


    }

    HDate{
        id:hebrewDate
    }
    Flickable {
        id: timeLineView
        contentHeight: units.gu(8) * 16
        contentWidth: width
        anchors.fill: parent
        clip: true
        boundsBehavior:Flickable.StopAtBounds
        Column {
            anchors.fill: parent
            anchors.topMargin: units.gu(1)
            spacing: units.gu(1)



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

            ListItem.Header  {
                text: i18n.tr("Shabat Times")
                visible:isHoliday
            }
            ListItem.SingleValue {
                text: i18n.tr("First stars")
                value: firstStars
                visible:isHoliday
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
        }
    }
}
