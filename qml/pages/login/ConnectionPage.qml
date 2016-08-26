import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../model"

Page
{
    property Context context

    id: connectionpage

    SilicaFlickable
    {
        anchors.fill: parent

        Label
        {
            anchors { bottom: indicator.top; bottomMargin: Theme.paddingMedium }
            width: parent.width
            font.pixelSize: Theme.fontSizeExtraLarge
            horizontalAlignment: Text.AlignHCenter
            color: Theme.secondaryHighlightColor
            text: qsTr("Connecting")
        }

        BusyIndicator
        {
            id: indicator
            anchors.centerIn: parent
            size: BusyIndicatorSize.Large
            running: true
        }
    }
}

