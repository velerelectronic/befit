TEMPLATE = app

QT += qml quick sql

SOURCES += main.cpp \
    databasebackup.cpp \
    sqltablemodel.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    databasebackup.h \
    sqltablemodel.h
