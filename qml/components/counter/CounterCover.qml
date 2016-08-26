import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../item/counter"
import "../../js/LocalStorage.js" as LocalStorage

Column
{
    property alias title: lbltitle.text
    property var counterDetails

    id: countercover
    spacing: Theme.paddingSmall

    Label
    {
        id: lbltitle
        anchors.right: parent.right
        width: parent.width - Theme.paddingSmall
        horizontalAlignment: Text.AlignRight
        color: Theme.highlightColor
        font { family: Theme.fontFamilyHeading; pixelSize: Theme.fontSizeExtraSmall }
    }

    Repeater
    {
        model: counterDetails ? counterDetails.threshold.size : 0

        delegate: CounterCoverItem {
            property var counterValue: counterDetails.threshold.values[model.index]

            width: countercover.width
            value: counterValue.value
            maxValue: counterValue.threshold
            unit: counterValue.unit
            iconType: counterValue.icon
        }
    }
}
