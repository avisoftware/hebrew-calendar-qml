TEMPLATE = aux
TARGET = HebrewCalendar

RESOURCES += HebrewCalendar.qrc

QML_FILES += $$files(*.qml,true) \
					   $$files(*.js,true)

CONF_FILES +=  HebrewCalendar.apparmor \
               HebrewCalendar.desktop \
               HebrewCalendar.png

OTHER_FILES += $${CONF_FILES} \
               $${QML_FILES} \
    timeCalc.js \
    Settings.qml \
    SettingsView.qml

#specify where the qml/js files are installed to
qml_files.path = /HebrewCalendar
qml_files.files += $${QML_FILES}

#specify where the config files are installed to
config_files.path = /HebrewCalendar
config_files.files += $${CONF_FILES}

INSTALLS+=config_files qml_files

