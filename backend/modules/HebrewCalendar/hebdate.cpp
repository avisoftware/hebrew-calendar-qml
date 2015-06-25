#include <QDate>
#include "hebdate.h"
#include "omerFullStr.h"
#include <qdatetime.h>
#include <time.h>
HDate::HDate(QObject *parent) :
    QObject(parent)
{
}

HDate::~HDate() {

}

hdate_struct HDate::weekStart(hdate_struct h)
{
   // hdate_struct date = h;
    int day = h.hd_dw, n = 0;
    while (day != 1) {
        if (day == 0) day = 6;
        else day = day - 1;
        n = n + 1;
    }
    return addDays(h,-n);

}

hdate_struct HDate::weekStartMonth(hdate_struct h)
{
        hdate_set_hdate (&h, 1, h.hd_mon, h.hd_year);
        int jd_current_month = h.hd_jd - h.hd_dw + 1;
        hdate_struct h1;
        hdate_set_jd (&h1, jd_current_month);
            return h1;
}

int HDate::daysInMonth(hdate_struct h)
{
    switch (h.hd_mon) {
    case 1:
        return 30;
        break;
    case 2:
        if(h.hd_size_of_year==355||h.hd_size_of_year==385){
            return 30;
        }else{
            return 29;
        }
        break;
    case 3:
        if(h.hd_size_of_year==353||h.hd_size_of_year==383){
            return 29;
        }else{
            return 30;
        }
        break;
    case 4:
        return 29;
        break;
    case 5:
        return 30;
        break;
    case 6:
        return 29;
        break;
    case 7:
        return 30;
        break;
    case 8:
        return 29;
        break;
    case 9:
        return 30;
        break;
    case 10:
        return 29;
        break;
    case 11:
        return 30;
        break;
    case 12:
        return 29;
        break;
    case 13:
        return 30;
        break;
    case 14:
        return 29;
        break;
    default:
        break;
    }
    return 0;
}

QString HDate::intToHebStr(int n)
{
     if(hdate_is_hebrew_locale()==-1){
        return (hdate_get_int_string(n));
     }
     return QString::number(n);
}

hdate_struct HDate::setHebDate(int y, int m, int d)
{
    hdate_struct h;
    hdate_set_hdate (&h, d, m, y);
    return h;
}

QString HDate::getHebMonthStr(int m)
{
    return hdate_get_hebrew_month_string(m,1);
}

QString HDate::getDayFullStr(hdate_struct h)
{
    return (QString(hdate_get_day_string(h.hd_dw,0))+" "+QString(hdate_get_int_string(h.hd_day))+" "+
           QString( hdate_get_hebrew_month_string(h.hd_mon,1))+" "+QString(hdate_get_int_string(h.hd_year))+" "+
            QString::number(h.gd_day)+"."+QString::number(h.gd_mon)+"."+QString::number(h.gd_year));
}

QString HDate::getDayHolidayStr(hdate_struct h,int d)
{
    int hol = hdate_get_holyday(&h, d);
    return(hdate_get_holyday_string(hol,d));
}

QString HDate::getDayParashaStr(hdate_struct h,int d)
{
    int p=hdate_get_parasha(&h,d);
    return hdate_get_parasha_string(p,d);
}
 int HDate::getDayOmer(hdate_struct h){
    return(hdate_get_omer_day(&h));
}

QString HDate::getDayOmerStr(hdate_struct h)
{
    int o=hdate_get_omer_day(&h);
    return hdate_get_omer_string(o);
}

QString HDate::getDayOmerFullStr(int n,int nosach)
{
    return (getOmerFullString(n,nosach));
}

hdate_struct HDate::nextMonth(hdate_struct h)
{
    int m =h.hd_mon;
    int y=h.hd_year;
    hdate_struct h_t;
    if(m==12){
        y=y+1;
        m=1;
    }else if(is_leap_year(y)&&m==5){
        m=13;
    }else if(m==13){
        m=14;
    }else if(m==14){
        m=7;
    }else{
        m=m+1;
    }
    hdate_set_hdate(&h_t,1,m,y);
    current_h=h_t;

    return(h_t);
}

hdate_struct HDate::previousMonth(hdate_struct h)
{
   int  m =h.hd_mon;
   int  y=h.hd_year;
    hdate_struct h_t;
    if(m==1){
        y=y-1;
        m=12;
    }else if(is_leap_year(y)&&m==7){
        m=14;
    }else if(m==13){
        m=5;
    }else if(m==14){
        m=13;
    }else{
        m=m-1;
    }
    hdate_set_hdate(&h_t,1,m,y);
    current_h=h_t;

    return(h_t);
}

