import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.vodcounter.MachineID 1.0
import harbour.vodcounter.Request 1.0
import harbour.vodcounter.Cryptography 1.0 as Cryptography
import "user"
import "../js/vod/VodEP.js" as VodEP
import "../js/vod/VodERR.js" as VodERR
import "../js/LocalStorage.js" as LocalStorage

Item
{
    property MachineID machineId: MachineID { }
    property UserProfile profile
    property string installationId
    property string secretKey
    property string sessionId
    property bool loggedIn: false

    readonly property bool registered: (vodapi.installationId.length > 0) && (vodapi.secretKey.length > 0)
    readonly property bool sessionCreated: vodapi.sessionId.length > 0

    signal loginSuccess()
    signal sessionSuccess()
    signal registerSuccess()

    signal simBalanceReceived(var result)
    signal simCountersReceived(var result)
    signal simCounterDetailsReceived(var result)

    signal loginError(string errmsg)
    signal error(string description, string code);

    id: vodapi

    Item
    {
        readonly property string appId: rot13("ZlIbqnsbar")
        readonly property string appPlatform: "Android"
        readonly property string appVersion: "7.2.0"

        readonly property string osName: "Android"
        readonly property string osVersion: "4.4"

        readonly property string deviceVendor: "Nexus"
        readonly property string deviceModel: "4"

        readonly property string pushProvider: "Android"

        readonly property string host: rot13("zl190.ibqnsbar.vg")
        readonly property string flavor: rot13("cebq")

        id: vodapi_private

        Component {
            id: apirequest
            APIRequest { }
        }

        function rot13(s) {
            return s.replace(/[a-zA-Z]/g, function(c){
                return String.fromCharCode((c <= "Z" ? 90 : 122) >= (c = c.charCodeAt(0) + 13) ? c : c - 26);
            });
        }

        function vodreq_get(endpoint, callback, ignoreerror) { vodreq("GET", endpoint, null, callback, ignoreerror); }
        function vodreq_post(endpoint, data, callback, ignoreerror) { vodreq("POST", endpoint, data, callback, ignoreerror); }
        function vodreq13_get(endpoint, callback, ignoreerror) { vodreq("GET", rot13(endpoint), null, callback, ignoreerror); }
        function vodreq13_post(endpoint, data, callback, ignoreerror) { vodreq("POST", rot13(endpoint), data, callback, ignoreerror); }

        function vodreq(type, endpoint, data, callback, ignoreerror) {
            var req = apirequest.createObject(vodapi);
            req.requestType = type;

            if(vodapi.installationId.length > 0)
                req.installationId = vodapi.installationId;

            if(vodapi.sessionId.length > 0)
                req.sessionId = vodapi.sessionId;

            if(vodapi.secretKey.length > 0)
                req.secretKey = vodapi.secretKey;

            req.completed.connect(function(replydata) {
                //console.log(replydata);

                if(callback)
                    onreply(JSON.parse(replydata), callback, ignoreerror);
            });

            req.networkError.connect(function(errmsg, code) { error(errmsg, code); });

            if(data) {
                req.send(vodapi_private.host, endpoint, JSON.stringify(data));
                return;
            }

            req.send(vodapi_private.host, endpoint);
        }

        function onreply(replyobj, callback, ignoreerror) {
            if((ignoreerror !== true) && (replyobj.code !== 0)) {
                vodapi.error(replyobj.description, replyobj.code);
                return;
            }

            if("result" in replyobj) {
                callback(replyobj.result);
                return;
            }

            callback(replyobj);
        }

        function register_reqly(result) {
            vodapi.installationId = result.installation_id;
            vodapi.secretKey = result.secret_key;

            vodapi.registerSuccess();
        }

        function session_start_reply(result) {
            vodapi.sessionId = result.session_id;
            vodapi.sessionSuccess();
        }

        function login_reply(result) {
            if(!("code" in result)) {
                profile.loadObj(result);

                vodapi.loggedIn = true;
                vodapi.loginSuccess();
                return;
            }

            vodapi.loggedIn = false;
            vodapi.loginError(result.description);
        }

        function sim_balance_reply(result) { vodapi.simBalanceReceived(result); }
        function sim_counters_reply(result) { vodapi.simCountersReceived(result); }
        function sim_counter_details_reply(result) { vodapi.simCounterDetailsReceived(result); }
    }

    function register() {
        var data = { "app_id": vodapi_private.appId,
                     "app_platform": vodapi_private.appPlatform,
                     "app_version": vodapi_private.appVersion,
                     "device_udid": vodapi.machineId.value };

        vodapi_private.vodreq13_post(VodEP.DO_REGISTRATION_ENDPOINT, data, vodapi_private.register_reqly);
    }

    function session_start() {
        var data = { "app_id": vodapi_private.appId,
                     "app_platform": vodapi_private.appPlatform,
                     "app_version": vodapi_private.appVersion,
                     "os_name": vodapi_private.osName,
                     "os_version": vodapi_private.osVersion,
                     "device_vendor": vodapi_private.deviceVendor,
                     "device_model": vodapi_private.deviceModel,
                     "screen_width": Screen.width,
                     "screen_height": Screen.height,
                     "screen_ratio": Theme.pixelRatio,
                     "push_provider": vodapi_private.pushProvider,
                     "push_types": "broadcast-simple",
                     "device_is_tablet": false,
                     "device_udid": vodapi.machineId.value };

        vodapi_private.vodreq13_post(VodEP.DO_START_SESSION_ENDPOINT, data, vodapi_private.session_start_reply);
    }

    function login(username, password) {
        if(username && password) {
            LocalStorage.config.credentials = { "first": Cryptography.AES256.encode(username, machineId.value),
                                                "second":Cryptography.AES256.encode(password, machineId.value) };
        }
        else {
            username = Cryptography.AES256.decode(LocalStorage.config.credentials.first, machineId.value);
            password = Cryptography.AES256.decode(LocalStorage.config.credentials.second, machineId.value);
        }

        var data = { "username": username,
                     "password": password };

        vodapi_private.vodreq13_post(VodEP.DO_LOGIN_ENDPOINT, data, vodapi_private.login_reply, true);
    }

    function logout() {
        vodapi_private.vodreq13_post(VodEP.DO_LOGOUT_ENDPOINT, null, null);
    }

    function sim_balance(msidsn) {
        var endpoint = vodapi_private.rot13(VodEP.DO_SIM_BALANCE_ENDPOINT).replace(":msidsn:", msidsn);
        vodapi_private.vodreq_get(endpoint, vodapi_private.sim_balance_reply);
    }

    function sim_counters(msidsn) {
        var endpoint = vodapi_private.rot13(VodEP.DO_SIM_COUNTERS_ENDPOINT).replace(":msidsn:", msidsn);
        vodapi_private.vodreq_get(endpoint, vodapi_private.sim_counters_reply);
    }

    function sim_counter_details(msidsn, counterid) {
        var endpoint = vodapi_private.rot13(VodEP.DO_SIM_COUNTER_DETAILS_ENDPOINT).replace(":msidsn:", msidsn).replace(":counterid:", counterid);
        vodapi_private.vodreq_get(endpoint, vodapi_private.sim_counter_details_reply);
    }
}
