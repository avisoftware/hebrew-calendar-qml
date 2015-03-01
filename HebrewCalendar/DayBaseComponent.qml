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
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0
import "dateExt.js" as DateExt
import "ViewType.js" as ViewType

Item {
    id: root

    property var keyboardEventProvider;

    property var startDay: DateExt.today();
    property bool isActive: false
    property alias contentY: timeLineView.contentY
    property alias contentInteractive: timeLineView.interactive


    //visible hour
    property int scrollHour;

    function scrollToCurrentTime() {
        var currentTime = new Date();
        scrollHour = currentTime.getHours();

        timeLineView.contentY = scrollHour * units.gu(8);
        if(timeLineView.contentY >= timeLineView.contentHeight - timeLineView.height) {
            timeLineView.contentY = timeLineView.contentHeight - timeLineView.height
        }
    }

    Connections{
        target: keyboardEventProvider
        onScrollUp:{
            scrollHour--;
            if( scrollHour < 0) {
                scrollHour =0;
            }
            scrollToHour();
        }

        onScrollDown:{
            scrollHour++;
            var visibleHour = root.height / units.gu(8);
            if( scrollHour > (25 -visibleHour)) {
                scrollHour = 25 - visibleHour;
            }
            scrollToHour();
        }
    }

    function scrollToHour() {
        timeLineView.contentY = scrollHour * units.gu(8);
        if(timeLineView.contentY >= timeLineView.contentHeight - timeLineView.height) {
            timeLineView.contentY = timeLineView.contentHeight - timeLineView.height
        }
    }


    ActivityIndicator {
        visible: running
        objectName : "activityIndicator"
        running: mainModel.isLoading
        anchors.centerIn: parent
        z:2
    }



    Flickable {
        id: timeLineView

        contentHeight: units.gu(8) * 24
        contentWidth: width
        anchors.fill: parent

        clip: true

        Row {
            width: parent.width
            height: timeLineView.contentHeight
        }

        Row {
            id: week

            anchors {
                fill: parent
                leftMargin: units.gu(6)

                rightMargin:units.gu(3)
            }

            Repeater {
                model: 1

                delegate: Item {
                    anchors.top: parent.top
                    width: parent.width


                    height: parent.height
//                    day: startDay.addDays(index)
                    Loader{
                        objectName: "weekdevider"
                        height: parent.height
                        width: units.gu(0.15)
                        sourceComponent: undefined
                    }

                    Connections{
                        target: mainModel
                        onStartPeriodChanged:{
                            destroyAllChildren();
                        }
                    }
                }
            }
        }
    }


}