hdate_struct HDate::addMonths(hdate_struct h, int n)
{
    hdate_struct h1 = h;
    if(n>0){
        for(int i =0; i<n;i++){
            h1 = nextMonth(h1);
        }
    }else if(n<0){
        for(int i =0; i>n;i--){
            h1 = previousMonth(h1);
        }
    }
    return h1;
}

QString HDate::currentMonthStr(hdate_struct h)
{
    QString m =hdate_get_hebrew_month_string(h.hd_mon,0);
    QString y;
    if(hdate_is_hebrew_locale()==-1){
        y =hdate_get_int_string(h.hd_year);
    }else{
        y= QString::number(h.hd_year);
    }
    return m + " "+y;
}

hdate_struct HDate::today()
{
    hdate_set_gdate (&today_h, 0, 0, 0);
    current_h=today_h;
    init =1;
    return today_h;
}

void HDate::calcTimes(hdate_struct h,double longitude, double latitude)
{
    sun_hour=0, first_light=0, talit=0, sunrise=0;
    midday=0, sunset=0, first_stars=0, three_stars=0;
    first_light_mga=0,first_stars_mga=0;
    three_stars_czhish=0;
    int place_holder;

    hdate_get_utc_sun_time_full (h.gd_day, h.gd_mon, h.gd_year, latitude, longitude,/*height,*/
                                 &sun_hour, &first_light, &talit, &sunrise,
                                 &midday, &sunset, &first_stars, &three_stars);
    hdate_get_utc_sun_time_deg (h.gd_day, h.gd_mon, h.gd_year, latitude, longitude, 99.28, &place_holder, &three_stars_czhish);
    /* first light and first stars by the magen avraham*/
    hdate_get_utc_sun_time_deg (h.gd_day, h.gd_mon, h.gd_year, latitude, longitude,109.75, &first_light_mga, &first_stars_mga);
}

QString HDate::getTimeString(hdate_struct h, int min, QString tz)
{
    struct tm tm;
       time_t timenum;

       //mktime has the side effect of normalizing tm
       tm.tm_min=min;
       tm.tm_hour=0;
       tm.tm_sec=0;
       tm.tm_mon=h.gd_mon-1;
       tm.tm_mday=h.gd_day;
       tm.tm_year=h.gd_year-1900;
       tm.tm_isdst=0;
       //tm.tm_gmtoff=0;

       //Get timenum for the UTC time.
       putenv("TZ=UTC");
       tzset();
       timenum=mktime(&tm);
       //Convert back to the requested local timezone
       setenv("TZ",tz.toLatin1(),1);
       tzset();
       localtime_r(&timenum,&tm);

       return (QTime (tm.tm_hour,tm.tm_min).toString("hh:mm"));
}

bool HDate::isDateBeforeHoliday(hdate_struct h,int d)
{
    hdate_struct  h1 = addDays(h,1);
    int hol_tomorow = hdate_get_holyday(&h1, d);
    if(h.hd_dw==6||hdate_get_holyday_type(hol_tomorow)==1)
        return true;

    return false;
}

int HDate::isDateHoliday(hdate_struct h,int d)
{
    int hol = hdate_get_holyday(&h, d);
    int hol_t=hdate_get_holyday_type(hol);
    if(h.hd_dw==7||(hol_t>0)){
        //return 10 if it is shabat instead of separated this function.
        if(hol_t>0){
          return hol_t;
        }else if(h.hd_dw==7){
            return 10;
        }
    }
    return 0;
}

bool HDate::is_leap_year(int year){
    int length_of_year;
    int days_from_3744;

    days_from_3744 = hdate_days_from_3744 (year);
    length_of_year = hdate_days_from_3744 (year + 1) - days_from_3744;
    if (length_of_year>365){
        return true;
    }
    return false;
}

hdate_struct HDate::addDays(hdate_struct h, int n)
{
    hdate_struct h1;
   QDate d(h.gd_year,h.gd_mon,h.gd_day);
   d =d.addDays(n);
   hdate_set_gdate (&h1, d.day(), d.month(),d.year());
   return h1;
}

bool HDate::smallTo(hdate_struct from, hdate_struct to)
{
    QDate fromD (from.gd_year,from.gd_mon,from.gd_day);
    QDate toD (to.gd_year,to.gd_mon,to.gd_day);
    return (fromD<toD);

}

bool HDate::bigOrEquel(hdate_struct from, hdate_struct to)
{
    QDate fromD (from.gd_year,from.gd_mon,from.gd_day);
    QDate toD (to.gd_year,to.gd_mon,to.gd_day);

    return (fromD>=toD);
}
