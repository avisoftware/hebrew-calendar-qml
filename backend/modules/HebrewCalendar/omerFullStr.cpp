#include "omerFullStr.h"
QString convertNumToDays(int n){
   QString weeks []= {QString::fromUtf8 ("שבוע אחד"),
                          QString::fromUtf8 ("שני שבועות"),
                          QString::fromUtf8 ("שלשה שבועות"),
                          QString::fromUtf8 ("ארבעה שבועות"),
                          QString::fromUtf8 ("חמשה שבועות"),
                          QString::fromUtf8 ("ששה שבועות"),
                           QString::fromUtf8 ("שבעה שבועות")};

    QString days []= { QString::fromUtf8 ("אחד"),
                QString::fromUtf8 ("שני"),
                QString::fromUtf8 ("שלשה"),
                QString::fromUtf8 ("ארבעה"),
                QString::fromUtf8 ("חמשה"),
                QString::fromUtf8 ("ששה")};
    int num_days = n % 7 ;
    int num_weeks = n/ 7 ;
    QString andS = QString::fromUtf8("ו");
    QString yamim = QString::fromUtf8("ימים");
    if (num_days==0){
        return (weeks [num_weeks-1]);
    }
    else if (num_days==1){
        return (weeks [num_weeks-1]+"\n"+andS+(QString::fromUtf8("יום"))+" "+days [num_days-1]);
    }
    return (weeks [num_weeks-1]+"\n"+andS+days [num_days-1]+" "+yamim);

}

QString dayORdays(int n){
    if (n>1 && n<11 )
    {
        return (QString::fromUtf8("ימים"));
    }
    else{
        return (QString::fromUtf8("יום"));
    }

}

QString convertNumOfOmerToString(int n)
{
   if (n == 0){
       return ( QString("null"));
   }
  QString num_asarot []= {QString::fromUtf8 ("עשר"),
                         QString::fromUtf8 ("עשרים"),
                         QString::fromUtf8 ("שלשים"),
                         QString::fromUtf8 ("ארבעים")};

   QString num_unit []= { QString::fromUtf8 ("אחד"),
               QString::fromUtf8 ("שנים"),
               QString::fromUtf8 ("שלשה"),
               QString::fromUtf8 ("ארבעה"),
               QString::fromUtf8 ("חמשה"),
               QString::fromUtf8 ("ששה"),
               QString::fromUtf8 ("שבעה"),
               QString::fromUtf8 ("שמונה"),
               QString::fromUtf8 ("תשעה")};
   int unit = n % 10 ;
   int asarot = n/ 10 ;
   if (asarot <= 0)
   {
       if (unit == 2)
       {
           return (QString::fromUtf8("שני"));
       }
       return (num_unit[n-1]);
   }
   else{
       if (unit==0)
       {
           if (asarot==1){
           return (QString::fromUtf8("עשרה"));
           }
            return ( num_asarot[asarot-1]);
       }
       QString andS = QString::fromUtf8("ו");

       if (n < 20){
           return (num_unit[unit-1] +" "+num_asarot[asarot-1]);
       }
       else{
       return ( num_unit[unit-1]+" "+andS+num_asarot[asarot-1]);
       }
   }

}

QString getSecondString (int n,int nosach){
   QString she = QString::fromUtf8("שהם");
   QString pirut = convertNumToDays(n);
   QString last_word;
   if(nosach==0){
    last_word = QString::fromUtf8("בעומר");
   }
   else if (nosach==1  ){
       last_word = QString::fromUtf8("לעומר");
   }
   else if(nosach==2){
       last_word = QString::fromUtf8("");
   }


   return (she+" "+pirut+" "+last_word);
}

QString getFirstString (int n,int nosach){
    if ( n == 0){
        return ( QString::fromUtf8("--------"));
    }else if(n<7){
        QString today = QString::fromUtf8("היום");
        QString num = convertNumOfOmerToString(n);
        QString days = dayORdays(n);
        QString last_word;
        if(nosach==0){
         last_word = QString::fromUtf8("בעומר");
        }
        else if (nosach==1 ){
            last_word = QString::fromUtf8("לעומר");
        }
        else if(nosach==2){
            last_word = QString::fromUtf8("לעומר");
        }
        if (n==0){
            return (today+" "+days+" "+num+" "+last_word);
        }
        return (today+" "+num+" "+days+" "+last_word);
    }
 QString today = QString::fromUtf8("היום");
 QString num = convertNumOfOmerToString(n);
 QString days = dayORdays(n);
 if (nosach==2){
     return (today+" "+num+" "+days+" "+QString::fromUtf8("לעומר"));
 }
 return (today+" "+num+" "+days);
}

QString getOmerFullString (int n,int nosach){
     QString firstString = getFirstString(n,nosach);
     if(n<7){
         return (firstString);
     }
     QString secondString = getSecondString(n,nosach);
     return (firstString+"\n"+secondString);

 }
