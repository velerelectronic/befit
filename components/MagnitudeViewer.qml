import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.1
import QtQml.Models 2.2
import PersonalTypes 1.0
import 'qrc:///common' as Common
import 'qrc:///models' as Models
import 'qrc:///components' as Components

Item {
    id: magnitudeViewer

    property string title
    property int magnitude: -1

    property string magnitudeTitle: ''
    property string magnitudeDescription: ''
    property bool isCurrentMagnitude: false

    signal closeCurrentPage()
    signal magnitudeTitleSelected(string title)
    signal magnitudeDescriptionSelected(string description)
    signal magnitudeSelected()
    signal magnitudesListSelected()
    signal measureSelected()

    property int measuresCount: 0

    Common.UseUnits {
        id: units
    }


    Models.MagnitudesModel {
        id: magnitudesModel
    }

    ColumnLayout {
        anchors.fill: parent

        Common.HorizontalStaticMenu {
            Layout.preferredHeight: units.fingerUnit * 2
            Layout.fillWidth: true
            underlineColor: 'orange'
            underlineWidth: units.nailUnit

            connectedList: sectionsList

            sectionsModel: pageSectionsModel
        }

        ListView {
            id: sectionsList

            Layout.fillHeight: true
            Layout.fillWidth: true
            clip: true

            spacing: units.fingerUnit
            model: pageSectionsModel

        }

        ObjectModel {
            id: pageSectionsModel

            Common.BasicSection {
                width: sectionsList.width
                padding: units.fingerUnit
                caption: qsTr('Magnitud')

                Rectangle {
                    height: units.fingerUnit * 5
                    width: parent.width
                    GridLayout {
                        anchors.fill: parent

                        rows: 3
                        columns: 2
                        Text {
                            text: qsTr('Títol')
                        }
                        Text {
                            text: magnitudeTitle
                        }
                        Text {
                            text: qsTr('Descripció')
                        }
                        Text {
                            text: magnitudeDescription
                        }
                        Item {
                            Layout.columnSpan: 2
                            Layout.fillWidth: true
                            height: units.fingerUnit * 2

                            Text {
                                anchors.fill: parent
                                color: 'grey'
                                visible: magnitudeViewer.measuresCount > 0
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                text: qsTr('La magnitud no es pot esborrar perquè té mesures.')
                            }
                            Button {
                                anchors.fill: parent
                                visible: magnitudeViewer.measuresCount == 0
                                text: qsTr('Esborra')
                                onClicked: {
                                    deleteMagnitude();
                                    closeCurrentPage();
                                }
                            }
                        }

                        Button {
                            Layout.columnSpan: 2
                            text: qsTr('Llista de magnituds')
                            onClicked: magnitudeViewer.magnitudesListSelected()
                        }
                    }
                }
            }

            Common.BasicSection {
                width: sectionsList.width
                padding: units.fingerUnit
                caption: qsTr('Mesures')

                Components.MeasuresList {
                    id: measures
                    width: parent.width
                    height: measures.requiredHeight
                    magnitude: magnitudeViewer.magnitude
                    onMeasuresCountChanged: magnitudeViewer.measuresCount = measures.measuresCount
                }
            }
        }
    }

    Component.onCompleted: getMagnitudeDetails()

    function getMagnitudeDetails() {
        var obj = magnitudesModel.getObject(magnitude);
        magnitudeTitle = obj['title'];
        magnitudeDescription = obj['desc'];
    }

    function deleteMagnitude() {
        magnitudesModel.removeObject(magnitude);
    }
}
