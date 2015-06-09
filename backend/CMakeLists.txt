include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
)

set(
    HebrewCalendarbackend_SRCS
    modules/HebrewCalendar/backend.cpp
    modules/HebrewCalendar/hebdate.cpp
    modules/HebrewCalendar/hebdate.h
    modules/HebrewCalendar/omerFullStr.cpp
)

add_library(HebrewCalendarbackend MODULE
    ${HebrewCalendarbackend_SRCS}
)

set_target_properties(HebrewCalendarbackend PROPERTIES
         LIBRARY_OUTPUT_DIRECTORY HebrewCalendar)

qt5_use_modules(HebrewCalendarbackend Gui Qml Quick)

## h requires hdate
find_path(HDATE_INCLUDE_DIR
          NAMES hdate.h
          HINTS /usr/include
          )
find_library(HDATE_LIBRARIES NAMES hdate)
message(STATUS "hdate include=${HDATE_INCLUDE_DIR}")
message(STATUS "hdate lib=${HDATE_LIBRARIES}=${HDATE_LIBRARIES}")

if(HDATE_INCLUDE_DIR AND HDATE_LIBRARIES)
   message(STATUS "Found hdate: include=${HDATE_INCLUDE_DIR}  library=${HDATE_LIBRARIES}")
   INCLUDE_DIRECTORIES(${HDATE_INCLUDE_DIR})
   TARGET_LINK_LIBRARIES(HebrewCalendarbackend ${HDATE_LIBRARIES})
else(HDATE_INCLUDE_DIR AND HDATE_LIBRARIES)
   message(FATAL_ERROR "Could not find hdate")
endif(HDATE_INCLUDE_DIR AND HDATE_LIBRARIES)
mark_as_advanced(HDATE_INCLUDE_DIR HDATE_LIBRARIES)
## end hdate confiuration

# Copy qmldir file to build dir for running in QtCreator
add_custom_target(HebrewCalendarbackenddir ALL
    COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/modules/HebrewCalendar/qmldir ${CMAKE_CURRENT_BINARY_DIR}/HebrewCalendar
    DEPENDS ${QMLFILES}
)

# Install plugin file
install(TARGETS HebrewCalendarbackend DESTINATION ${QT_IMPORTS_DIR}/HebrewCalendar/)
install(FILES   modules/HebrewCalendar/qmldir DESTINATION ${QT_IMPORTS_DIR}/HebrewCalendar/)

