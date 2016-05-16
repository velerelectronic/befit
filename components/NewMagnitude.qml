import QtQuick 2.5
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import 'qrc:///common' as Common
import 'qrc:///models' as Models

Item {

    signal closeCurrentPage()

    Common.UseUnits {
        id: units
    }

    Models.MagnitudesModel {
        id: magnitudesModel
    }

    ColumnLayout {
        anchors.fill: parent
        TextField {
            id: titleField
            Layout.preferredHeight: units.fingerUnit
            Layout.fillWidth: true
        }
        TextArea {
            id: descField
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        Item {
            Layout.preferredHeight: units.fingerUnit * 2
            Layout.fillWidth: true
            RowLayout {
                anchors.fill: parent
                Button {
                    text: qsTr('Crea')
                    onClicked: {
                        if (saveNewMagnitude())
                            closeCurrentPage();
                    }
                }
                Button {
                    text: qsTr('Cancela')
                    onClicked: closeCurrentPage()
                }
            }
        }
    }

    function saveNewMagnitude() {
        var title = titleField.text;
        if (title !== '') {
            magnitudesModel.insertObject({title: title, desc: descField.text});
            return true;
        } else
            return false;
    }
}
