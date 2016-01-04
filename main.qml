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
        primaryKey: 'id'
        fieldNames: ['id','title','desc']
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: units.nailUnit

        Text {
            color: 'orange'
            text: 'BeFit'
            font.pixelSize: units.readUnit
            font.bold: true
        }

        ListView {
            id: magnitudesList
            Layout.fillHeight: true
            Layout.fillWidth: true
            clip: true

            property int optionsRowHeight: units.fingerUnit * 2 + addMagnitudeButton.margins * 2

            bottomMargin: optionsRowHeight

            model: magnitudes
            delegate: MagnitudeViewer {
                width: magnitudesList.width
                key: id
                title: model.title
                isCurrentMagnitude: ListView.isCurrentItem

                magnitudesModel: magnitudes

                onMagnitudeSelected: {
                    magnitudesList.currentIndex = model.index;
                    for (var i=0; i<magnitudesList.contentItem.children.length; i++) {
                        if (i != model.index)
                            magnitudesList.contentItem.children[i].state = 'title';
                    }
                    magnitudesList.currentItem.state = 'measures';
                    magnitudesList.positionViewAtIndex(model.index,ListView.Beginning);
                }

                onChangeMagnitudeTitle: {
                    magnitudes.updateObject({id: key, title:title});
                }
            }
            Common.SuperposedButton {
                id: addMagnitudeButton

                visible: enabled
                enabled: !createItem.enabled
                anchors {
                    right: parent.right
                    bottom: parent.bottom
                }
                margins: units.nailUnit

                backgroundColor: 'orange'
                imageSource: 'add-159647'
                size: magnitudesList.optionsRowHeight
                onClicked: createItem.enabled = true
            }
        }
    }

    Rectangle {
        id: createItem

        visible: createItem.enabled
        enabled: false

        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        height: magnitudesList.optionsRowHeight

        RowLayout {
            anchors.fill: parent
            anchors.margins: units.nailUnit
            TextField {
                id: title
                Layout.fillHeight: true
                Layout.fillWidth: true
                onEditingFinished: insertMagnitude()
            }
            Button {
                Layout.fillHeight: true
                text: qsTr('Crea')
                onClicked: insertMagnitude()
            }
            Button {
                Layout.fillHeight: true
                text: qsTr('Cancela')
                onClicked: createItem.enabled = false
            }
        }
    }

    function insertMagnitude() {
        if (title.text !== '') {
            if (magnitudes.insertObject({title: title.text})) {
                createItem.enabled = false;
                title.text = "";
                Qt.inputMethod.hide();
                magnitudes.select();
            }
        }
    }

    Component.onCompleted: {
        dbBk.createTable('magnitudes','id INTEGER PRIMARY KEY,title TEXT, desc TEXT');
        dbBk.createTable('measures','id INTEGER PRIMARY KEY,magnitude INTEGER NOT NULL,value TEXT,dateTime TEXT');
        magnitudes.select();
    }
}
