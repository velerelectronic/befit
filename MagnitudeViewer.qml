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
        },
        State {
            name: 'measures'
        }

    ]

    state: 'title'
    Common.UseUnits {
        id: units
    }

    border.color: 'black'

    height: rowTitle.height + units.nailUnit * 3 + measures.height

    Behavior on height {
        PropertyAnimation {
            duration: 100
        }
    }

    RowLayout {
        id: rowTitle
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: units.nailUnit
        height: units.fingerUnit * 1.5
        Text {
            id: magnitudeTitle
            Layout.fillWidth: true
            Layout.fillHeight: true
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: units.readUnit
            text: title
            MouseArea {
                anchors.fill: parent
                onClicked: magnitudeViewer.state = (magnitudeViewer.state == 'title')?'measures':'title'
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

    MeasuresViewer {
        id: measures
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: rowTitle.bottom
        anchors.margins: units.nailUnit
        height: (magnitudeViewer.state == 'measures')?requiredHeight:0
        visible: magnitudeViewer.state == 'measures'
        magnitudeKey: key
    }

}
