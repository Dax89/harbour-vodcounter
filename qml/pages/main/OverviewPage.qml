import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../model"
import "../../item/overview"
import "../../js/vod/VodHelper.js" as VodHelper

Page
{
    readonly property bool isOverviewPage: true
    property Context context
    property var currentProfile: context.profile.currentItem

    function update() {
        if(!currentProfile)
            return;

        header.title = qsTr("Hi %1").arg(VodHelper.fixCase(context.profile.firstName));
        balanceheader.text = qsTr("Balance in %1").arg(currentProfile.msidsn)

        if(currentProfile.expiration_date)
            balanceoverview.expirationDate = currentProfile.expiration_date;

        if(currentProfile.data) {
            balanceoverview.balance = currentProfile.data.balance;
            balanceoverview.currency = currentProfile.data.currency;
        }

        if(currentProfile.counters)
            countersrepeater.model = currentProfile.counters.length;
    }

    Connections
    {
        target: context.vodapi

        onSimBalanceReceived: {
            if(!("data" in currentProfile))
                currentProfile.data = { };

            currentProfile.data.balance = result.balance;
            currentProfile.data.currency = result.currency;
            currentProfile.expiration_date = result.expiration_date;

            balanceoverview.actionText = result.action.caption;
            balanceoverview.actionUrl = result.action.web_url;

            overviewpage.update();
            context.commit();
        }

        onSimCountersReceived: {
            currentProfile.counters = result.counters;
            countersrepeater.model = currentProfile.counters.length;
            context.commit();
        }
    }

    id: overviewpage

    onCurrentProfileChanged: {
        if(!currentProfile)
            return;

        overviewpage.update();
        context.load();
    }

    onStatusChanged: {
        if((status !== PageStatus.Active) || !currentProfile)
            return;

        overviewpage.update();
        context.load();
    }

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: content.height

        PullDownMenu
        {
            MenuItem
            {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("../about/AboutPage.qml"), { "context": context });
            }

            MenuItem
            {
                text: qsTr("Profiles")
                onClicked: pageStack.push(Qt.resolvedUrl("ProfilePage.qml"), { "context": context });
            }

            MenuItem
            {
                text: qsTr("Refresh")
                onClicked: context.load()
            }
        }

        Column
        {
            id: content
            width: parent.width
            spacing: Theme.paddingMedium

            PageHeader { id: header }
            SectionHeader { id: balanceheader }

            BalanceOverview
            {
                id: balanceoverview
                width: parent.width
            }

            Repeater
            {
                id: countersrepeater

                delegate: CountersOverview {
                    readonly property var counter: currentProfile.counters[model.index]

                    width: content.width
                    context: overviewpage.context
                    currentProfile: overviewpage.currentProfile
                    counterIdx: model.index
                    counterId: counter.id
                    title: counter.name
                }
            }
        }
    }
}
