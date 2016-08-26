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
TARGET = harbour-vodcounter

CONFIG += sailfishapp c++11
PKGCONFIG += libcrypto

SOURCES += src/harbour-vodcounter.cpp \
    src/apirequest.cpp \
    src/machineid.cpp \
    src/localstoragefile.cpp \
    src/cryptography/aes256.cpp

OTHER_FILES += qml/harbour-vodcounter.qml \
    qml/cover/CoverPage.qml \
    qml/cover/*.png \
    rpm/harbour-vodcounter.changes.in \
    rpm/harbour-vodcounter.spec \
    rpm/harbour-vodcounter.yaml \
    translations/*.ts \
    harbour-vodcounter.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-vodcounter-de.ts

DISTFILES += \
    qml/model/Context.qml \
    qml/pages/login/LoginPage.qml \
    qml/pages/login/ConnectionPage.qml \
    qml/js/vod/VodEP.js \
    qml/model/VodAPI.qml \
    qml/pages/main/OverviewPage.qml \
    qml/pages/main/ProfilePage.qml \
    qml/model/user/UserProfile.qml \
    qml/item/overview/BalanceOverview.qml \
    qml/components/VodLabel.qml \
    qml/item/overview/CountersOverview.qml \
    qml/js/LocalStorage.js \
    qml/js/vod/VodERR.js \
    qml/js/vod/VodHelper.js \
    qml/item/counter/CounterItem.qml \
    qml/item/counter/CounterCoverItem.qml \
    qml/components/counter/CounterCover.qml \
    qml/components/counter/VodCounter.qml \
    qml/pages/about/AboutPage.qml \
    qml/pages/about/DevelopersPage.qml \
    qml/components/CollaboratorsLabel.qml \
    qml/components/ProfileLabel.qml

HEADERS += \
    src/apirequest.h \
    src/machineid.h \
    src/localstoragefile.h \
    src/cryptography/aes256.h

RESOURCES += \
    resources.qrc

