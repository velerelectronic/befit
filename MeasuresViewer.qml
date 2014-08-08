import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.1
import PersonalTypes 1.0

Rectangle {
    id: measuresViewer
    width: 100
    property int requiredHeight: insertButtons.height + measuresList.height + units.nailUnit
    property int magnitudeKey

    color: 'transparent'

    SqlTableModel {
        id: measuresModel
        tableName: 'measures'
        filters: [ "magnitude = '" +magnitudeKey+ "'" ]
    }

    RowLayout {
        id: insertButtons
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: units.fingerUnit

        TextField {
            id: newValue
            Layout.fillHeight: true
            Layout.fillWidth: true
            onFocusChanged: if (focus) measuresViewer.state = 'measure'
            onEditingFinished: if (text != '') insertMeasure()
        }
        Button {
            Layout.fillHeight: true
            enabled: newValue.text != ""
            text: qsTr('Mesura')
            onClicked: insertMeasure()
        }
    }

    ListView {
        id: measuresList
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: insertButtons.bottom
        anchors.topMargin: units.nailUnit
        height: contentItem.height
        interactive: false
        model: measuresModel

        delegate: Rectangle {
            id: singleMeasure
            states: [
                State {
                    name: 'measure'
                },
                State {
                    name: 'erase'
                }
            ]

            state: 'measure'
            width: measuresList.width
            height: units.fingerUnit * 1.5
            border.color: 'black'
            color: '#BEF781'
            RowLayout {
                anchors.fill: parent
                anchors.margins: units.nailUnit
                spacing: units.nailUnit

                Text {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    verticalAlignment: Text.AlignVCenter
                    text: model.value
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                }
                Text {
                    Layout.fillHeight: true
                    Layout.maximumWidth: contentWidth
                    visible: singleMeasure.state != 'erase'
                    verticalAlignment: Text.AlignVCenter
                    text: model.dateTime
                    color: '#848484'
                }
                Button {
                    visible: singleMeasure.state == 'erase'
                    text: qsTr('Elimina')
                    onClicked: {
                        if (measuresModel.removeObjectWithKeyValue(model.id)) {
                            singleMeasure.state = 'measure';
                            measuresModel.select();
                        }
                    }
                }
                Button {
                    visible: singleMeasure.state == 'erase'
                    text: qsTr('Cancela')
                    onClicked: singleMeasure.state = 'measure'
                }
            }
            MouseArea {
                anchors.fill: parent
                enabled: singleMeasure.state != 'erase'
                onPressAndHold: singleMeasure.state = 'erase'
            }
        }
        Component.onCompleted: measuresModel.select()
    }

    function insertMeasure() {
        var dt = new Date();
        if (measuresModel.insertObject({value: newValue.text, magnitude: magnitudeKey, dateTime: dt.toISOString()})) {
            newValue.text = "";
            newValue.focus = false;
        }
    }
}
