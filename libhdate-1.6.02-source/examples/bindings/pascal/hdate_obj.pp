{  libhdate
   Copyright  2004-2005  Yaacov Zamir <kzamir@walla.co.il>
	 Copyright  2005       Ido Kanner <idokan@gmail.com>
   
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
 
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU Library General Public License for more details.
 
   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
	 
History:
  11/10/2005 - Initial Translation of version 0.31.0
}

{$MODE OBJFPC}
unit hdate_obj;

interface
uses cTypes, hDate, SysUtils;

type
	THdate = class
	private
	  h : Phdate_struct;
	public
	  constructor Create;   virtual;
	  destructor  Destroy;  override;
	  ////////////////////////////////////////
		////////////////////////////////////////
		
		(**
		 @brief compute date structure from the Gregorian date
		
		 @param d Day of month 1..31
		 @param m Month 1..12 ,  if m or d is 0 return current date.
		 @param y Year in 4 digits e.g. 2001
		 *)
		procedure set_gdate (d, m, y : cInt);
		
		(**
		 @brief compute date structure from the Hebrew date
		
		 @param d Day of month 1..31
		 @param m Month 1..14 ,  if m or d is 0 return current date.
		 @param y Year in 4 digits e.g. 5731
		 *)
		procedure set_hdate (d, m, y : cInt);
		
		(**
		 @brief compute date structure from the Julian day
		
		 @param jd the julian day number.
		 *)
		 procedure set_jd (jd : cInt);
		
		////////////////////////////////////////
		////////////////////////////////////////
		
		(**
		 @brief get formated hebrew date.
		
		 return the short ( e.g. "1 Tishrey" ) or 
		 long (e.g. "Tuesday 18 Tishrey 5763 Hol hamoed Sukot" ) formated date.
		
		 @param diaspora if true give diaspora holydays.
		 @param s short flag.
		 @return a static string of foramted date
		*)
		function get_format_date (diaspora, s : cInt) : String;
		
		(**
		 @brief get name of week day.
		
		 @param s short flag 
		   true - returns a short string: sun, false returns: sunday.
		 @return a static string of the day of the week
		*)
		function get_day_of_week_string (s : cInt) : String;
		
		(**
		 @brief get name month.
		
		 @param s short flag 
		   true - returns a short string: Mar, false returns: March.
		 @return a static string of month name
		*)
		function get_month_string (s : cInt) : String;
		
		(**
		 @brief get name hebrew month.
		
		 @param s short flag 
		   true - returns a short string.
		 @return a static string of hebrew month name
		*)
		function get_hebrew_month_string (s : cInt) : String;
		
		(**
		 @brief get name hebrew holiday.
		
		 @param s short flag 
		   true - returns a short string.
		 @return a static string of hebrew holiday name
		*)
		function get_holyday_string (diaspora, s : cInt) : String;
		
		(**
		 @brief get the hebrew holiday type.
		
		 @return the holiday type 
			(1- regular holyday, 2- three regels, 3- tzom, 0- no holiday)
		*)
		function get_holyday_type (diaspora : cInt) : cInt;
		
		(**
		 @brief get name hebrew parasha.
		
		 @param diaspora if true give diaspora parashot.
		 @param s short flag 
		   true - returns a short string.
		 @return a static string of hebrew parash name
		*)
		function get_parasha_string (diaspora, s : cInt) : String;
		
		(**
		 @brief get name hebrew year.
		
		 @return a static string of hebrew year
		*)
		function get_hebrew_year_string : String;
		
		(**
		 @brief get name hebrew hebrew day of the month
		
		 @return a static string of hebrew day of the month
		*)
		function get_hebrew_day_string : String;
		
		////////////////////////////////////////
		////////////////////////////////////////
		
		(**
		 @brief get parash number
		
		 @param diaspora if true give diaspora parashot.
		 @return the hebrew parasha number
		*)
		function get_parasha (diaspora : cInt) : cInt;
		
		(**
		 @brief get holiday number
		
		 @param diaspora if true give diaspora holidays.
		 @return the hebrew holiday number
		*)
		function get_holyday (diaspora : cInt) : cInt;
		
		(**
		 @brief get Gregorian day of the month
		
		 @return the Gregorian day of the month
		*)
		function get_gday : cInt;
		
		(**
		 @brief get Gregorian month
		
		 @return the Gregorian month
		*)
		function get_gmonth : cInt;
		
		(**
		 @brief get Gregorian year
		
		 @return the Gregorian year
		*)
		function get_gyear : cInt;
		
		(**
		 @brief get Hebrew day of the month
		
		 @return the Hebrew day of the month
		*)
		function get_hday : cInt;
		
		(**
		 @brief get Hebrew month
		
		 @return the Hebrew month
		*)
		function get_hmonth : cInt;
		
		(**
		 @brief get Hebrew year
		
		 @return the Hebrew year
		*)
		function get_hyear : cInt;
		
		(**
		 @brief get the day of the week
		
		 @return the day of the week
		*)
		function get_day_of_the_week : cInt;
		
		(**
		 @brief get the size of the Hebrew year in days
		
		 @return the size of the Hebrew year in days
		*)
		function get_size_of_year : cInt;
		
		(**
		 @brief get the day of the week of hebrew new years
		
		 @return the day of the week of hebrew new years
		*)
		function get_new_year_day_of_the_week : cInt;
		
		(**
		 @brief get the Julian day number
		
		 @return the Julian day number
		*)
		function get_julian : cInt;
		
		(**
		 @brief get the number of days sice Tishrey I
		
		 @return the the number of days sice Tishrey I
		*)
		function get_days : cInt;
		
		(**
		 @brief get the number of weeks sice Tishrey I
		
		 @return the the number of weeks sice Tishrey I
		*)
		function get_weeks : cInt;
		
		////////////////////////////////////////
		////////////////////////////////////////
		
		(**
		 @brief sunrise time
		
		 @param longitude longitude to use in calculations
			degrees, negative values are east
		 @param latitude latitude to use in calculations
			degrees, negative values are south
		 @param tz time zone
		 @return sunrise in minutes after midnight (00:00)
		 *)
		 function get_sunrise (latitude, longitude : cDouble; tz : cInt) : cInt;
		
		(**
		 @brief sunset time
		
		 @param longitude longitude to use in calculations
			degrees, negative values are east
		 @param latitude latitude to use in calculations
			degrees, negative values are south
		 @param tz time zone
		 @return sunset in minutes after midnight (00:00)
		 *)
		 function get_sunset (latitude, longitude : cDouble; tz : cInt) : cInt;
	end;

