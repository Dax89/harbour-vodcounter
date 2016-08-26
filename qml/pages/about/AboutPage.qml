import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../model"

Page
{
    property Context context

    id: aboutpage

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: content.height

        PullDownMenu
        {
            MenuItem
            {
                text: qsTr("GitHub Repository")
                onClicked: Qt.openUrlExternally("https://github.com/Dax89/harbour-vodcounter")
            }

            MenuItem
            {
                text: qsTr("Report an Issue")
                onClicked: Qt.openUrlExternally("https://github.com/Dax89/harbour-vodcounter/issues")
            }
        }

        Column
        {
            id: content
            width: parent.width
            spacing: Theme.paddingLarge

            PageHeader
            {
                id: pageheader
                title: qsTr("About VodCounter")
            }

            Image
            {
                id: vclogo
                anchors.horizontalCenter: parent.horizontalCenter
                fillMode: Image.PreserveAspectFit
                width: Theme.iconSizeLarge
                height: Theme.iconSizeLarge
                source: "qrc:///res/app.png"
            }

            Column
            {
                anchors { left: parent.left; right: parent.right }

                Label
                {
                    id: vcswname
                   anchors { left: parent.left; right: parent.right }
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                    font.pixelSize: Theme.fontSizeLarge
                    text: "VodCounter"
                }

                Label
                {
                    id: vcinfo
                    anchors { left: parent.left; right: parent.right }
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.WordWrap
                    text: qsTr("An unofficial Vodafone™ Italy app for SailfishOS")
                }

                Label
                {
                    id: vcversion
                    anchors { left: parent.left; right: parent.right }
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: Theme.secondaryColor
                    text: qsTr("Version") + " " + context.version
                }

                Label
                {
                    id: vccopyright
                    anchors { left: parent.left; right: parent.right }
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: Theme.fontSizeExtraSmall
                    wrapMode: Text.WordWrap
                    color: Theme.secondaryColor
                    text: qsTr("VodCounter is distributed under the GPLv3 license")
                }
            }

            Column
            {
                anchors { left: parent.left; right: parent.right; topMargin: Theme.paddingExtraLarge }
                spacing: Theme.paddingSmall

                Button
                {
                    id: licensebutton
                    text: qsTr("License")
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: Qt.openUrlExternally("https://raw.githubusercontent.com/Dax89/harbour-vodcounter/master/LICENSE")
                }

                Button
                {
                    id: developersbutton
                    text: qsTr("Developers")
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: pageStack.push(Qt.resolvedUrl("DevelopersPage.qml"))
                }

                /*
                Button
                {
                    id: translationsbutton
                    text: qsTr("Translations")
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: pageStack.push(Qt.resolvedUrl("TranslationsPage.qml"), { "context": aboutpage.context })
                }
                */
            }
        }
    }
}
