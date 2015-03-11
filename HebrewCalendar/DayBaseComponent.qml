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
    property bool isActive: false
    property alias contentY: timeLineView.contentY
    property alias contentInteractive: timeLineView.interactive



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
                    text: i18n.tr("Day Times")
                    fontSize: "large"
                    horizontalAlignment:Text.horizontalCenter
                    color:"#5D5D5D"
                }
            ListItem.SingleValue {
                text: "Label"
                value: "Status"
            }
            ListItem.SingleValue {
                text: "Label"
                value: "Parameter"
            }
        }

//        Row {
//            width: parent.width
//            height: timeLineView.contentHeight
//        }

//        Row {
//            id: week

//            anchors {
//                fill: parent
//                leftMargin: units.gu(6)

//                rightMargin:units.gu(3)
//            }

//            Repeater {
//                model: 1

//                delegate: Item {
//                    anchors.top: parent.top
//                    width: parent.width


//                    height: parent.height
////                   day: hebrewDate.addDays(startDay,index)
//                    Loader{
//                        objectName: "weekdevider"
//                        height: parent.height
//                        width: units.gu(0.15)
//                        sourceComponent: undefined
//                    }


//                }
//            }
//        }
   }


}
