import QtQuick 2.0
import Sailfish.Silica 1.0
import "../../model"

Dialog
{
    property alias username: tfusername.text
    property alias password: tfpassword.text

    property Context context
    property string errorMessage

    id: logindialog
    acceptDestinationAction: PageStackAction.Replace
    acceptDestination: Component { ConnectionPage { context: logindialog.context } }
    canAccept: (tfusername.text.length > 0) && (tfpassword.text.length > 0)
    onAccepted: context.vodapi.login(tfusername.text, tfpassword.text)

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: content.height

        Column
        {
            id: content
            width: logindialog.width
            spacing: Theme.paddingLarge

            DialogHeader { acceptText: qsTr("Login") }

            Image
            {
                anchors.horizontalCenter: parent.horizontalCenter
                width: Theme.iconSizeLarge
                height: Theme.iconSizeLarge
                source: "qrc:///res/app.png"
            }

            Label
            {
                width: parent.width
                text: qsTr("VodCounter")
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                color: Theme.secondaryColor
                font { family: Theme.fontFamilyHeading; pixelSize: Theme.fontSizeExtraLarge; bold: true }

            }

            Label
            {
                x: Theme.paddingSmall
                width: parent.width - (x * 2)
                text: qsTr("ERROR:") + " " + errorMessage
                visible: errorMessage.length > 0
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeExtraSmall
                wrapMode: Text.WordWrap
            }

            TextField
            {
                id: tfusername
                x: Theme.paddingSmall
                width: parent.width - (x * 2)
                placeholderText: qsTr("Username")
                inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
            }

            TextField
            {
                id: tfpassword
                x: Theme.paddingSmall
                width: parent.width - (x * 2)
                placeholderText: qsTr("Password")
                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhHiddenText
            }
        }
    }
}


