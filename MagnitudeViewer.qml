import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.1
import 'qrc:///common' as Common

Rectangle {
    id: magnitudeViewer

    property string title
    property int key
    property bool isCurrentMagnitude: false

    signal changeMagnitudeTitle(string title)
    signal magnitudeSelected()

    states: [
        State {
            name: 'title'
        },
        State {
            name: 'measures'
        },
        State {
            name: 'edit'
        },
        State {
            name: 'erase'
        }
    ]

    state: 'title'
    Common.UseUnits {
        id: units
    }

    border.color: 'black'
    color: (magnitudeViewer.state == 'measures')?'yellow':'white'

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
            color: (magnitudeViewer.state == 'erase')?'blue':'black'
            text: title

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (isCurrentMagnitude) {
                        var nextState = 'title';
                        switch(magnitudeViewer.state) {
                        case 'title':
                            nextState = 'measures';
                            break;
                        case 'measures':
                            nextState = 'title';
                            break;
                        case 'edit':
                            break;
                        case 'erase':
                            nextState = 'edit';
                            break;
                        }
                        magnitudeViewer.state = nextState;
                    } else {
                        magnitudeSelected();
                    }

                }
                onPressAndHold: {
                    if (isCurrentMagnitude)
                        magnitudeViewer.state = 'erase';
                    else
                        magnitudeSelected();
                }
            }
            Item {
                anchors.fill: parent
                visible: magnitudeViewer.state == 'edit'
                RowLayout {
                    anchors.fill: parent
                    spacing: units.nailUnit
                    TextField {
                        id: newTitle
                        Layout.fillWidth: true
                        text: model.title
                        onAccepted: changeMagnitudeTitle(newTitle.text)
                    }
                    Button {
                        id: changeButton
                        enabled: (newTitle.text != model.title) && (newTitle.text != "")
                        text: qsTr('Canvia')
                        onClicked: changeMagnitudeTitle(newTitle.text)
                    }
                    Button {
                        id: cancelButton
                        text: qsTr('Cancela')
                        onClicked: magnitudeViewer.state = 'title'
                    }
                }
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
