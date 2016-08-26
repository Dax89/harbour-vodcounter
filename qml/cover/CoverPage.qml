import QtQuick 2.1
import Sailfish.Silica 1.0
import "../model"
import "../components/counter"
import "../js/LocalStorage.js" as LocalStorage

CoverBackground
{
    property Context context
    readonly property var currentProfile: context.profile.currentItem
    property int pageNumber: checkFavoritePage()
    property int maxPages: 0

    function checkFavoritePage() {
        if(!currentProfile || !currentProfile.counter_favorite || currentProfile.counter_favorite < 0)
            return 0;

        return currentProfile.counter_favorite;
    }

    function update() {
        if(!currentProfile)
            return;

        if(currentProfile.counters)
            maxPages = currentProfile.counters.length;

        lbltitle.text = qsTr("Current\nbalance")
        lblvalue.text = currentProfile ? (currentProfile.data.balance + currentProfile.data.currency) : "N/A";

        if(currentProfile.counters && currentProfile.counter_details) {
            var counterid = currentProfile.counters[coverpage.pageNumber].id;
            countercover.title = currentProfile.counters[coverpage.pageNumber].name;
            countercover.counterDetails = currentProfile.counter_details[counterid];
        }
    }

    id: coverpage
    onPageNumberChanged: update()

    Connections
    {
        target: context
        onCommited: update()
    }

    Column
    {
        id: colstatus
        anchors { top: parent.top; left: parent.left; right: parent.right; topMargin: Theme.paddingMedium; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingMedium }
        spacing: Theme.paddingSmall

        Item
        {
            width: parent.width
            height: Math.max(lblvalue.contentHeight, lbltitle.contentHeight)

            Label
            {
                id: lblvalue
                anchors { left: parent.left; right: lbltitle.left; rightMargin: Theme.paddingSmall }
                font.pixelSize: Theme.fontSizeExtraLarge
                font.family: Theme.fontFamilyHeading
                text: qsTr("N/A")
            }

            Label
            {
                id: lbltitle
                anchors { right: parent.right; verticalCenter: lblvalue.verticalCenter }
                color: Theme.highlightColor
                font { pixelSize: Theme.fontSizeExtraSmall; family: Theme.fontFamilyHeading; weight: Font.Light }
                lineHeight: 0.8
                truncationMode: TruncationMode.Fade
                text: qsTr("No\ndata")
            }
        }

        CounterCover
        {
            id: countercover
            width: parent.width
        }
    }

    CoverActionList {
        id: coveraction

        CoverAction {
            iconSource: "image://theme/icon-cover-refresh"
            onTriggered: context.load()
        }

        CoverAction {
            iconSource: "cover_next.png"

            onTriggered: {
                pageNumber = (pageNumber + 1) % maxPages;
            }
        }
    }
}


