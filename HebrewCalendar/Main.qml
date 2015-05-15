import QtQuick 2.3
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0
import HebrewCalendar 1.0

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"
//    Qt.application.name: "hebrew-calender"
//    Qt.application.organization:"avisoftware"
    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "hebrew-calender.avisoftware"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    // Removes the old toolbar and enables new features of the new header.
    useDeprecatedToolbar: false
    Settings{
        id:settings
    }

    width: units.gu(100)
    height: units.gu(80)
    focus: true
    Keys.forwardTo: [pageStack.currentPage]
    headerColor: "#E8E8E8"
    backgroundColor: "#f5f5f5"
    footerColor: "#ECECEC"
    anchorToKeyboard: true

    PageStack {
        id: pageStack
        Component.onCompleted: push(tabs)
        HDate{
            id:hebrewDate
        }
        Tabs{
            id: tabs
            Keys.forwardTo: [tabs.currentPage.item]

            property var currentDay: hebrewDate.today();


            selectedTabIndex: monthTab.index

            Component.onCompleted: {
                tabs.selectedTabIndex= 1;
            }

            Keys.onTabPressed: {
                if( event.modifiers & Qt.ControlModifier) {
                    var currentTab = tabs.selectedTabIndex;
                    currentTab ++;
                    if( currentTab >= tabs.tabChildren.length){
                        currentTab = 0;
                    }
                    tabs.selectedTabIndex = currentTab;
                }
            }

            Keys.onBacktabPressed: {
                if( event.modifiers & Qt.ControlModifier) {
                    var currentTab = tabs.selectedTabIndex;
                    currentTab --;
                    if( currentTab < 0){
                        currentTab = tabs.tabChildren.length -1;
                    }
                    tabs.selectedTabIndex = currentTab;
                }
            }

            Tab{
                id: yearTab
                objectName: "yearTab"
                title: i18n.tr("Year")
                page: Loader{
                    id: yearViewLoader
                    objectName: "yearViewLoader"
                    source: tabs.selectedTab == yearTab ? Qt.resolvedUrl("YearView.qml"):""
                    onLoaded: {
                        item.currentYear = hebrewDate.getYear(tabs.currentDay);
                    }

                    anchors{
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                    }

                    Connections{
                        target: yearViewLoader.item
                        onMonthSelected: {
                            var now = hebrewDate.today();
                            if( hebrewDate.getMonth(date) === hebrewDate.getMonth(now)
                                    && hebrewDate.getYear(date) === hebrewDate.getYear(now)) {
                                tabs.currentDay = now;
                            } else {
                                tabs.currentDay = date;
                            }
                            tabs.selectedTabIndex = monthTab.index;
                        }
                    }
                }
            }

            Tab{
                id: monthTab
                objectName: "monthTab"
                title: i18n.tr("Month")
                page: Loader{
                    id: monthViewLoader
                    objectName: "monthViewLoader"
                    source: tabs.selectedTab == monthTab ? Qt.resolvedUrl("MonthView.qml"):""
                    onLoaded: {
                        item.currentMonth = tabs.currentDay
                    }

                    anchors{
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                    }

                    Connections{
                        target: monthViewLoader.item
                        onDateSelected: {
                            tabs.currentDay = date;
                            tabs.selectedTabIndex = dayTab.index;
                        }
                    }
                }
            }


            Tab{
                id: dayTab
                objectName: "dayTab"
                title: i18n.tr("Day")
                page: Loader{
                    id: dayViewLoader
                    objectName: "dayViewLoader"
                    source: tabs.selectedTab == dayTab ? Qt.resolvedUrl("DayView.qml"):""
                    onLoaded: {
                        item.isCurrentPage= Qt.binding(function() { return tabs.selectedTab == dayTab })
                        item.currentDay = tabs.currentDay;
                    }

                    anchors{
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                    }

                    Connections{
                        target: dayViewLoader.item
                        onCurrentDayChanged: {
                            tabs.currentDay = dayViewLoader.item.currentDay;
                        }

                        onDateSelected: {
                            tabs.currentDay = date;
                        }
                    }
                }
            }

        }
    }
}

