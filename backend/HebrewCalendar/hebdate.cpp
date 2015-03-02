#include "hebdate.h"

HDate::HDate(QObject *parent) :
    QObject(parent)
{

}

HDate::~HDate() {

}

QString HDate::thisMonth()
{
    hdate_struct h;
     hdate_set_gdate (&h, 0, 0, 0);
     QString m =hdate_get_hebrew_month_string(h.hd_mon,0);
     QString y =hdate_get_int_string(h.hd_year);
     return m + " "+y;
}

