import QtQuick 2.1
import "../../js/vod/VodHelper.js" as VodHelper
import "../../js/LocalStorage.js" as LocalStorage

Item
{
    property string userName
    property string firstName
    property string lastName
    property string email
    property string token
    property int currentIndex: -1

    property var currentItem: {
        if(currentIndex == -1)
            return null;

        var items = LocalStorage.config.profile.items;

        if(currentIndex >= items.count)
            return null;

        return items[currentIndex];
    }

    function makeItem(type, msidsn, expirationdate) {
        var obj = { "type": VodHelper.fixCase(type),
                    "msidsn": msidsn,
                    "expiration_date": expirationdate,
                    "data": { "balance": 0, "currency": "" } };

        return obj;
    }

    function save() {
        if(!LocalStorage.config.profile)
            LocalStorage.config.profile = { };

        LocalStorage.config.profile.username = userprofile.userName;
        LocalStorage.config.profile.firstname = userprofile.firstName;
        LocalStorage.config.profile.lastname = userprofile.lastName;
        LocalStorage.config.profile.email = userprofile.email;
        LocalStorage.config.profile.token = userprofile.token;
    }

    function load() {
        if(!LocalStorage.config.profile)
            return;

        userprofile.userName = LocalStorage.config.profile.username;
        userprofile.firstName = LocalStorage.config.profile.firstname;
        userprofile.lastName = LocalStorage.config.profile.lastname;
        userprofile.email = LocalStorage.config.profile.email;
        userprofile.token = LocalStorage.config.profile.token;

        currentIndex = 0;
    }

    function loadObj(profileobj) {
        userprofile.userName = profileobj.username;
        userprofile.firstName = profileobj.firstname;
        userprofile.lastName = profileobj.lastname;
        userprofile.email = profileobj.email;
        userprofile.token = profileobj.token;

        currentIndex = -1;

        if(!LocalStorage.config.profile)
            LocalStorage.config.profile = { };

        if(!LocalStorage.config.profile.items) {
            LocalStorage.config.profile.items = [ ];

            profileobj.items.forEach(function(item) {
                LocalStorage.config.profile.items.push(makeItem(item.type, item.value, item.expiration_date));
            });

        }
        else {
            var dstitems = LocalStorage.config.profile.items;

            for(var i = 0; i < profileobj.length; i++) {
                var srcitem = profileobj.items[i];
                var dstitem = dstitems[i];

                if(i < dstitems.length) {
                    dstitem[i].type = srcitem.type;
                    dstitem[i].msidsn = srcitem.value;
                    dstitem[i].expiration_date = srcitem.expiration_date;
                }
                else
                    dstitems.push(makeItem(srcitem.type, srcitem.value, srcitem.expiration_date));
            }
        }

        currentIndex = 0;
        save();
    }

    id: userprofile
}

