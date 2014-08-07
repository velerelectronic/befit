import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.1
import PersonalTypes 1.0

Rectangle {
    id: measuresViewer
    width: 100
    property int requiredHeight: insertButtons.height + measuresList.height
    property int magnitudeKey

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
        height: units.fingerUnit * 1.5

        TextField {
            id: newValue
            Layout.fillHeight: true
            Layout.fillWidth: true
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
        height: contentItem.height
        interactive: false
        model: measuresModel

        delegate: Rectangle {
            width: measuresList.width
            height: units.fingerUnit
            border.color: 'black'
            color: '#BCF5A9'
            RowLayout {
                anchors.fill: parent
                anchors.margins: units.nailUnit

                Text {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    verticalAlignment: Text.AlignVCenter
                    text: model.value
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                }
                Text {
                    Layout.fillHeight: true
                    Layout.preferredWidth: contentWidth
                    verticalAlignment: Text.AlignVCenter
                    text: model.dateTime
                }
            }
        }
        Component.onCompleted: measuresModel.select()
    }

    function insertMeasure() {
        var dt = new Date();
        if (measuresModel.insertObject({value: newValue.text, magnitude: magnitudeKey, dateTime: dt.toISOString()}))
            newValue.text = "";
    }
}
