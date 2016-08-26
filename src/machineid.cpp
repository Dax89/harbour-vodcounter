#include "machineid.h"
#include <QFile>
#include <QDebug>

MachineID::MachineID(QObject *parent) : QObject(parent)
{
    QFile file("/var/lib/dbus/machine-id");

    if(!file.open(QFile::ReadOnly))
    {
        qWarning() << "Cannot get machine-id";
        return;
    }

    this->_value = QString(file.readAll()).simplified();
    file.close();
}

QString MachineID::value() const
{
    return this->_value;
}

