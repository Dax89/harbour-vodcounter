import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../components/counter"

Item
{
    property alias value: vodcounter.value
    property alias maxValue: vodcounter.maximumValue
    property string unit
    property string iconType

    height: lblcounter.contentHeight

    VodCounter
    {
        id: vodcounter
        anchors.fill: parent
    }

    Label
    {
        id: lblcounter
        anchors { left: parent.left; top: parent.top; bottom: parent.bottom; right: imgicon.left; rightMargin: Theme.paddingSmall }
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        truncationMode: TruncationMode.Fade
        text: value + " " + unit
    }

    Image
    {
        id: imgicon
        anchors { right: parent.right; top: parent.top; bottom: parent.bottom }
        fillMode: Image.PreserveAspectFit

        source: {
            if(iconType === "sms")
                return "image://theme/icon-m-message";

            if(iconType === "internet")
                return "image://theme/icon-m-transfer";

            if(iconType === "call_in")
                return "image://theme/icon-m-device-download";

            if((iconType === "call_out") || (iconType === "chiamate")) //NOTE: Italian id?!?
                return "image://theme/icon-m-device-upload";

            return "image://theme/icon-m-other";
        }
    }
}

