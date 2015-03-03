﻿#ifndef MYTYPE_H
#define MYTYPE_H
#include <hdate.h>
#include <QObject>

class HDate : public QObject
{
    Q_OBJECT

    Q_PROPERTY( QString currentMonthStr READ currentMonthStr NOTIFY currentMonthStrChanged)
    Q_PROPERTY( hdate_struct today READ today )
    Q_PROPERTY( hdate_struct currentDate READ currentDate NOTIFY currentDateChanged)
    Q_PROPERTY( hdate_struct nextMonth READ nextMonth )
    Q_PROPERTY( hdate_struct previousMonth READ previousMonth )

public:
    explicit HDate(QObject *parent = 0);
    ~HDate();
    Q_INVOKABLE int getDay(hdate_struct h){return h.hd_day;}
    Q_INVOKABLE int getMonth(hdate_struct h){return h.hd_mon;}
    Q_INVOKABLE int getYear(hdate_struct h){return h.hd_year;}
    Q_INVOKABLE hdate_struct weekStart(hdate_struct h);
signals:
    void currentDateChanged();
    void currentMonthStrChanged();
protected:
    QString currentMonthStr() ;
    hdate_struct today ();
    hdate_struct currentDate();
    hdate_struct nextMonth();
    hdate_struct previousMonth();
private:
    int init;
    hdate_struct today_h;
    hdate_struct current_h;
    int is_leap_year(int year);
};
#endif // MYTYPE_H

