import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../item/counter"
import "../../model"
import "../../js/LocalStorage.js" as LocalStorage

Item
{
    readonly property bool favorite: (btnfavorites.icon.source.toString() === "image://theme/icon-m-favorite-selected")
    property Context context
    property var currentProfile
    property int counterIdx
    property string counterId
    property string title

    function update() {
        if(!currentProfile.counter_details || !currentProfile.counter_details[counterId])
            return;

        repeater.model = currentProfile.counter_details[counterId].threshold.size;

        if((currentProfile.counter_favorite === undefined) || (currentProfile.counter_favorite !== counterIdx)) {
            btnfavorites.icon.source = "image://theme/icon-m-favorite";
            return;
        }

        btnfavorites.icon.source = "image://theme/icon-m-favorite-selected";
    }

    Connections
    {
        target: context.vodapi

        onSimCountersReceived: {
            context.vodapi.sim_counter_details(currentProfile.msidsn, counterId);
        }

        onSimCounterDetailsReceived: {
            var counter = result.counters[0];

            if(counter.id !== counterId)
                return;

            if(!currentProfile.counter_details)
                currentProfile.counter_details = { };

            currentProfile.counter_details[counterId] = counter;
            repeater.model = 0;
            context.commit();
        }
    }

    Connections
    {
        target: context
        onCommited: update()
    }

    id: countersgrid
    height: header.height + flickable.calculatedHeight
    onCounterIdChanged: context.vodapi.sim_counter_details(currentProfile.msidsn, counterId);

    Item
    {
        id: header
        x: Theme.horizontalPageMargin
        width: parent.width - (x * 2)
        height: Theme.iconSizeSmall

        Label
        {
            id: lbltitle
            anchors { right: btnfavorites.left; top: parent.top; bottom: parent.bottom; rightMargin: Theme.paddingLarge }
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            font.pixelSize: Theme.fontSizeSmall
            truncationMode: TruncationMode.Fade
            color: Theme.highlightColor
            text: countersgrid.title
        }

        IconButton
        {
            id: btnfavorites
            anchors { right: parent.right; top: parent.top; bottom: parent.bottom }
            width: parent.height

            icon {
                source: "image://theme/icon-m-favorite"
                fillMode: Image.PreserveAspectFit
            }

            onClicked: {
                currentProfile.counter_favorite = favorite ? -1 : counterIdx;
                context.commit();
            }
        }

    }

    Item
    {
        readonly property int visibleItems: 4
        readonly property real cellSize: (parent.width / visibleItems) - (row.spacing * (visibleItems - 1))
        readonly property real calculatedHeight: cellSize + (Theme.fontSizeExtraSmall * 4)

        id: flickable
        anchors { top: header.bottom; topMargin: Theme.paddingMedium }
        x: Theme.paddingSmall
        width: parent.width - (x * 2)
        height: parent.height

        Row
        {
            id: row
            spacing: Theme.paddingSmall
            anchors.horizontalCenter: parent.horizontalCenter

            Repeater
            {
                id: repeater

                delegate: CounterItem {
                    readonly property var thresholdValue: currentProfile.counter_details[counterId].threshold.values[model.index]

                    width: flickable.cellSize
                    counterValue: thresholdValue.value
                    maxCounterValue: thresholdValue.threshold
                    title: thresholdValue.label
                    unit: thresholdValue.unit
                }
            }
        }
    }
}
