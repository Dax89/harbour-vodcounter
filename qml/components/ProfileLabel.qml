import QtQuick 2.1
import Sailfish.Silica 1.0
import "../js/vod/VodHelper.js" as VodHelper

BackgroundItem
{
    property alias value: lblvalue.text
    property string type
    property string payment

    id: profilelabel

    Label
    {
        id: lbltype
        font.pixelSize: Theme.fontSizeExtraSmall
        color: Theme.highlightColor

        text: {
            if(profilelabel.payment.length <= 0)
                return VodHelper.fixCase(profilelabel.type);

            return VodHelper.fixCase(profilelabel.type) + " (" + VodHelper.fixCase(profilelabel.payment) + ")";
        }

        anchors {
            left: parent.left
            top: parent.top
            right: parent.right
            leftMargin: Theme.paddingSmall
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

