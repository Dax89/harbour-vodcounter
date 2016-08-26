import QtQuick 2.1
import Sailfish.Silica 1.0

Label
{
    property string receivedText

    id: vodlabel
    text: receivedText.length > 0 ? receivedText : qsTr("Loading...")
}

