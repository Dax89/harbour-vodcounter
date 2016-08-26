#include "localstoragefile.h"
#include <QStandardPaths>
#include <QFile>

const QString LocalStorageFile::CONFIG_FILE = "localstorage.json";
const QString LocalStorageFile::CONFIG_FOLDER = "vod_data";

LocalStorageFile::LocalStorageFile(QObject *parent) : QObject(parent)
{
    QString endpath = qApp->applicationName() + QDir::separator() + qApp->applicationName() + QDir::separator() + LocalStorageFile::CONFIG_FOLDER;

    this->_cfgdir = QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation);
    this->_cfgdir.mkpath(endpath);
    this->_cfgdir.cd(endpath);
}

QObject *LocalStorageFile::initialize(QQmlEngine*, QJSEngine*)
{
    return new LocalStorageFile();
}

void LocalStorageFile::save(const QString& jsondata)
{
    QString filename = this->_cfgdir.absoluteFilePath(LocalStorageFile::CONFIG_FILE);

    QFile f(filename);
    f.open(QFile::WriteOnly);
    f.write(jsondata.toUtf8());
    f.close();
}

QString LocalStorageFile::load()
{
    QString filename = this->_cfgdir.absoluteFilePath(LocalStorageFile::CONFIG_FILE);

    if(!QFile::exists(filename))
        return QString();

    QFile f(filename);
    f.open(QFile::ReadOnly);

    QString s = QString::fromUtf8(f.readAll());
    f.close();
    return s;
}

