#include "hebdate.h"
#include <QDate>
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
    return (hdate_get_int_string(n));
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
    QString y =hdate_get_int_string(h.hd_year);
    return m + " "+y;
}

hdate_struct HDate::today()
{
    hdate_set_gdate (&today_h, 0, 0, 0);
    current_h=today_h;
    init =1;
    return today_h;
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
