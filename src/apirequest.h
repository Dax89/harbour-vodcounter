#ifndef APIREQUEST_H
#define APIREQUEST_H

#include <QObject>
#include <QTimer>
#include <QtQml>

class APIRequest : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString installationId READ installationId WRITE setInstallationId NOTIFY installationIdChanged)
    Q_PROPERTY(QString secretKey READ secretKey WRITE setSecretKey NOTIFY secretKeyChanged)
    Q_PROPERTY(QString sessionId READ sessionId WRITE setSessionId NOTIFY sessionIdChanged)
    Q_PROPERTY(QString requestType READ requestType WRITE setRequestType NOTIFY requestTypeChanged)

    public:
        explicit APIRequest(QObject *parent = 0);
        QString installationId() const;
        QString secretKey() const;
        QString sessionId() const;
        QString requestType() const;
        void setInstallationId(const QString& installationid);
        void setSessionId(const QString& sessionid);
        void setSecretKey(const QString& secretkey);
        void setRequestType(const QString& requesttype);

    public slots:
        void send(QString host, QString endpoint, QString data);
        void send(QString host, QString endpoint);

    private:
        void makeAuthorizationKey();

    private slots:
        void onFinished();
        void onError(QNetworkReply::NetworkError error);

    signals:
        void installationIdChanged();
        void secretKeyChanged();
        void sessionIdChanged();
        void requestTypeChanged();
        void completed(QString data);
        void networkError(QString errormsg, int code);

    private:
        QString _installationid;
        QString _sessionid;
        QString _secretkey;
        QString _requesttype;
        QByteArray _authorizationkey;
        static QNetworkAccessManager* _nam;

};

#endif // APIREQUEST_H
