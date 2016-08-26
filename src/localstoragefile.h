#ifndef LOCALSTORAGEFILE_H
#define LOCALSTORAGEFILE_H

#include <QObject>
#include <QtQml>
#include <QDir>

class LocalStorageFile : public QObject
{
    Q_OBJECT

    public:
        explicit LocalStorageFile(QObject *parent = 0);
        static QObject* initialize(QQmlEngine*, QJSEngine *);

    public slots:
        void save(const QString &jsondata);
        QString load();

    private:
        QDir _cfgdir;

    private:
        static const QString CONFIG_FILE;
        static const QString CONFIG_FOLDER;
};

#endif // LOCALSTORAGEFILE_H
