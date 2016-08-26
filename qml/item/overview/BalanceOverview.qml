import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../components"

Item
{
    property string balance
    property string currency
    property string expirationDate
    property string actionUrl

    property alias actionText: btnaction.text

    id: balanceoverview
    height: Math.max(content.height, btnaction.height)

    Column
    {
        id: content
        x: Theme.paddingMedium
        anchors { top: parent.top }
        width: (parent.width - btnaction.width) - (x * 2)

        VodLabel
        {
            id: lblbalance
            font { pixelSize: Theme.fontSizeLarge; family: Theme.fontFamilyHeading; bold: true }
            receivedText: balance + currency
        }

        VodLabel
        {
            id: lblexpiration
            receivedText: qsTr("SIM Expiration: %1").arg(expirationDate)
            font.pixelSize: Theme.fontSizeExtraSmall
        }
    }

    Button
    {
        id: btnaction
        anchors { right: parent.right; rightMargin: Theme.paddingMedium; verticalCenter: parent.verticalCenter }
        visible: text.length > 0
        onClicked: Qt.resolvedUrl(actionUrl)
    }
}