implementation

constructor THdate.Create;
begin
	h := new_hdate;
end;

destructor THdate.Destroy;
begin
	delete_hdate(h);
  inherited Destroy;
end;

procedure THdate.set_gdate (d, m, y : cInt);
begin
	hdate_set_gdate (h, d, m, y);
end;

procedure THdate.set_hdate (d, m, y : cInt);
begin
  hdate_set_hdate (h, d, m, y);
end;

procedure THdate.set_jd (jd : cInt);
begin
	hdate_set_jd (h, jd);
end;

function THdate.get_format_date (diaspora, s : cInt) : String;
begin
	Result := StrPas (hdate_get_format_date (h, diaspora, s));
end;

function THdate.get_day_of_week_string (s : cInt) : String;
begin
	Result := StrPas (hdate_get_day_string (h^.hd_dw, s));
end;

function THdate.get_month_string (s : cInt) : String;
begin
	Result := StrPas (hdate_get_month_string (h^.gd_mon, s));
end;

function THdate.get_hebrew_month_string (s : cInt) : String;
begin
	Result := StrPas (hdate_get_hebrew_month_string (h^.hd_mon, s));
end;

function THdate.get_holyday_string (diaspora, s : cInt) : String;
var
  holyday : cInt;
begin
	holyday := hdate_get_holyday (h, diaspora);
  Result  := StrPas (hdate_get_holyday_string (holyday, s));
end;

function THdate.get_holyday_type (diaspora : cInt) : cInt;
var
 holyday : cInt;
begin
	holyday := hdate_get_holyday (h, diaspora);
	Result  := hdate_get_holyday_type (holyday);
end;

function THdate.get_parasha_string (diaspora, s : cInt) : String;
var
 parasha : cInt;
begin
	parasha := hdate_get_parasha (h, diaspora);
	Result  := StrPas (hdate_get_parasha_string (parasha, s));
end;

function THdate.get_hebrew_year_string : String;
begin
	Result := StrPas (hdate_get_int_string (h^.hd_year));
end;

function THdate.get_hebrew_day_string : String;
begin
	Result := StrPas (hdate_get_int_string (h^.hd_day));
end;

function THdate.get_parasha (diaspora : cInt) : cInt;
begin
	Result := hdate_get_parasha (h, diaspora);
end;

function THdate.get_holyday (diaspora : cInt) : cInt;
begin
	Result := hdate_get_holyday (h, diaspora);
end;

function THdate.get_gday : cInt;
begin
	Result := hdate_get_gday (h);
end;

function THdate.get_gmonth : cInt;
begin
	Result := hdate_get_gmonth (h);
end;

function THdate.get_gyear : cInt;
begin
	Result := hdate_get_gyear (h);
end;

function THdate.get_hday : cInt;
begin
	Result := hdate_get_hday (h);
end;

function THdate.get_hmonth : cInt;
begin
	Result := hdate_get_hmonth (h);
end;

function THdate.get_hyear : cInt;
begin
	Result :=hdate_get_hyear (h);
end;

function THdate.get_day_of_the_week : cInt;
begin
	Result := hdate_get_day_of_the_week (h);
end;

function THdate.get_size_of_year : cInt;
begin
	Result := hdate_get_size_of_year (h);
end;

function THdate.get_new_year_day_of_the_week : cInt;
begin
	Result := hdate_get_new_year_day_of_the_week (h);
end;

function THdate.get_julian : cInt;
begin
	Result := hdate_get_julian (h);
end;

function THdate.get_days : cInt;
begin
	Result := hdate_get_days (h);
end;

function THdate.get_weeks : cInt;
begin
	Result := hdate_get_weeks (h);
end;

function THdate.get_sunrise (latitude, longitude : cDouble; tz : cInt) : cInt;
var
 sunrise,
 sunset   : cInt;
begin
	hdate_get_utc_sun_time (h^.gd_day, h^.gd_mon, h^.gd_year, latitude, longitude, @sunrise, @sunset);
	
	Result := sunrise + tz * 60;
end;

function THdate.get_sunset (latitude, longitude : cDouble; tz : cInt) : cInt;
var
 sunrise,
 sunset   : cInt;
begin
	hdate_get_utc_sun_time (h^.gd_day, h^.gd_mon, h^.gd_year, latitude, longitude, @sunrise, @sunset);
	
	Result := sunset + tz * 60;
end;

end.
