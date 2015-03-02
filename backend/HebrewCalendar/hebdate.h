#ifndef MYTYPE_H
#define MYTYPE_H
#include <hdate.h>
#include <QObject>

class HDate : public QObject
{
    Q_OBJECT
    Q_PROPERTY( QString thisMonth READ thisMonth )

public:
    explicit HDate(QObject *parent = 0);
    ~HDate();
protected:
    QString thisMonth() ;

};

#endif // MYTYPE_H

