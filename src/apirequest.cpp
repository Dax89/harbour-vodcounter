#include "apirequest.h"
#include <QGuiApplication>
#include <QMessageAuthenticationCode>

QNetworkAccessManager* APIRequest::_nam = NULL;

APIRequest::APIRequest(QObject *parent) : QObject(parent)
{
    if(!APIRequest::_nam)
        APIRequest::_nam = new QNetworkAccessManager();
}

QString APIRequest::installationId() const
{
    return this->_installationid;
}

QString APIRequest::secretKey() const
{
    return this->_secretkey;
}

QString APIRequest::sessionId() const
{
    return this->_sessionid;
}

QString APIRequest::requestType() const
{
    return this->_requesttype;
}

void APIRequest::setInstallationId(const QString &installationid)
{
    if(this->_installationid == installationid)
        return;

    this->_installationid = installationid;
    this->makeAuthorizationKey();
    emit installationIdChanged();
}

void APIRequest::setSessionId(const QString &sessionid)
{
    if(this->_sessionid == sessionid)
        return;

    this->_sessionid = sessionid;
    emit sessionIdChanged();
}

void APIRequest::setSecretKey(const QString &secretkey)
{
    if(this->_secretkey == secretkey)
        return;

    this->_secretkey = secretkey;
    this->makeAuthorizationKey();
    emit secretKeyChanged();
}

void APIRequest::setRequestType(const QString &requesttype)
{
    if(this->_requesttype == requesttype)
        return;

    this->_requesttype = requesttype;
    emit requestTypeChanged();
}

void APIRequest::send(QString host, QString endpoint, QString data)
{
    QNetworkRequest req(QUrl(QString("https://%1%3").arg(host).arg(endpoint)));
    qDebug() << "CALL:" << req.url().toString();

    req.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json").toUtf8());

    if(!this->_installationid.isEmpty())
        req.setRawHeader(QString("X-Bwb-InstallationId").toUtf8(), this->_installationid.toUtf8());

    if(!this->_sessionid.isEmpty())
        req.setRawHeader(QString("X-Bwb-SessionId").toUtf8(), this->_sessionid.toUtf8());

    if(!this->_authorizationkey.isEmpty())
        req.setRawHeader(QString("Authorization").toUtf8(), this->_authorizationkey);

    // SSL Workaround
    QSslConfiguration sslconf = req.sslConfiguration();
    sslconf.setPeerVerifyMode(QSslSocket::VerifyNone);
    req.setSslConfiguration(sslconf);

    QNetworkReply* reply = NULL;

    if(this->_requesttype == "POST")
        reply = APIRequest::_nam->post(req, data.toUtf8());
    else if(this->_requesttype == "GET")
        reply = APIRequest::_nam->get(req);
    else
        return;

    connect(reply, &QNetworkReply::finished, this, &APIRequest::onFinished);
    connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(onError(QNetworkReply::NetworkError)));
}

void APIRequest::send(QString host, QString endpoint)
{
    this->send(host, endpoint, QString());
}

void APIRequest::makeAuthorizationKey()
{
    if(this->_installationid.isEmpty() || this->_secretkey.isEmpty())
        return;

    QString token = "iid=" + this->_installationid;

    if(!this->_sessionid.isEmpty())
        token += ";sid=" + this->_sessionid;

    this->_authorizationkey = QMessageAuthenticationCode::hash(this->_secretkey.toUtf8(), token.toUtf8(), QCryptographicHash::Sha1).toBase64();
}

void APIRequest::onFinished()
{
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(this->sender());

    if(reply->error() == QNetworkReply::NoError) {
        QByteArray data(reply->readAll());
        emit completed(QString::fromUtf8(data));
    }

    reply->deleteLater();
    reply = NULL;
}

void APIRequest::onError(QNetworkReply::NetworkError error)
{
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(this->sender());
    emit networkError(reply->errorString(), -error);

    reply->deleteLater();
    reply = NULL;
}
