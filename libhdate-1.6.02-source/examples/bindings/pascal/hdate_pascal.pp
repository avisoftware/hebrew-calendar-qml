(* hdate_pascal.pp
   example file for libhdate.

   compile: fpc hdate_pascal.pp
    
   Copyright (C) 2005-2008  Ido Kaner

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
*)

{$MODE OBJFPC} {$H+}
{$IFDEF MSWINDOWS}
  {$APPTYPE CONSOLE} //Make sure that in Windows we will be in a console mode
{$ENDIF}
program hdate_demo;
uses hdate_class, SysUtils, DateUtils;

type
  { A record to store city information regarding the Latitude, Longitude and it's name }
  TCityDetauls = record
                  { The latitude of a given city}
                  Latitude  : Double;
                  { The longitude of a given city}
                  Longitude : Double;
                  { The name of a city}
                  Name      : ShortString;
                 end;

// Latitude and Longitude where Taken from from http://wwp.greenwichmeantime.com/time-zone/asia/israel/cities.htm
const
  { The cities in Israel that we have information regarding the Latitude and Longitude }
  Cities : array[0..19] of TCityDetauls =
    (
{ 00 }  ( Latitude : 31.78;  Longitude : 35.22;  Name : 'Jerusalem'     ),
{ 01 }  ( Latitude : 32.07;  Longitude : 34.77;  Name : 'Tel Aviv-Jafa' ),
{ 02 }  ( Latitude : 32.82;  Longitude : 34.99;  Name : 'Hifa'          ),
{ 03 }  ( Latitude : 31.96;  Longitude : 34.80;  Name : 'Rishon Lezion' ),
{ 04 }  ( Latitude : 31.80;  Longitude : 34.64;  Name : 'Ashdod'        ),
{ 05 }  ( Latitude : 31.25;  Longitude : 34.80;  Name : 'Be''er Sheva'  ),
{ 06 }  ( Latitude : 32.09;  Longitude : 34.88;  Name : 'Petach Tiqva'  ),
{ 07 }  ( Latitude : 32.33;  Longitude : 34.86;  Name : 'Netanya'       ),
{ 08 }  ( Latitude : 32.02;  Longitude : 34.76;  Name : 'Holon'         ),
{ 09 }  ( Latitude : 32.09;  Longitude : 34.85;  Name : 'B''ene Beraq'  ),
{ 10 }  ( Latitude : 32.02;  Longitude : 34.75;  Name : 'Bat Yam'       ),
{ 11 }  ( Latitude : 32.08;  Longitude : 34.80;  Name : 'Ramat Gan'     ),
{ 12 }  ( Latitude : 31.67;  Longitude : 34.56;  Name : 'Ashqelon'      ),
{ 13 }  ( Latitude : 31.89;  Longitude : 34.80;  Name : 'Rehovot'       ),
{ 14 }  ( Latitude : 32.17;  Longitude : 34.84;  Name : 'Herzeliyya'    ),
{ 15 }  ( Latitude : 32.19;  Longitude : 34.91;  Name : 'Kfar Saba'     ),
{ 16 }  ( Latitude : 32.45;  Longitude : 34.92;  Name : 'Hadera'        ),
{ 17 }  ( Latitude : 32.19;  Longitude : 34.88;  Name : 'Ra''anana'     ),
{ 18 }  ( Latitude : 31.96;  Longitude : 34.90;  Name : 'Lod'           ),
{ 19 }  ( Latitude : 31.93;  Longitude : 34.86;  Name : 'Ramla'         )
    );

{ Convert the given minutes into full TTime and retrun it as a string
  Params:
  minute - The number of minutes since the start of the day}
function MinutesToHours(minute : Longint) : String;
begin
  MinutesToHours := TimeToStr(OneMinute * minute);
end;

var
{ Our hdate class }
 h           : THdateClass;
{ A variable that saves the flag for Israel or the rest of the world }
 diaspora    : Integer;
{ Israel's time zone in hours, used to adjust utc times (GMT) to locale time }
 time_zone   : Integer;
{ Temporary Storing of the minutes for specific query }
 tmp         : Longint;
{ The degree of the sunrise/sunset that we are looking at, default is 90 }
 deg         : Longint;
{ The Longitude of a city }
 Long        : Double;
{ The Latitude of a city }
 Lat         : Double;
{ The name of a city }
 LongLatName : String;
{ The for loop counter }
 i           : integer;
 
begin
 h        := THdateClass.Create;
 diaspora := 0;
 time_zone := 2;

 try
  // print gregorian date
  writeln (Format('Today: %0.2d/%0.2d/%4d',[h.GregDay,h.GregMonth,h.GregYear]));
 
  // print hebrew date
  writeln (h.get_format_date (diaspora));
  writeln;

  writeln('Corrent Time: ', TimeToStr(Now));
  writeln;

  for i := Low(Cities) to High(Cities) do
    begin
     Long        := Cities[i].Longitude;
     Lat         := Cities[i].Latitude;
     LongLatName := Cities[i].Name;
     
     Writeln('City: ', LongLatName);
     Writeln(#9'Latitude: ', FloatToStr(Lat));
     Writeln(#9'Longitude: ', FloatToStr(Long));
  
     // print Time using a degree of sunrise/sunset
     deg := 90;
     writeln(#9'Degree: ', deg);
     tmp := h.get_deg_sunrise(Now, Lat, Long, deg);
     writeln (#9'hour of sunrise: ', MinutesToHours(tmp + time_zone * 60));
     tmp := h.get_deg_sunset(Now, Lat, Long, deg);
     writeln(#9'hour of sunset: ', MinutesToHours(tmp + time_zone * 60));
  
     //print information
     tmp := h.get_temporary_time(Now, Lat, Long);
     writeln(#9'Temporary hour length: ', MinutesToHours(tmp));
     tmp := h.get_first_light(Now, Lat, Long);
     writeln(#9'first light: ', MinutesToHours(tmp + time_zone * 60));
     tmp := h.get_prayer_time(Now, Lat, Long);
     writeln(#9'talit time: ', MinutesToHours(tmp + time_zone * 60));
     tmp := h.get_time_full_sunrise(Now, Lat, Long);
     writeln(#9'full sunrise: ', MinutesToHours(tmp + time_zone * 60));
     tmp := h.get_time_full_midday(Now, Lat, Long);
     writeln(#9'full midday: ', MinutesToHours(tmp + time_zone * 60));
     tmp := h.get_time_full_sunset(Now, Lat, Long);
     writeln(#9'full sunset: ', MinutesToHours(tmp + time_zone * 60));
     tmp := h.get_time_full_first_stars(Now, Lat, Long);
     writeln(#9'first stars: ', MinutesToHours(tmp + time_zone * 60));
     tmp := h.get_time_full_three_stars(Now, Lat, Long);
     writeln(#9'three stars: ', MinutesToHours(tmp + time_zone * 60));
     writeln;
    end;
 finally
  h.Free;
 end;
end.
