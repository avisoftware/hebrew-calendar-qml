
{
This unit create a Pascal object oriented class for libhdate.
This unit is created as a true object oriented class.

   Copyright  2005-2008       Ido Kanner <idokan@gmail.com>

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.

History:
       25/01/2008 - Added support for newer API of hdate
       12/01/2008 - Added support for dynamic linking
    19-21/05/2005 - Initial creation

 }
{$IFDEF FPC}
  {$MODE OBJFPC} {$H+}
  {.$DEFINE STATIC_LINK}
{$ELSE}
  {$Warning 'This code was tested with Free Pascal Only.'}
{$ENDIF}


Unit hdate_class;

Interface

Uses {$IFDEF STATIC_LINK} hdate {$ELSE} hdate_dyn_pascal {$ENDIF}, SysUtils;

Type

  { THdateClass }
  { A class that handle libhdate in the spirit of Object Pascal }
  THdateClass = Class
  Private
    fh           : Phdate_struct;
    FToDestroy   : Boolean;
    fJulianDay   : LongInt;
    fDiaspora    : Boolean;
    fHolyday,
    fHolydayType : LongInt;
    fParasha     : LongInt;
    fHebrewDay,
    fHebrewYear  : String;

    Procedure InitValue;

    Procedure SetHebDay    (Value : LongInt);
    Procedure SetGregDay   (Value : LongInt);
    Procedure SetJulianDay (Value : LongInt);
    Procedure SetHebMonth  (Value : LongInt);
    Procedure SetGregMonth (Value : LongInt);
    Procedure SetGregYear  (Value : LongInt);
    Procedure SetHebYear   (Value : LongInt);
    Procedure SetDiaspora  (Value : Boolean);
    Procedure SetHolydayValues;

    Function GetGregDay   : LongInt;
    Function GetGregMonth : LongInt;
    Function GetGregYear  : LongInt;
    Function GetHebDay    : LongInt;
    Function GetHebMonth  : LongInt;
    Function GetHebYear   : LongInt;
  Public
    constructor Create;                             virtual; overload;
    constructor Create  (hDateRec : Phdate_struct); virtual; overload;
    destructor Destroy;                             override;

    { Assign an existed class of THdateClass propetires into the corrent class }
    Procedure Assign    (Source : THdateClass);     virtual;

    { Returns a string with formated date according with readable date of s }
    Function get_format_date              (s : LongInt)                                 : String;
    { Returns the name of day in a week }
    Function get_day_of_week_string       (s : LongInt)                                 : String;
    { Returns the name of the month }
    Function get_month_string             (s : LongInt)                                 : String;
    { Returns a name of the Hebrew month }
    Function get_hebrew_month_string      (s : LongInt)                                 : String;
    { Returnss the name of a Hebrew holyday }
    Function get_holyday_string           (s : LongInt)                                 : String;
    { Returns the week of the Paragrph that needed to read "Parashat Hashavua" }
    Function get_parasha_string           (s : LongInt)                                 : String;
    { Returns the day of the week }
    Function GetDayOfWeek                                                               : LongInt;
    { Returns the size of the Hebrew year }
    Function get_size_of_year                                                           : LongInt;
    { Returns the day remains until a new Hebrew year starts }
    Function get_new_year_day_of_the_week                                               : LongInt;
    { Returns the number of days passed since the begining of the Hebrew year }
    Function get_days                                                                   : LongInt;
    { Returns the number of weeks passed since the begining of the Hebrew year }
    Function get_weeks                                                                  : LongInt;
    { Returns the sunrise in a given Latitude, Longitude and a timezone }
    Function get_sunrise                   (latitude, longitude : Double; tz : LongInt) : LongInt;
    { Returns the sunet in a given Latitude, Longitude and a timezone }
    Function get_sunset                    (latitude, longitude : Double; tz : LongInt) : LongInt;
    { Returns the sunrise in a given day, Latitude, Longitude and a Degree }
    function get_deg_sunrise               (Date : TDateTime;
                                            latitude, longitude, deg : Double)          : Longint;
    { Returns the sunet in a given day, Latitude, Longitude and a Degree }
    function get_deg_sunset                (Date : TDateTime;
                                            latitude, longitude, deg : Double)          : Longint;
    { Returns the Sha'a zmanit (temporary time) at a given date, Latitude and Longitude }
    function get_temporary_time            (Date : TDateTime;
                                            latitude, longitude : Double)               : Longint;
    { Returns the minutes of first light at a given date, Latitude and Longitude }
    function get_first_light               (Date : TDateTime;
                                            latitude, longitude : Double)               : Longint;
    { Returns the minutes to give a prayer (placing Tfiling and Talit) at a given date, Latitude and Longitude }
    function get_prayer_time               (Date : TDateTime;
                                            latitude, longitude : Double)               : Longint;
    { Returns the minutes of a sunrise at a given date, Latitude and Longitude }
    function get_time_full_sunrise         (Date : TDateTime;
                                            latitude, longitude : Double)               : Longint;
    { Returns the minutes of the midday at a given date, Latitude and Longitude }
    function get_time_full_midday          (Date : TDateTime;
                                            latitude, longitude : Double)               : Longint;
    { Returns the minutes of a sunet at a given date, Latitude and Longitude }
    function get_time_full_sunset          (Date : TDateTime;
                                            latitude, longitude : Double)               : Longint;
    { Returns the minutes to when the first star is showen at a given date, Latitude and Longitude }
    function get_time_full_first_stars     (Date : TDateTime;
                                            latitude, longitude : Double)               : Longint;
    { Returns the minutes to when three stars are showen at a given date, Latitude and Longitude }
    function get_time_full_three_stars     (Date : TDateTime;
                                            latitude, longitude : Double)               : Longint;

    { Get The number of days passed since the beginig of the Hebrew year }
    property Days             : LongInt  read get_days;
    { Get The day of the week }
    property DayOfWeek        : LongInt  read GetDayOfWeek;
    { Get The Hebrew day }
    property HebrewDay        : String   read fHebrewDay;
    { Get The Hebrew year }
    property HebrewYear       : String   read fHebrewYear;
    { Get The Hebrew Holyday }
    property Holyday          : LongInt  read fHolyday;
    { Get The type of the Hebrew Holyday }
    property HolydayType      : LongInt  read fHolydayType;
    { Get The number of days to the next year }
    property NewYearDayOfWeek : LongInt  read get_new_year_day_of_the_week;
    { Get The week parahraph that needed to be read (Parashat Ha'Shavua) }
    property Parasha          : LongInt  read fParasha;
    { Get The number of weeks that passed since the end of the year }
    property Weeks            : LongInt  read get_weeks;
    { Get The size of the the year }
    property YearSize         : Longint  read get_size_of_year;
  Published
    { Get/Set The Hebrew day }
    property HebDay           : LongInt  read GetHebDay     write SetHebDay;
    { Get/Set The Gregorian day }
    property GregDay          : LongInt  read GetGregDay    write SetGregDay;
    { Get/Set Set wether we are in Israel or not }
    property Diaspora         : Boolean  read fDiaspora     write SetDiaspora    default True;
    { Get/Set The Julian day }
    property JulianDay        : LongInt  read fJulianDay    write SetJulianDay;
    { Get/Set The Hebrew Month }
    property HebMonth         : LongInt  read GetHebMonth   write SetHebMonth;
    { Get/Set The Gregorian month }
    property GregMonth        : LongInt  read GetGregMonth  write SetGregMonth;
    { Get/Set To Destroy the hdate record pointer, or the destruction will be made outside the record }
    property ToDestroy        : Boolean  read FToDestroy    write fToDestroy     default True;
    { Get/Set The gregorian year }
    property GregYear         : LongInt  read GetGregYear   write SetGregYear;
    { Get/Set The Hebrew year }
    property HebYear          : LongInt  read GetHebYear    write SetHebYear;
  End;

Implementation

Procedure THdateClass.InitValue;
Var
  ADay, AMonth, AYear : Word;
Begin
  DecodeDate(SysUtils.Now, AYear, AMonth, ADay);
  hdate_set_gdate (Fh, ADay, AMonth, AYear);
  hdate_set_hdate (fh, hdate_get_hday (fh), hdate_get_hmonth (fh), hdate_get_hyear (fh));

  fHebrewDay  := StrPas (hdate_get_int_string (fh^.hd_day));
  fHebrewYear := StrPas (hdate_get_int_string (fh^.hd_year));

  SetJulianDay (hdate_gdate_to_jd (ADay, AMonth, AYear));
  SetDiaspora  (True);
End;

constructor THdateClass.Create;
Begin
  fh         := Nil;
  fh         := new_hdate();
  fToDestroy := True;
  InitValue;
End;

constructor THdateClass.Create (hDateRec : Phdate_struct);
Begin
  fh         := hDateRec;
  fToDestroy := False;
  InitValue;
End;

destructor THdateClass.Destroy;
Begin
  If fToDestroy Then
    delete_hdate (fh);

  inherited;
End;

Procedure THdateClass.SetHebDay (Value : LongInt);
Begin
  hdate_set_hdate (Fh, Value, GetHebMonth, GetHebYear);
  fHebrewDay := StrPas (hdate_get_int_string (fh^.hd_day));
  SetHolydayValues;
End;

Procedure THdateClass.SetGregDay (Value : LongInt);
Begin
  hdate_set_gdate (fh, Value, GetGregMonth, GetGregYear);
  SetHolydayValues;
End;

Procedure THdateClass.SetJulianDay (Value : LongInt);
Begin
  fJulianDay := Value;
  hdate_set_jd (fh, fJulianDay);
  SetHolydayValues;
End;

Procedure THdateClass.SetHebMonth (Value : LongInt);
Begin
  hdate_set_hdate (Fh, GetHebDay, Value, GetHebYear);
  SetHolydayValues;
End;

Procedure THdateClass.SetGregMonth (Value : LongInt);
Begin
  hdate_set_gdate (fh, GetGregDay, Value, GetGregYear);
  SetHolydayValues;
End;

Procedure THdateClass.SetHebYear (Value : LongInt);
Begin
  hdate_set_hdate (fh, GetHebDay, GetGregMonth, Value);
  fHebrewYear := StrPas (hdate_get_int_string (fh^.hd_year));
  SetHolydayValues;
End;

Procedure THdateClass.SetGregYear (Value : LongInt);
Begin
  hdate_set_gdate (fh, GetGregDay, GetGregMonth, Value);
  SetHolydayValues;
End;

Procedure THdateClass.SetDiaspora  (Value : Boolean);
Begin
  fDiaspora    := Value;
  SetHolydayValues;
End;

Procedure THdateClass.SetHolydayValues;
begin
  fHolyday     := hdate_get_holyday      (fh, Longint(FDiaspora));
  fHolydayType := hdate_get_holyday_type (fHolyday);
  fParasha     := hdate_get_parasha      (fh, Longint(fDiaspora));
end;

Function THdateClass.GetGregDay : LongInt;
Begin
  Result := hdate_get_gday (fh);
End;

Function THdateClass.GetGregMonth : LongInt;
Begin
  Result := hdate_get_gmonth (fh);
End;

Function THdateClass.GetGregYear  : LongInt;
Begin
  Result := hdate_get_gyear (fh);
End;

Function THdateClass.GetHebDay : LongInt;
Begin
  Result := hdate_get_hday (fh);
End;

Function THdateClass.GetHebMonth : LongInt;
Begin
  Result := hdate_get_hmonth (fh);
End;

Function THdateClass.GetHebYear : LongInt;
Begin
  Result := hdate_get_hyear (fh);
End;

Procedure THdateClass.Assign (Source : THdateClass);
Begin
  If (Not Assigned(Source)) Then
    Begin
      raise Exception.Create ('Source is not allocated.');
    End;

  // Should never happned ... but just in case...
  Assert (Assigned(Source), 'Source is not allocated.');

  fToDestroy := Source.ToDestroy;
  HebDay     := Source.HebDay;
  GregDay    := Source.GregDay;
  HebMonth   := Source.HebMonth;
  GregMonth  := Source.GregMonth;
  HebYear    := Source.HebYear;
  GregYear   := Source.GregYear;

  SetJulianDay (Source.JulianDay);
  SetDiaspora  (Source.Diaspora);
End;

Function THdateClass.get_format_date (s : LongInt) : String;
Begin
  Result := StrPas (hdate_get_format_date (fh, Longint(fDiaspora), s));
End;

Function THdateClass.get_day_of_week_string (s : LongInt) : String;
Begin
  Result := StrPas (hdate_get_day_string (fh^.hd_dw, s));
End;

Function THdateClass.get_month_string (s : LongInt) : String;
Begin
  Result := StrPas (hdate_get_month_string (fh^.gd_mon, s));
End;

Function THdateClass.get_hebrew_month_string (s : LongInt) : String;
Begin
  Result := StrPas (hdate_get_hebrew_month_string (fh^.hd_mon, s));
End;

Function THdateClass.get_holyday_string (s : LongInt) : String;
Begin
  Result := StrPas (hdate_get_holyday_string (fHolyday, s));
End;

Function THdateClass.get_parasha_string (s : LongInt) : String;
Begin
  Result := StrPas (hdate_get_parasha_string (fParasha, s));
End;

Function THdateClass.GetDayOfWeek : LongInt;
Begin
  Result := hdate_get_day_of_the_week (fh);
End;

Function THdateClass.get_size_of_year : LongInt;
Begin
  Result := hdate_get_size_of_year (fh);
End;

Function THdateClass.get_new_year_day_of_the_week : LongInt;
Begin
  Result := hdate_get_new_year_day_of_the_week (fh);
End;

Function THdateClass.get_days : LongInt;
Begin
  Result := hdate_get_days (fh);
End;

Function THdateClass.get_weeks : LongInt;
Begin
  Result := hdate_get_weeks (fh);
End;

Function THdateClass.get_sunrise (latitude, longitude : Double; tz : LongInt) : LongInt;
Var
  sunrise,
  sunset   : LongInt;
Begin
  hdate_get_utc_sun_time (fh^.gd_day, fh^.gd_mon, fh^.gd_year, latitude, longitude, @sunrise, @sunset);
  Result := sunrise + tz * 60;
End;

Function THdateClass.get_sunset (latitude, longitude : Double; tz : LongInt) : LongInt;
Var
  sunrise,
  sunset   : LongInt;
Begin
  hdate_get_utc_sun_time (fh^.gd_day, fh^.gd_mon, fh^.gd_year, latitude, longitude, @sunrise, @sunset);
  Result := sunset + tz * 60;
End;

type
  TSun_Time_Deg_Type = (stdtSunrise, stdtSunset);

Function get_sun_time_deg(Date : TDateTime; latitude,longitude,deg : Double; Return_Type :
                          TSun_Time_Deg_Type) : Longint;
var
  Year,
  Month,
  Day      : word;
  sunrise,
  sunset   : Longint;
begin
  DecodeDate (Date, Year, Month, Day);
  hdate_get_utc_sun_time_deg(Day, Month, Year, latitude, longitude, deg, @sunrise, @sunset);
  case Return_Type of
    stdtSunrise : Result := sunrise;
    stdtSunset  : Result := sunset;
  end;
end;

function THdateClass.get_deg_sunrise ( Date : TDateTime; latitude,longitude,deg : Double ) : Longint;
begin
  Result := get_sun_time_deg(Date, latitude, longitude, deg, stdtSunrise);
end;

function THdateClass.get_deg_sunset ( Date : TDateTime; latitude,longitude,deg : Double ) : Longint;
begin
   Result := get_sun_time_deg(Date, latitude, longitude, deg, stdtSunset);
end;

type
  TSun_time_full_type = (stftTemporaryTime, stftFirstLight, stftPrayerTime,
                         stftSunrise, stftMidday, stftSunset, stftFirstStars,
                         stftThreeStars);

Function get_sun_time_full_type(Date : TDateTime; latitude,longitude : Double; Return_Type :
                                TSun_time_full_type) : Longint;
var
  Year,
  Month,
  Day          : word;
  sun_hour,
  first_light,
  talit,
  sunrise,
  midday,
  sunset,
  first_stars,
  three_stars  : Longint;
begin
  DecodeDate (Date, Year, Month, Day);
  hdate_get_utc_sun_time_full(Day, Month, Year, latitude, longitude, @sun_hour, @first_light, @talit,
                              @sunrise, @midday, @sunset, @first_stars, @three_stars);
  case Return_Type of
     stftTemporaryTime : Result := sun_hour;
     stftFirstLight    : Result := first_light;
     stftPrayerTime    : Result := talit;
     stftSunrise       : Result := sunrise;
     stftMidday        : Result := midday;
     stftSunset        : Result := sunset;
     stftFirstStars    : Result := first_stars;
     stftThreeStars    : Result := three_stars;
  end;
end;

function THdateClass.get_temporary_time ( Date : TDateTime; latitude,longitude : Double ) : Longint;
begin
  Result := get_sun_time_full_type(Date, latitude,longitude, stftTemporaryTime);
end;

function THdateClass.get_first_light ( Date : TDateTime; latitude,longitude : Double ) : Longint;
begin
  Result := get_sun_time_full_type(Date, latitude,longitude, stftFirstLight);
end;

function THdateClass.get_prayer_time ( Date : TDateTime; latitude,longitude : Double ) : Longint;
begin
  Result := get_sun_time_full_type(Date, latitude,longitude, stftPrayerTime);
end;

function THdateClass.get_time_full_sunrise ( Date : TDateTime; latitude,longitude : Double ) : Longint;
begin
  Result := get_sun_time_full_type(Date, latitude,longitude, stftSunrise);
end;

function THdateClass.get_time_full_midday ( Date : TDateTime; latitude,longitude : Double ) : Longint;
begin
 Result := get_sun_time_full_type(Date, latitude,longitude, stftMidday);
end;

function THdateClass.get_time_full_sunset ( Date : TDateTime; latitude,longitude : Double ) : Longint;
begin
  Result := get_sun_time_full_type(Date, latitude,longitude, stftSunset);
end;

function THdateClass.get_time_full_first_stars ( Date : TDateTime; latitude,longitude : Double ) : Longint;
begin
  Result := get_sun_time_full_type(Date, latitude,longitude, stftFirstStars);
end;

function THdateClass.get_time_full_three_stars ( Date : TDateTime; latitude,longitude : Double ) : Longint;
begin
  Result := get_sun_time_full_type(Date, latitude,longitude, stftThreeStars);
end;

End.

