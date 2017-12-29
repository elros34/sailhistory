# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = sailhistory

CONFIG += sailfishapp

QT += sql

DEFINES += QT_NO_DEBUG_OUTPUT

SOURCES += \
    src/main.cpp \
    src/historymodel.cpp \
    src/historyitem.cpp \
    src/historyfilter.cpp

DISTFILES += qml/sailhistory.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    rpm/sailhistory.changes.in \
    rpm/sailhistory.changes.run.in \
    rpm/sailhistory.spec \
    rpm/sailhistory.yaml \
    translations/*.ts \
    sailhistory.desktop \
    qml/pages/HistoryPage.qml \
    qml/components/GlowSeparator.qml

SAILFISHAPP_ICONS = 86x86 108x108 128x128

# to disable building translations every time, comment out the
# following CONFIG line
# CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
# TRANSLATIONS += translations/sailhistory-de.ts

HEADERS += \
    src/historymodel.h \
    src/historyitem.h \
    src/historyfilter.h
