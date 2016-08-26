import QtQuick 2.1
import Sailfish.Silica 1.0
import "pages/login"
import "pages/main"
import "model"
import "cover"
import "js/LocalStorage.js" as LocalStorage

ApplicationWindow
{
    readonly property Context context: context

    Context {
        id: context

        vodapi {
            onSessionSuccess: {
                if(LocalStorage.config.credentials) {
                    vodapi.login();
                    return;
                }

                pageStack.completeAnimation();
                pageStack.replace(Qt.resolvedUrl("pages/login/LoginPage.qml"), { "context": context });
            }

            onLoginError: {
                pageStack.completeAnimation();
                pageStack.replace(Qt.resolvedUrl("pages/login/LoginPage.qml"), { "context": context, "errorMessage": errmsg });
            }

            onLoginSuccess: {
                LocalStorage.config.installation_id = context.vodapi.installationId;
                LocalStorage.config.secret_key = context.vodapi.secretKey;

                if(pageStack.currentPage.isOverviewPage === true)
                    return;

                pageStack.completeAnimation();
                pageStack.replace(Qt.resolvedUrl("pages/main/OverviewPage.qml"), { "context": context });
            }
        }
    }

    id: mainwindow
    allowedOrientations: Orientation.Portrait
    _defaultPageOrientations: Orientation.Portrait

    initialPage: Component {
        ConnectionPage {
            context: mainwindow.context
        }
    }

    cover: CoverPage {
        context: mainwindow.context
    }

    Component.onCompleted: {
        LocalStorage.load();
        context.profile.load();

        if(LocalStorage.config.installation_id)
            context.vodapi.installationId = LocalStorage.config.installation_id;

        if(LocalStorage.config.secret_key)
            context.vodapi.secretKey = LocalStorage.config.secret_key;

        if(LocalStorage.config.profile)
            context.vodapi.loggedIn = true;

        if(!context.vodapi.registered) {
            context.vodapi.register();
            return;
        }

        if(!context.vodapi.sessionCreated) {
            context.vodapi.session_start();
            return;
        }

        context.commit();
    }

    Component.onDestruction: {
        LocalStorage.save();
        context.vodapi.logout();
    }
}
