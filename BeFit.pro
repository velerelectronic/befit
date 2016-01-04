TEMPLATE = app

QT += qml \
    quick \
    xml xmlpatterns svg \
    sql

SOURCES += main.cpp \
    databasebackup.cpp \
    SqlTableModel/sqltablemodel.cpp

RESOURCES += qml.qrc \
    common.qrc \
    icons.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    databasebackup.h \
    SqlTableModel/sqltablemodel.h

DISTFILES += \
    android/AndroidManifest.xml

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

