#ifndef MYTYPE_H
#define MYTYPE_H
#include <hdate.h>
#include <QObject>

class HDate : public QObject
{
    Q_OBJECT

//    Q_PROPERTY( QString currentMonthStr READ currentMonthStr NOTIFY currentMonthStrChanged)

//    Q_PROPERTY( hdate_struct currentDate READ currentDate NOTIFY currentDateChanged)
//    Q_PROPERTY( hdate_struct nextMonth READ nextMonth )
//    Q_PROPERTY( hdate_struct previousMonth READ previousMonth )

public:
    explicit HDate(QObject *parent = 0);
    ~HDate();

    Q_INVOKABLE hdate_struct nextMonth();
    Q_INVOKABLE hdate_struct previousMonth();
    Q_INVOKABLE hdate_struct today();
    Q_INVOKABLE int getDay(hdate_struct h){return h.hd_day;}
    Q_INVOKABLE int getMonth(hdate_struct h){return h.hd_mon;}
    Q_INVOKABLE int getYear(hdate_struct h){return h.hd_year;}
    Q_INVOKABLE int getDayInWeek(hdate_struct h){return h.hd_dw;}
    Q_INVOKABLE hdate_struct weekStart(hdate_struct h);
    Q_INVOKABLE int daysInMonth(hdate_struct h);
    Q_INVOKABLE QString intToHebStr(int n);
    Q_INVOKABLE hdate_struct setHebDate(int y,int m,int d);
    Q_INVOKABLE QString getHebMonthStr(int m);
    Q_INVOKABLE bool is_leap_year(int year);
    Q_INVOKABLE hdate_struct addDays(hdate_struct h,int n);

     Q_INVOKABLE bool smallTo(hdate_struct from, hdate_struct to);
    Q_INVOKABLE bool bigOrEquel(hdate_struct from, hdate_struct to);
public slots:
     QString currentMonthStr(hdate_struct h);
signals:

protected:

private:
    int init;
    hdate_struct today_h;
    hdate_struct current_h;

};
#endif // MYTYPE_H

