import QtQuick 2.5
import QtQuick.Window 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.1
import PersonalTypes 1.0
import QtQml.StateMachine 1.0 as DSM
import 'qrc:///common' as Common

Window {
    id: mainWindow
    visible: true
    width: 360
    height: 360

    signal closeCurrentPage()
    signal magnitudeSelected()
    signal newMagnitudeSelected()
    signal showMagnitudesList()

    Common.UseUnits {
        id: units
    }

    DatabaseBackup {
        id: dbBk
    }

    Rectangle {
        id: mainWindowRect
        anchors.fill: parent

        property int magnitude: -1

        color: '#DDDDDD'
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: units.nailUnit

            Text {
                color: 'orange'
                text: 'BeFit'
                font.pixelSize: units.readUnit
                font.bold: true
            }

            Loader {
                id: pageLoader

                Layout.fillHeight: true
                Layout.fillWidth: true

                function loadPage(page, params) {
                    setSource('qrc:///components/' + page + '.qml', params);
                }

                Connections {
                    target: pageLoader.item
                    ignoreUnknownSignals: true

                    onCloseCurrentPage: {
                        closeCurrentPage();
                    }

                    onMagnitudeSelected: {
                        mainWindowRect.magnitude = magnitude;
                        magnitudeSelected();
                    }

                    onMagnitudesListSelected: {
                        showMagnitudesList();
                    }

                    onNewMagnitudeSelected: {
                        newMagnitudeSelected();
                    }
                }
            }
        }
    }

    DSM.StateMachine {
        id: befitStateMachine

        initialState: magnitudesListState

        DSM.State {
            id: magnitudesListState

            onEntered: {
                pageLoader.loadPage('magnitudeslist', {lastMagnitude: mainWindowRect.magnitude});
            }

            onExited: {

            }

            DSM.SignalTransition {
                signal: magnitudeSelected
                targetState: magnitudeViewerState
            }

            DSM.SignalTransition {
                signal: newMagnitudeSelected
                targetState: newMagnitudeState
            }
        }

        DSM.State {
            id: magnitudeViewerState

            onEntered: {
                pageLoader.loadPage('MagnitudeViewer', {magnitude: mainWindowRect.magnitude});
            }

            DSM.SignalTransition {
                signal: showMagnitudesList
                targetState: magnitudesListState
            }

            DSM.SignalTransition {
                signal: closeCurrentPage
                targetState: magnitudesListState
            }
        }

        DSM.State {
            id: newMagnitudeState

            onEntered: {
                pageLoader.loadPage('NewMagnitude', {});
            }

            DSM.SignalTransition {
                signal: closeCurrentPage
                targetState: magnitudesListState
            }
        }
    }

    Component.onCompleted: {
        dbBk.createTable('magnitudes','id INTEGER PRIMARY KEY,title TEXT, desc TEXT');
        dbBk.createTable('measures','id INTEGER PRIMARY KEY,magnitude INTEGER NOT NULL,value TEXT,dateTime TEXT');

        befitStateMachine.start();
    }
}
