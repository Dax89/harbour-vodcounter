#include <QtQuick>
#include <sailfishapp.h>
#include "cryptography/aes256.h"
#include "machineid.h"
#include "apirequest.h"
#include "localstoragefile.h"

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> application(SailfishApp::application(argc, argv));
    application->setApplicationName("harbour-vodcounter");

    qmlRegisterType<APIRequest>("harbour.vodcounter.Request", 1, 0, "APIRequest");
    qmlRegisterType<MachineID>("harbour.vodcounter.MachineID", 1, 0, "MachineID");
    qmlRegisterSingletonType<LocalStorageFile>("harbour.vodcounter.LocalStorageFile", 1, 0, "LocalStorageFile", &LocalStorageFile::initialize);
    qmlRegisterSingletonType<AES256>("harbour.vodcounter.Cryptography", 1, 0, "AES256", &AES256::initialize);

    QScopedPointer<QQuickView> view(SailfishApp::createView());
    view->setSource(SailfishApp::pathTo("qml/harbour-vodcounter.qml"));
    view->show();

    return application->exec();
}

