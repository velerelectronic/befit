import QtQuick 2.5
import QtQuick.Layouts 1.1
import PersonalTypes 1.0
import 'qrc:///common' as Common
import 'qrc:///models' as Models


ListView {
    id: magnitudesList
    clip: true

    property int optionsRowHeight: units.fingerUnit * 2 + addMagnitudeButton.margins * 2

    signal magnitudeSelected(int magnitude)
    signal newMagnitudeSelected()

    property int lastMagnitude: -1

    bottomMargin: optionsRowHeight

    Common.UseUnits {
        id: units
    }

    Models.MagnitudesModel {
        id: magnitudes

        sort: 'id DESC'
        Component.onCompleted: select()
    }

    model: magnitudes

    spacing: units.nailUnit

    delegate: Rectangle {
        id: magnitudeRect
        width: magnitudesList.width
        height: units.fingerUnit * 2
        color: (lastMagnitude == model.id)?'yellow':'white'

        RowLayout {
            anchors.fill: parent
            anchors.margins: units.nailUnit
            spacing: units.nailUnit
            Text {
                Layout.preferredWidth: magnitudeRect.width / 2
                Layout.fillHeight: true
                font.pixelSize: units.readUnit
                font.bold: true
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: model.title
            }
            Text {
                Layout.fillWidth: true
                Layout.fillHeight: true
                font.pixelSize: units.readUnit
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: model.desc
            }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: magnitudeSelected(model.id)
        }
    }

    /*
    MagnitudeViewer {
        onChangeMagnitudeTitle: {
            magnitudes.updateObject({id: key, title:title});
        }
    }
    */

    Common.SuperposedButton {
        id: addMagnitudeButton

        anchors {
            right: parent.right
            bottom: parent.bottom
        }
        margins: units.nailUnit

        backgroundColor: 'orange'
        imageSource: 'add-159647'
        size: magnitudesList.optionsRowHeight
        onClicked: newMagnitudeSelected()
    }
}
