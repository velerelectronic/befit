import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.1
import 'qrc:///common' as Common

Rectangle {
    id: magnitudeViewer

    property string title
    property int key

    states: [
        State {
            name: 'erase'
        },
        State {
            name: 'title'
        }
    ]

    state: 'title'
    Common.UseUnits {
        id: units
    }

    border.color: 'black'

    height: units.fingerUnit * 2

    RowLayout {
        anchors.fill: parent
        anchors.margins: units.nailUnit
        Text {
            id: magnitudeTitle
            Layout.fillWidth: true
            Layout.fillHeight: true
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: units.readUnit
            text: title
            MouseArea {
                anchors.fill: parent
                onPressAndHold: magnitudeViewer.state = 'erase'
            }
        }
        Button {
            id: eraseButton
            text: qsTr('Elimina')
            visible: magnitudeViewer.state == 'erase'
            onClicked: {
                magnitudes.removeObjectWithKeyValue(key);
                magnitudes.select();
            }
        }
        Button {
            id: cancelEraseButton
            text: qsTr('Cancela')
            visible: magnitudeViewer.state == 'erase'
            onClicked: magnitudeViewer.state = 'title'
        }
    }


}
