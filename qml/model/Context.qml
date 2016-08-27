import QtQuick 2.1
import harbour.vodcounter.MachineID 1.0
import "user"
import "../js/LocalStorage.js" as LocalStorage

Item
{
    readonly property string version: "0.5"

    property UserProfile profile: UserProfile  { }

    property VodAPI vodapi: VodAPI {
        profile: context.profile
        onRegisterSuccess: context.vodapi.session_start();

        onError: {
            if((code < 0) && (pageStack.currentPage.isOverviewPage !== true)) { // Fallback to OverviewPage in case of NetworkError
                pageStack.completeAnimation();
                pageStack.replace(Qt.resolvedUrl("../pages/main/OverviewPage.qml"), { "context": context });
                commited();
            }

            console.log("ERROR: " + description + " (" + code + ")");
        }
    }

    signal commited()

    function commit() { commited(); }
    function load() { timrequests.start(); }

    id: context

    Timer
    {
        property int maxRequests: 2
        property int requestsCount: 0

        id: timrequests
        interval: 500

        onTriggered: {
            if(requestsCount === 0) {
                vodapi.sim_balance(context.profile.currentItem.msidsn)
                requestsCount++;
            }
            else if(requestsCount === 1) {
                vodapi.sim_counters(context.profile.currentItem.msidsn)
                requestsCount++;
            }

            if(requestsCount < maxRequests) {
                start();
                return;
            }

            requestsCount = 0;
        }
    }
}
