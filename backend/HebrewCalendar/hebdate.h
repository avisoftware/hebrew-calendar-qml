#ifndef MYTYPE_H
#define MYTYPE_H
#include <hdate.h>
#include <QObject>

class HDate : public QObject
{
    Q_OBJECT
public:
    explicit HDate(QObject *parent = 0);
    ~HDate();


    Q_INVOKABLE hdate_struct addMonths(hdate_struct h,int n);
    Q_INVOKABLE hdate_struct today();
    Q_INVOKABLE int getDay(hdate_struct h){return h.hd_day;}
    Q_INVOKABLE int getMonth(hdate_struct h){return h.hd_mon;}
    Q_INVOKABLE int getYear(hdate_struct h){return h.hd_year;}
//    Q_INVOKABLE int getGDay(hdate_struct h){return h.gd_day;}
//    Q_INVOKABLE int getGMonth(hdate_struct h){return h.gd_mon;}
//    Q_INVOKABLE int getGYear(hdate_struct h){return h.gd_year;}
    Q_INVOKABLE int getDayInWeek(hdate_struct h){return h.hd_dw;}

    Q_INVOKABLE hdate_struct weekStart(hdate_struct h);
    Q_INVOKABLE hdate_struct weekStartMonth(hdate_struct h);

    Q_INVOKABLE int daysInMonth(hdate_struct h);
    Q_INVOKABLE QString intToHebStr(int n);
    Q_INVOKABLE hdate_struct setHebDate(int y,int m,int d);
    Q_INVOKABLE QString getHebMonthStr(int m);
    Q_INVOKABLE QString getDayFullStr(hdate_struct h);
    Q_INVOKABLE QString getDayHolidayStr(hdate_struct h, int d);
    Q_INVOKABLE QString getDayParashaStr(hdate_struct h, int d);
    Q_INVOKABLE QString getDayOmerStr(hdate_struct h);
    Q_INVOKABLE QString getDayOmerFullStr(int n, int nosach);
    Q_INVOKABLE int getDayOmer(hdate_struct h);
    Q_INVOKABLE bool is_leap_year(int year);
    Q_INVOKABLE hdate_struct addDays(hdate_struct h,int n);

     Q_INVOKABLE bool smallTo(hdate_struct from, hdate_struct to);
    Q_INVOKABLE bool bigOrEquel(hdate_struct from, hdate_struct to);
// get times
// first you should calculate them
    Q_INVOKABLE void calcTimes(hdate_struct h, double longitude, double latitude);

    Q_INVOKABLE int getSunHour(){return sun_hour;}
    Q_INVOKABLE int getFirstLight(){return first_light;}
    Q_INVOKABLE int getTalit(){return talit;}
    Q_INVOKABLE int getSunrise(){return sunrise;}
    Q_INVOKABLE int getMidday(){return midday;}
    Q_INVOKABLE int getSunset(){return sunset;}
    Q_INVOKABLE int getFirstStars(){return first_stars;}
    Q_INVOKABLE int getThreeStars(){return three_stars;}
    Q_INVOKABLE int getFirstLightMga(){return first_light_mga;}
    Q_INVOKABLE int getFirstStarsMga(){return first_stars_mga;}
    Q_INVOKABLE int getThreeStarsCzhish(){return three_stars_czhish;}

    Q_INVOKABLE QString getTimeString(hdate_struct h,int min,QString tz);

    //check if the given date is before shabat or holiday. for times like candel light
     Q_INVOKABLE bool isDateBeforeHoliday(hdate_struct h, int d);
    //check if the given date is  shabat or holiday. for times like candel light
    Q_INVOKABLE int isDateHoliday(hdate_struct h, int d);
public slots:
     QString currentMonthStr(hdate_struct h);
signals:

protected:

private:
     hdate_struct nextMonth(hdate_struct h);
     hdate_struct previousMonth(hdate_struct h);
    int init;
    hdate_struct today_h;
    hdate_struct current_h;

    int sun_hour, first_light, talit, sunrise;
    int midday, sunset, first_stars, three_stars;
    int first_light_mga,first_stars_mga;
    int three_stars_czhish;
};
#endif // MYTYPE_H

