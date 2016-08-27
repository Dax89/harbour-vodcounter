import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../model"

Item
{
    property Context context
    property int counterValue
    property int maxCounterValue
    property string title
    property string unit

    id: counteritem
    height: lbltitle.paintedHeight + progresscircle.width + lblunit.paintedHeight

    Label
    {
        id: lbltitle
        anchors { left: parent.left; top: parent.top; right: parent.right }
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: Theme.fontSizeExtraSmall
        text: counteritem.title
    }

    ProgressCircle
    {
        id: progresscircle
        anchors { top: lbltitle.bottom; bottom: lblunit.top }
        width: parent.width
        height: parent.width
        borderWidth: Theme.paddingSmall
        value: counterValue / maxCounterValue
        inAlternateCycle: true

        Column
        {
            anchors { fill: parent; margins: progresscircle.borderWidth * 2 }

            Label
            {
                width: parent.width
                font { pixelSize: Theme.fontSizeLarge; bold: true }
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                color: Theme.highlightColor
                text: counterValue
            }

            Rectangle
            {
                height: 1
                x: Theme.paddingMedium
                width: parent.width - (x * 2)
                color: Theme.secondaryHighlightColor
            }

            Label
            {
                width: parent.width
                font.pixelSize: Theme.fontSizeExtraSmall
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("of %1").arg(maxCounterValue)
                elide: Text.ElideRight
            }
        }
    }

    Label
    {
        id: lblunit
        anchors { left: parent.left; bottom: parent.bottom; right: parent.right }
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: Theme.fontSizeExtraSmall
        text: counteritem.unit
    }
}
