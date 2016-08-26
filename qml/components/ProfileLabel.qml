import QtQuick 2.1
import Sailfish.Silica 1.0

BackgroundItem
{
    property alias type: lbltype.text
    property alias value: lblvalue.text

    id: profilelabel

    Label
    {
        id: lbltype
        font.pixelSize: Theme.fontSizeExtraSmall
        color: Theme.highlightColor

        anchors {
            left: parent.left;
            top: parent.top;
            right: parent.right;
            leftMargin: Theme.paddingSmall;
            rightMargin: Theme.paddingSmall
        }
    }

    Label
    {
        id: lblvalue
        font.pixelSize: Theme.fontSizeExtraSmall
        elide: Text.ElideRight

        anchors {
            left: parent.left
            top: lbltype.bottom
            right: parent.right
            leftMargin: Theme.paddingSmall
            rightMargin: Theme.paddingSmall
        }
    }
}

