import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../components"
import "../../model"
import "../../js/vod/VodHelper.js" as VodHelper
import "../../js/LocalStorage.js" as LocalStorage

Page
{
    property Context context

    id: profilepage

    Connections
    {
        target: context

        onCommited: {
            profilesrepeater.model = LocalStorage.config.profile.items.length;
        }
    }

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: content.height

        PullDownMenu
        {
            MenuItem
            {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("../about/AboutPage.qml"), { "context": context });
            }
        }

        Column
        {
            id: content
            width: parent.width

            PageHeader {
                title: VodHelper.fixCase(context.profile.firstName)
            }

            SectionHeader { text: qsTr("Username") }

            Label
            {
                x: Theme.horizontalPageMargin
                width: parent.width - (x * 2)
                text: context.profile.userName
                font.pixelSize: Theme.fontSizeSmall
                elide: Text.ElideRight
            }

            SectionHeader { text: qsTr("Complete name") }

            Label
            {
                x: Theme.horizontalPageMargin
                width: parent.width - (x * 2)
                text: VodHelper.fixCase(context.profile.firstName + " " + context.profile.lastName)
                font.pixelSize: Theme.fontSizeSmall
                elide: Text.ElideRight
            }

            SectionHeader { text: qsTr("Mail") }

            Label
            {
                x: Theme.horizontalPageMargin
                width: parent.width - (x * 2)
                text: context.profile.email.toLowerCase()
                font.pixelSize: Theme.fontSizeSmall
                elide: Text.ElideRight
            }

            Rectangle { width: parent.width; height: Theme.paddingMedium; color: "transparent" }

            SectionHeader { text: qsTr("Profiles") }

            Repeater
            {
                id: profilesrepeater
                model: LocalStorage.config.profile.items.length

                delegate: ProfileLabel {
                    readonly property var item: LocalStorage.config.profile.items[model.index]

                    width: content.width
                    height: Theme.itemSizeSmall
                    highlighted: context.profile.currentIndex === model.index
                    value: item.msidsn
                    type: item.type
                    payment: item.data.payment || ""

                    onClicked: {
                        if(highlighted)
                            return;

                        context.profile.currentIndex = model.index;
                    }
                }
            }
        }
    }
}

