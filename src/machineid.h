#ifndef MACHINEID_H
#define MACHINEID_H

#include <QObject>

class MachineID : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString value READ value CONSTANT FINAL)

    public:
        explicit MachineID(QObject *parent = 0);
        QString value() const;

    private:
        QString _value;
};

#endif // MACHINE_ID
