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
import Ubuntu.Components.Popups 1.0
import Ubuntu.Components.ListItems 1.0 as ListItem
import HebrewCalendar 1.0


Item {
    id: root
    property var keyboardEventProvider;

    property var startDay: hebrewDate.today();
    property string dayFullStr;
    property string dayHolidayStr;
    property string dayParashaStr;
    property string dayOmerStr;
    property int dayOmer;

    property alias contentY: timeLineView.contentY
    property alias contentInteractive: timeLineView.interactive
    // times
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
    property string candleLight;
    property string sunset;
    property string firstStars;
    property string threeStars;
    property string threeStarsCzhish;
    property string shabatEndRT;

    property int isHoliday: 0;
    property bool isTomorrowHoliday: false;
    property bool mirror: Qt.locale().textDirection == Qt.RightToLeft
    HDate{
        id:hebrewDate
    }
//    Settings{
//        id:settings
//    }
    Flickable {

        id: timeLineView
        contentHeight: column.height
        contentWidth: width

        anchors.fill: parent
        clip: true
        boundsBehavior:Flickable.StopAtBounds
        Column {
            id: column
            anchors.topMargin: units.gu(0)
            spacing: units.gu(0)
            anchors {
                left: parent.left;
                right: parent.right;
            }
            ListItem.Header  {
                text: i18n.tr("Day details")
            }
            ListItem.Standard {
                text:i18n.tr("Day ")+dayFullStr
            }
            ListItem.Standard {
                text:dayHolidayStr
                visible:dayHolidayStr!=""
            }
            ListItem.Standard {
                text:i18n.tr("Parashat ")+dayParashaStr
                visible:dayParashaStr!=""
            }

            ListItem.Expandable {
                id: omerExpandItem
                expandedHeight: content.height + units.gu(1)
                collapseOnClick: true
                visible:dayOmerStr!=""
                onClicked: {
                    expanded = true;
                }
                Column {
                    id: content
                    anchors { left: parent.left; right: parent.right }
                    Item {
                        anchors { left: parent.left; right: parent.right}
                        height: omerExpandItem.collapsedHeight
                        Label {
                            anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter}
                            text: dayOmerStr  +  i18n.tr("(click to expand)")
                        }
                    }

                    UbuntuShape {
                        id:borderOmer
                        anchors { left: parent.left; right: parent.right }
                        height: fullStrOmerL.height +units.gu(1)
                        color: "khaki"
                        Label {
                            id:fullStrOmerL
                            anchors.centerIn:borderOmer
                            horizontalAlignment:Text.AlignHCenter
                            // anchors { left: parent.left; right: parent.right; }
                            text: hebrewDate.getDayOmerFullStr(dayOmer,settings.nosach)
                        }
                    }
                }
            }
            ListItem.Header  {
                text: {
                   if(isHoliday===10){
                      i18n.tr("Shabat Times")
                   }else if(isHoliday===1){
                       i18n.tr("Holyday Times")
                   }else if(isHoliday===5){
                       i18n.tr("Fast Times")
                   }else if(isTomorrowHoliday){
                        i18n.tr("Holyday and Shabat Times");
                   }else{
                       "";
                   }
                }
                visible:{
                   if ((isHoliday==10||isHoliday==1||isHoliday==5)||isTomorrowHoliday){
                       return true;
                   }else{
                       return false;
                   }
                }
            }
            ListItem.SingleValue {
                text: i18n.tr("Candle light")
                value: candleLight
                visible:isTomorrowHoliday
                LayoutMirroring.enabled: mirror
            }
            ListItem.SingleValue {
                text: i18n.tr("Three stars")
                value: threeStars
                visible: {
                    if ((isHoliday==10||isHoliday==1)||isHoliday==5){
                             return true;
                         }else{
                             return false;
                         }
                }
                LayoutMirroring.enabled: mirror
            }
            ListItem.SingleValue {
                text: i18n.tr("Three stars czhish")
                value: threeStarsCzhish
                visible: {
                    if ((isHoliday==10||isHoliday==1)||isHoliday==5){
                             return true;
                         }else{
                             return false;
                         }
                }
                LayoutMirroring.enabled: mirror
            }
            ListItem.SingleValue {
                text: i18n.tr("Three stars RT (72 minute)")
                value: shabatEndRT
                visible: {
                    if ((isHoliday==10||isHoliday==1)||isHoliday==5){
                             return true;
                         }else{
                             return false;
                         }
                }
                LayoutMirroring.enabled: mirror
            }
            ListItem.Header  {
                text: i18n.tr("Day times")
            }
            ListItem.SingleValue {
                text: i18n.tr("First ligth (mga)")
                value: firstLigthMga
                LayoutMirroring.enabled: mirror
            }
            ListItem.SingleValue {
                text: i18n.tr("First light")
                value: firstLigth
                LayoutMirroring.enabled: mirror
            }
            ListItem.SingleValue {
                text: i18n.tr("Talit")
                value: talit
                LayoutMirroring.enabled: mirror
            }
            ListItem.SingleValue {
                text: i18n.tr("Sunrise")
                value: sunrise
                LayoutMirroring.enabled: mirror
            }
            ListItem.SingleValue {
                text: i18n.tr("End shema (mga)")
                value: endShemaMga
                LayoutMirroring.enabled: mirror
            }
            ListItem.SingleValue {
                text: i18n.tr("End shema")
                value: endShema
                LayoutMirroring.enabled: mirror
            }
            ListItem.SingleValue {
                text: i18n.tr("End tefila mga")
                value: endTefilaMga
                LayoutMirroring.enabled: mirror
            }
            ListItem.SingleValue {
                text: i18n.tr("End tefila")
                value: endTefila
                LayoutMirroring.enabled: mirror
            }
            ListItem.SingleValue {
                text: i18n.tr("Midday")
                value: midday
                LayoutMirroring.enabled: mirror
            }
            ListItem.SingleValue {
                text: i18n.tr("Big mincha")
                value: bigMincha
                LayoutMirroring.enabled: mirror
            }
            ListItem.SingleValue {
                text: i18n.tr("Little mincha")
                value: littleMincha
                LayoutMirroring.enabled: mirror
            }
            ListItem.SingleValue {
                text: i18n.tr("Plug mincha")
                value: plugMincha
                LayoutMirroring.enabled: mirror
            }
            ListItem.SingleValue {
                text: i18n.tr("Sunset")
                value: sunset
                LayoutMirroring.enabled: mirror
            }
            ListItem.SingleValue {
                text: i18n.tr("First stars")
                value: firstStars
                LayoutMirroring.enabled: mirror
            }
        }
    }
}
