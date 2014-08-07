import QtQuick 2.2
import QtQuick.Window 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.1
import 'qrc:///common' as Common
import PersonalTypes 1.0

Window {
    visible: true
    width: 360
    height: 360

    Common.UseUnits {
        id: units
    }

    DatabaseBackup {
        id: dbBk
    }

    SqlTableModel {
        id: magnitudes
        tableName: 'magnitudes'
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: units.nailUnit

        Text {
            text: 'BeFit'
            font.pixelSize: units.readUnit
            font.bold: true
        }

        ListView {
            id: magnitudesList
            Layout.fillHeight: true
            Layout.fillWidth: true
            clip: true

            model: magnitudes
            delegate: MagnitudeViewer {
                width: magnitudesList.width
                key: id
                title: model.title
            }
        }
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: units.fingerUnit * 1.5
            RowLayout {
                anchors.fill: parent
                TextField {
                    id: title
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    onEditingFinished: if (text != "") insertMagnitude()
                }
                Button {
                    Layout.fillHeight: true
                    text: qsTr('Crea')
                    onClicked: insertMagnitude()
                }
            }
        }

    }

    function insertMagnitude() {
        if (magnitudes.insertObject({title: title.text})) {
            title.text = "";
            title.focus = false;
        }
    }

    Component.onCompleted: {
        dbBk.createTable('magnitudes','id INTEGER PRIMARY KEY,title TEXT, desc TEXT');
        dbBk.createTable('measures','id INTEGER PRIMARY KEY,magnitude INTEGER NOT NULL,value TEXT,dateTime TEXT');
        magnitudes.select();
    }
}
