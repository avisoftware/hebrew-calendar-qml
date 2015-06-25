/* local_functions.c            http://libhdate.sourceforge.net
 * a collection of functions in support of both hcal.c and hdate.c
 * hcal.c  Hebrew calendar              (part of package libhdate)
 * hdate.c Hebrew date/times information(part of package libhdate)
 *
 * compile:
 * gcc `pkg-config --libs --cflags libhdate` ocal_functions.c -o local_functions
 *
 * Copyright:  2011-2012 (c) Boruch Baum
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/**************************************************
*   functions to support hcal and hdate
**************************************************/
#define _GNU_SOURCE		// For mempcpy, asprintf

#include <hdate.h>		// For hebrew date
//include "../../src/hdate.h"
#include <stdlib.h>		// For atoi, malloc
#include <error.h>		// For error
#include <errno.h>		// For errno
#include <time.h>		// For time
#include <ctype.h>		// for isprint
#include <fnmatch.h>	// For fnmatch
#include <string.h>		// For mempcpy
#include <getopt.h>		// For optarg, optind
#include <stdio.h>		// For printf, fopen, fclose, fprintf, snprintf. FILE
#include <pwd.h>		// for get pwuid
#include <unistd.h>		// for getuid
#include <sys/stat.h>
#include <sys/types.h>	// for mkdir,


// support for fnmatch
#define FNM_EXTMATCH	(1 << 5)
#define FNM_NOFLAG		0

#define BAD_COORDINATE	999
#define BAD_TIMEZONE	999
#define DELTA_LONGITUDE 30

#define EXIT_CODE_BAD_PARMS	1



// copied from support.h in src dir
#ifdef ENABLE_NLS
#  include <libintl.h>
#  undef _
#  define _(String) dgettext (PACKAGE, String)
#  ifdef gettext_noop
#    define N_(String) gettext_noop (String)
#  else
#    define N_(String) (String)
#  endif
#else
#  define textdomain(String) (String)
#  define gettext(String) (String)
#  define dgettext(Domain,Message) (Message)
#  define dcgettext(Domain,Message,Type) (Message)
#  define bindtextdomain(Domain,Directory) (Domain)
#  define _(String) (String)
#  define N_(String) (String)
#endif

#define FALSE 0
#define TRUE -1


// support for options parsing
#define MIN_CANDLES_MINUTES 18
#define DEFAULT_CANDLES_MINUTES 20
#define MAX_CANDLES_MINUTES 90
#define MIN_MOTZASH_MINUTES 20
#define MAX_MOTZASH_MINUTES 90


/************************************************************
* begin - error message functions
************************************************************/
void print_parm_error ( char *parm_name )
{
	error(0,0,"%s: %s %s %s",N_("error"),
			N_("parameter"), parm_name,
			N_("is non-numeric or out of bounds"));
}

void print_parm_missing_error ( char *parm_name )
{
	error(0,0,"%s: %s %s %s",N_("error"),
			N_("option"), parm_name, N_("missing parameter"));
}

void print_alert_timezone( int tz )
{
	error(0,0,"%s: %s, %+d:%d UTC",
			N_("ALERT: time zone not entered, using system local time zone"),
			*tzname, tz/60, tz%60);
}

void print_parm_invalid_error( char *parm_name )
{
	error(0,0,"%s: %s %s %s",N_("error"),
			N_("option"), parm_name, N_("is not a valid option"));
}


/************************************************************
* end - error message functions
************************************************************/




/************************************************************
* begin - alert message functions
************************************************************/
void print_alert_coordinate( char *city_name )
{
	error(0,0,"%s %s",
			N_("ALERT: guessing... will use co-ordinates for"),
			city_name);
}

void print_alert_default_location( int tz )
{
	switch (tz/60)
	{
	case -8:	print_alert_coordinate( N_("Los Angeles") ); break;
	case -6:	print_alert_coordinate( N_("Mexico City") ); break;
	case -5:	print_alert_coordinate( N_("New York City") ); break;
//	case -5:	print_alert_coordinate( N_("Toronto") ); break;
//	case -3:	print_alert_coordinate( N_("Sao Paolo") ); break;
	case -3:	print_alert_coordinate( N_("Buenos Aires") ); break;
	case  0:	print_alert_coordinate( N_("London") ); break;
	case  1:	print_alert_coordinate( N_("Paris") ); break;
	case  2:	print_alert_coordinate( N_("Tel-Aviv") ); break;
	case  3:	print_alert_coordinate( N_("Moscow") ); break;
	case  5:	print_alert_coordinate( N_("Tashkent") ); break;
	case  8:	print_alert_coordinate( N_("Beijing") ); break;
//	case  8:	print_alert_coordinate( N_("Hong Kong") ); break;
	case -10:	print_alert_coordinate( N_("Honolulu") ); break;
	default:	error(0,0,"%s \n%s", N_("Hmmm, ... hate to do this, really ..."), N_("using co-ordinates for the equator, at the center of time zone")); break;
	}
}
/************************************************************
* end - alert message functions
************************************************************/



/************************************************************
* set default location
************************************************************/
void set_default_location( int tz, double *lat, double *lon )
{
	/*	Temporarily, set some default lat/lon coordinates
		for certain timezones */

/**
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
**/

	switch (tz/60)
	{
	case -8:	*lat =  34.05;	*lon =-118.25;	break; // Los Angeles
	case -6:	*lat =  19.43;	*lon = -99.13;	break; // Mexico City
	case -5:	*lat =  40.0;	*lon = -74.0;	break; // New York
//	case -5:	*lat =  43.71;	*lon = -79.43;	break; // Toronto
//	case -3:	*lat = -23.55;	*lon = -46.61;	break; // Sao Paolo
	case -3:	*lat = -34.6;	*lon = -58.37;	break; // Buenos Aires
	case  0:	*lat =  51.0;	*lon =   0.0;	break; // London
	case  1:	*lat =  48.0;	*lon =   2.0;	break; // Paris
	case  2:	*lat =  32.0;	*lon =  34.0;	break; // Tel aviv
	case  3:	*lat =  55.0;	*lon =  37.0;	break; // Moscow
	case  5:	*lat =  41.27;	*lon =  69.22;	break; // Tashkent
	case  8:	*lat =  39.90;	*lon = 116.38;	break; // Beijing
//	case  8:	*lat =  22.26;	*lon = 114.15;	break; // Hong Kong
	case 10:	*lat =  21.30;	*lon = 157.82;	break; // Honolulu
	default:	*lat =   0.0;	*lon =  tz * .25; break; // center of timeone:
														 // .25 = (15 degrees) / 60 [because tz is in minutes, not hours]
	}
	return;
}



/************************************************************
* check for sunset
************************************************************/
int check_for_sunset (hdate_struct * h, double lat, double lon, int timezone )
{
	time_t now_time;
	struct tm *now_timep;
	int sunrise, sunset;

	hdate_get_utc_sun_time (h->gd_day, h->gd_mon, h->gd_year, lat, lon,
							&sunrise, &sunset);

	time(&now_time);
	now_timep = localtime(&now_time);

	if ( ((now_timep->tm_hour) *60 + now_timep->tm_min) > (sunset + timezone) ) return 1;
	else return 0;
}




/***********************************************************
 *  reverse a hebrew string (for visual bidi)
 *  parameters:
 *    source is a pointer to a writeable buffer.
 *    source_len is the length of a string in source. This 
 *    length must be LESS than the size of the source buffer
***********************************************************/
void revstr( char *source, const size_t source_len)
{
	#define H_CHAR_WIDTH 2

#define DEBUG 0
#if DEBUG
printf("\nrevstr: entry: sourcelen = %ld, source = %s\n",source_len, source);
#endif

	if (source == NULL) {error(0,0,"revstr: source buffer pointer is NULL"); exit(0);};
	if (source_len <= 0) {error(0,0,"revstr: source_len parameter invalid, %ld",source_len); exit(0);};

	size_t i,j;
	char *temp_buff;

	temp_buff = malloc(source_len+2);
	if (temp_buff == NULL) {error(0,0,"revstr: malloc failure"); exit(0);};

	for (i=(source_len-1), j=0; j < source_len; i--, j++)
	{
		if (isprint(source[i])) temp_buff[j] = source[i];
		else
		{
			// FIXME - presumes H_CHAR_WIDTH = 2
			temp_buff[j++] = source[i-1];
			temp_buff[j]   = source[i--];
		}
	}
	memcpy(source, temp_buff, source_len);
	source[source_len] = '\0';
#if DEBUG
printf("\nrevstr: before free(tempbuff): sourcelen = %ld, source = %s\n",source_len, source);
#endif
	free(temp_buff);
	return;
}


/************************************************************
* parse coordinate
* 
* presumes commandline options were parsed using getopt.
* returns 1 to *opt_found on success
* returns the floating point value of the coordinate in *coordinate
* 
* type_flag (1-latitude, 2=longitude)
************************************************************/
int parse_coordinate( const int type_flag, char *input_string,
						double *coordinate, int *opt_found)
{
//#define NEGATIVE_NUMBER_GLOB	"-[[:digit:]]?([[:digit:]]?([[:digit:]]))?(.+([[:digit:]]))"
//#define NEGATIVE_DMS_GLOB		"-[[:digit:]]?([[:digit:]]?([[:digit:]]))?([:\"]?([012345])[[:digit:]]?([:'\"]?([012345])[[:digit:]]))"
//#define COORDINATE_GLOB_DECIMAL	"?([+-])[[:digit:]]?([[:digit:]]?([[:digit:]]))?(.+([[:digit:]]))"
//#define COORDINATE_GLOB_DMS		"?([+-])[[:digit:]]?([[:digit:]]?([[:digit:]]))?([':\"]?([012345])[[:digit:]]?([:'\"]?([012345])[[:digit:]]))"

#define LATITUDE_GLOB_DECIMAL	"?([nNsS+-])[[:digit:]]?([[:digit:]]?([[:digit:]]))?(.+([[:digit:]]))?([nNsS])"
#define LONGITUDE_GLOB_DECIMAL	"?([eEwW+-])[[:digit:]]?([[:digit:]]?([[:digit:]]))?(.+([[:digit:]]))?([eEwW])"

#define LATITUDE_GLOB_DMS		"?([nNsS+-])[[:digit:]]?([[:digit:]]?([[:digit:]]))?([':\"]?([012345])[[:digit:]]?([:'\"]?([012345])[[:digit:]]))?([nNsS])"
#define LONGITUDE_GLOB_DMS		"?([eEwW+-])[[:digit:]]?([[:digit:]]?([[:digit:]]))?([':\"]?([012345])[[:digit:]]?([:'\"]?([012345])[[:digit:]]))?([eEwW])"

	char* seconds;

	double fractional_part = 0;
	int direction_modifier = 1;

	/************************************************************
	* input_string should hold the value to parse
	* It must exist and be numeric
	* we don't want confuse it with the next option of for "-x"
	************************************************************/
	if	(!input_string)
	{
		if		(type_flag == 1) print_parm_missing_error(N_("l (latitude)"));
		else if (type_flag == 2) print_parm_missing_error(N_("L (Longitue)"));
		return TRUE; // error_detected = TRUE; ie failure
	}

	/************************************************************
	* parse latitude
	************************************************************/
	if	(type_flag == 1)
	{
		if(	(fnmatch( LATITUDE_GLOB_DECIMAL, input_string, FNM_EXTMATCH)!=0)
		&&	(fnmatch( LATITUDE_GLOB_DMS, input_string, FNM_EXTMATCH) !=0) )
		{
			if (fnmatch("-*", input_string, FNM_NOFLAG)==0)
				 print_parm_missing_error(N_("l (latitude)"));
			else print_parm_error(N_("l (latitude)"));
			return TRUE; // error_detected = TRUE; ie failure
		}


		if ( strpbrk(input_string, "sS") != NULL ) direction_modifier = -1;


		if (fnmatch(LATITUDE_GLOB_DECIMAL, input_string, FNM_EXTMATCH)==0)
		{
			*coordinate = (double) atof( strtok( input_string, "nNsS"));
		}
		else if (fnmatch(LATITUDE_GLOB_DMS, input_string, FNM_EXTMATCH)==0)
		{
			*coordinate = (double) atof( strtok( input_string, "nNsS:'\""));
			fractional_part = (double) atof( strtok( NULL, "nNsS:'\""))/60;
			seconds = strtok( NULL, "nNsS:'\"");
			if (seconds != NULL) fractional_part = fractional_part + (double) atof( seconds)/3600;
		}


		if (*coordinate > 0)
			*coordinate = (*coordinate + fractional_part) * direction_modifier;
		else
			*coordinate = *coordinate - fractional_part;


		if(	(*coordinate > -90) && (*coordinate < 90) )
		{
			*opt_found = 1;
			return FALSE; // error_detected = FALSE; ie. success
		}
		print_parm_error(N_("L (Longitude)"));
		return TRUE; // error_detected = TRUE; ie failure
	}


	/************************************************************
	* parse longitude
	************************************************************/
	if	(type_flag == 2)
	{
		if(	(fnmatch( LONGITUDE_GLOB_DECIMAL, input_string, FNM_EXTMATCH)!=0)
		&&	(fnmatch( LONGITUDE_GLOB_DMS, input_string, FNM_EXTMATCH) !=0) )
		{
			if (fnmatch("-*", input_string, FNM_NOFLAG)==0)
				 print_parm_missing_error(N_("L (Longitude)"));
			else print_parm_error(N_("L (Longitude)"));
			return TRUE; // error_detected = TRUE; ie failure
		}


		if ( strpbrk(input_string, "wW") != NULL ) direction_modifier = -1;


		if (fnmatch(LONGITUDE_GLOB_DECIMAL, input_string, FNM_EXTMATCH)==0)
		{
			*coordinate = (double) atof( strtok( input_string, "eEwW"));
		}
		else if (fnmatch(LONGITUDE_GLOB_DMS, input_string, FNM_EXTMATCH)==0)
		{
			*coordinate = (double) atof( strtok( input_string, "eEwW:'\""));
			fractional_part = (double) atof( strtok( NULL, "eEwW:'\""))/60;
			seconds = strtok( NULL, "eEwW:'\"");
			if (seconds != NULL) fractional_part = fractional_part + (double) atof( seconds)/3600;
		}

		if (*coordinate > 0)
			*coordinate = (*coordinate + fractional_part) * direction_modifier;
		else
			*coordinate = *coordinate - fractional_part;


		if(	(*coordinate > -180) && (*coordinate < 180) )
		{
			*opt_found = 1;
			return FALSE; // error_detected = FALSE; ie. success
		}
		print_parm_error(N_("L (Longitude)"));
		return TRUE; // error_detected = TRUE; ie failure
	}

printf("INTERNAL ERROR: coordinate parse\n");
return TRUE; // error_detected = TRUE; ie failure
}

/************************************************************
* parse timezone
* 
* presumes commandline options were parsed using getopt.
* timezone is returned in minutes, not hours
************************************************************/
int parse_timezone( char *input_string, int *tz)
{
#define TIMEZONE_GLOB_DECIMAL	"?([+-])?(1)[[:digit:]]?(.+([[:digit:]]))"
#define TIMEZONE_GLOB_DM		"?([+-])?(1)[[:digit:]]?([:'\"]+([[:digit:]]))"

	int fractional_part;

	/************************************************************
	* input_string should hold the value to parse
	* It must exist and be numeric
	* we don't want confuse it with the next option of for "-x"
	************************************************************/
	if	((!input_string) ||
		 (	(fnmatch("-*",input_string,FNM_NOFLAG)==0) &&
			(fnmatch(TIMEZONE_GLOB_DECIMAL, input_string, FNM_EXTMATCH)!=0) &&
			(fnmatch(TIMEZONE_GLOB_DM, input_string, FNM_EXTMATCH)!=0) ) )
	{
		print_parm_missing_error(N_("z (time zone)"));
	}
	else
	{
		if (fnmatch(TIMEZONE_GLOB_DECIMAL, input_string, FNM_EXTMATCH)==0)
		{
			*tz = (int) ( atof (input_string) * 60 );
		}
		else if (fnmatch(TIMEZONE_GLOB_DM, input_string, FNM_EXTMATCH)==0)
		{
				*tz = atoi( strtok( input_string, ":'\"")) * 60;
				fractional_part = atoi( strtok( NULL, ":'\""));
				if (*tz < 0)	*tz = *tz - fractional_part;
				else			*tz = *tz + fractional_part;
		}

		if( (*tz > -720) && (*tz < 720) ) // 720 minutes in 12 hours
		{
			return FALSE; // error_detected = FALSE; ie. success
		}
		else print_parm_error(N_("z (timezone)"));
	}
	return TRUE; // error_detected = TRUE; ie failure
}




/************************************************************
* validate location parameters - lat, lon, tz
************************************************************/
// originally, this was only for hdate, now also for hcal
// originally, we did this only if we needed the information
// now, because of sunset-awareness, we always perform these checks
// if ( (opt.sun) || (opt.times) || (opt.candles) || (opt.havdalah) )
void validate_location( const int opt_latitude, const int opt_Longitude,
						double *lat, double *lon,
						int *tz, const int quiet_alerts, int error_detected,
						void (*print_usage)() )
{

	/* latitude and longitude must be paired */
	if ( (opt_latitude) && (!opt_Longitude) )
	{
		error(0,0,"%s: %s", N_("error"), N_("valid longitude parameter missing for given latitude"));
		error_detected = TRUE;
	}
	else if ( (opt_Longitude) && (!opt_latitude) )
	{
		error(0,0,"%s: %s", N_("error"), N_("valid latitude parameter missing for given longitude"));
		error_detected = TRUE;
	}


	if (!error_detected)
	{
		// if no timezone entered, choose guess method
		if (*tz==BAD_TIMEZONE)
		{
			// system timezone is in seconds, but we deal in minutes
			tzset();
			*tz = timezone /-60;

			if ( (opt_latitude) && (opt_Longitude) && ( ((*lon/15)-(*tz/60)) > DELTA_LONGITUDE ) )
			{
				/*  reject system local timezone, because it's
					too far from the longitude explicitly provided
					by the user; guess based on longitude entered */
				*tz = (*lon /15) * 60;
			}
			if (!quiet_alerts) print_alert_timezone( *tz );
			if ( (*lat==BAD_COORDINATE) && (*lon==BAD_COORDINATE) )
			{
				if (!quiet_alerts) print_alert_default_location( *tz );
				set_default_location( *tz, lat, lon );
			}
			printf("\n");
		}
		else
		{	/* we have timezone, what about latitude and longitude? */
			if ( (opt_Longitude) && (opt_latitude) )
			{
				// sanity-check longitude versus timezone
				// timezone is in minutes
				if ( abs( ( (*tz/60) * 15 ) - *lon ) > DELTA_LONGITUDE )
				{
					error(0,0,"%s %d:%d %s %.3f %s",
							N_("time zone value of"), *tz/60, *tz%60,
							N_("is incompatible with a longitude of"), *lon, N_("degrees"));
					error_detected = TRUE;
				}
			}
			else
			{
				if (!quiet_alerts) print_alert_default_location( *tz );
				set_default_location( *tz, lat, lon );
				printf("\n");
			}
		}
	}

	/* exit after reporting all bad parameters found */
	if (error_detected)
	{
		print_usage();
		exit(EXIT_CODE_BAD_PARMS);
	}
}


/************************************************************
* check validity of date parameters
************************************************************/
#define CHECK_DAY_PARM   1
#define CHECK_MONTH_PARM 2
#define CHECK_YEAR_PARM  3
int validate_hdate (int parameter_to_check, int day, int month, int year)
{
	hdate_struct h;
	
	if (year < 0) return FALSE;
	
	switch (parameter_to_check)
	{

	case CHECK_DAY_PARM:

		/************************************************************
		* check day in Hebrew date
		************************************************************/
		if (year > 3000)
		{
			if (year > 10999) return FALSE;
			hdate_set_hdate (&h, 1, 1, year);
			if ((day < 1) || (day > 30) ||
				((day > 29) && ((month==4) || (month==6) || (month==8) || (month=10) || (month==12) || (month==14))) ||
				(((h.hd_size_of_year==353) || (h.hd_size_of_year==383)) && ((month==2) || (month==3)) && (day >29)) ||
				(((h.hd_size_of_year==354) || (h.hd_size_of_year==384)) && (month==2) && (day>29)) )			
				return FALSE;
			return TRUE;
		}

		/************************************************************
		* check day in Gregorian date
		************************************************************/
		else
		{
			if ((day < 1) || 
				((day > 31) && ((month==1) || (month==3) || (month==5) || (month==7) || (month==8) || (month==10) ||(month==12))) ||
				((day > 30) && ((month==4) || (month==6) || (month==9) || (month==11))) ||
				((day > 29) && (month==2) && ((year%4)==0)) ||
				((day > 28) && (month==2) && ((year%4)!=0))
			   )
				return FALSE;
			return TRUE;
		}
		break;	


	case CHECK_MONTH_PARM:

		/************************************************************
		* check month in Hebrew date
		************************************************************/
		if (year > 3000)
		{
			if (year > 10999) return FALSE;
			if ((month <= 0) || (month > 14)) return FALSE;
			hdate_set_hdate (&h, 1, 1, year);
			if ((h.hd_size_of_year <365) && (month >12)) return FALSE;
			return TRUE;
		}

		/************************************************************
		* check month in Gregorian date
		************************************************************/
		else
		{
			if ((month <= 0) || (month > 12)) return FALSE;
			return TRUE;
		}
		break;
	
	case CHECK_YEAR_PARM:
		if (year > 10999) return FALSE;
		return TRUE;
		break;
	}
	return FALSE;
}

/************************************************************
* Greeting message to new version
************************************************************/
void greetings_to_version_16()
{
	error(0,0,"%s",N_("\
This seems to be to be your first time using this version.\n\
Please read the new documentation in the man page and config\n\
file. Attempting to create a config file ..."));
}


/************************************************************
* Open config file, or create one
*  - returns filepointer or NULL
*  - if file does not exist, attempt to create it
************************************************************/
FILE* get_config_file(	const char* config_dir_name,
						const char* config_file_name,
						const char* default_config_file_text )
{
	size_t path_len;

	char* config_home_path_name = "";
	char* config_sub_path_name = "";

	char* config_dir_path;
	char* config_file_path;

	FILE* config_file;

	/************************************************************
	* sub-function to get_config_file: create_config_file
	************************************************************/
	void create_config_file()
	{
		config_file = fopen(config_file_path, "a");
		if (config_file == NULL)
		{
			error(0, errno, "%s: %s", N_("failure attempting to create config file"), config_file_path);
			return;
		}
		fprintf(config_file, "%s", default_config_file_text);
		error(0,0,"%s: %s",N_("config file created"), config_file_path);
		if (fclose(config_file) != 0) error(0,errno,"%s %s",N_("failure closing"),config_file_name);
	}

	/************************************************************
	* sub-function to get_config_file: open_config_file
	************************************************************/
	int open_config_file()
	{
		config_file = fopen(config_file_path, "r");
		if (config_file == NULL)
		{
			if (errno != ENOENT) return FALSE;
			// maybe replace all this with a single line asprintf()
			path_len = strlen(config_home_path_name)
						+ strlen(config_sub_path_name)
						+ strlen(config_dir_name) +1;
			if (path_len < 1) return FALSE;
			config_dir_path = malloc(path_len);
			if (config_dir_path == NULL)
			{
				error(0,errno,"%s",N_("memory allocation failure"));
				return FALSE;
			}
			snprintf(config_dir_path, path_len, "%s%s%s",
					config_home_path_name, config_sub_path_name,
					config_dir_name);
	
			if ((mkdir(config_dir_path, (mode_t) 0700) != 0) &&
				(errno != EEXIST))
			{
				free(config_dir_path);
				return FALSE;
			}
			greetings_to_version_16();
			create_config_file();
			free(config_dir_path);
			return FALSE;
		}
		return TRUE;
	}


/************************************************************
* main part of function get_config_file
************************************************************/
	config_home_path_name = getenv("XDG_CONFIG_HOME");
	if (config_home_path_name == NULL)
	{
		config_home_path_name = getenv("HOME");
		if (config_home_path_name == NULL)
		{
			struct passwd *passwdEnt = getpwuid(getuid());
			config_home_path_name = passwdEnt->pw_dir;
			if (config_home_path_name == NULL) return NULL;
		}
		config_sub_path_name = "/.config";
	}

	// maybe replace all this with a single line asprintf()
	path_len = strlen(config_home_path_name) + strlen(config_sub_path_name)
				+ strlen(config_dir_name) + strlen(config_file_name) + 1;
	if (path_len < 1) return NULL;
	config_file_path = malloc(path_len);
	if (config_file_path == NULL)
	{
		error(0,errno,"memory allocation failure");
		return NULL;
	}
	snprintf(config_file_path, path_len, "%s%s%s%s",
			config_home_path_name, config_sub_path_name,
			config_dir_name, config_file_name);

	if (open_config_file() == TRUE)
	{
		free(config_file_path);
		return config_file;
	}
	else
		free(config_file_path);
		return NULL;
}




/**********************************************************************
* parse user's menu selection into options and their posibile
* arguments, which can then be parsed (processed really)
*
* menuptr points to the beginning of the menu entry string. This
*       pointer should initially be set to NULL.
* menu_len is the length of the menu entry string
* menu_index is the current position of the parser within the string.
*       This value should initially be set to 0.
* optptr is a pointer into which we put the location of option text
*       to be parsed. This pointer should initially be set to NULL.
* optarg is a pointer to a possible argument to the option. This is a
*       global variable defined by GNU getopt(), so it shouldn't be
*       declared or passed.
* long_options is a pointer to a structure of type option, as defined
*       by getopt_long()
* long_option_index is a pointer to position found in long_options, and
*       simulates the similar value returned by getopt_long()
* error_detected is a pointer to an accumulator used to delay aborting
*       the program until after ALL input syntax errors are reported.
* 
* RETURN VALUES:
*	-1 means the menu line string has been completely parsed.
*	Otherwise, the return value should be the short option character
*	found, or in the case of a long option found, 0.
*	This should sound suspiciously similar to the return values issued
*   by getopt_long().
***********************************************************************/
int menu_item_parse(char* menuptr, size_t menu_len, int *menu_index,
					char** optptr, char* short_options,
					struct option *long_options, int *long_option_index,
					int *error_detected)
{
	int ahead_index;
	char *ahead;

	while ( (*menu_index < menu_len) &&
			(menuptr[*menu_index] != '#') )
	{
		if (menuptr[*menu_index] == '-')
		{
			if ( ( (*menu_index+1) >= menu_len) ||
				(menuptr[*menu_index+1] == '#') ) break;
			else if (menuptr[*menu_index+1] == '-')
			{
				if ( ( (*menu_index+2) >= menu_len) ||
					(menuptr[*menu_index+2] == '#') ) break;
				*menu_index = *menu_index +2;

				/**************************************************
				* We have identified the beginning of what could
				* be a long option string. We store a pointer to
				* it in optptr and proceed to:
				*   find its endpoint
				*   terminate it with a null
				*   if it has an argument, store a pointer to
				* it in optarg and terminate it with a null.
				* Then we compare the optptr to our list of
				* valid longoptions and pass the information
				* to the option parser
				*************************************************/
				*optptr = &menuptr[*menu_index]; // ??
				ahead = *optptr;
				ahead_index = *menu_index;
				while ( (ahead_index < menu_len) &&
						(strchr(" =#",*ahead) == NULL) )
					{
						ahead_index++;
						ahead++;
					}
				if (memcmp(ahead,"=",1)==0)
				{
					*ahead = '\0';
					ahead++;
					optarg = ahead;
					ahead_index++;
					while ( (ahead_index < menu_len) &&
							(strchr(" #",*ahead) == NULL) )
					{
						ahead_index++;
						ahead++;
					}
				}
				if ((*ahead == '#' ) && ((ahead_index+1) < menu_len))
					ahead[1] = '#';
				*ahead = '\0';
				*long_option_index = 0;
				while ( (long_options[*long_option_index].name != 0) &&
						(strcmp(long_options[*long_option_index].name, *optptr) != 0) )
					*long_option_index = *long_option_index + 1;
				if (long_options[*long_option_index].name == 0)
				{
					*error_detected = *error_detected + 1;
					print_parm_invalid_error(*optptr);
				}
				else
				{
					*menu_index = ahead_index;
					return long_options[*long_option_index].val;
				}
			}
			else
			{
				*menu_index = *menu_index + 1;
				/**************************************************
				* parse a short option from a menu line
				*************************************************/
				if ((strchr(short_options, (int) menuptr[*menu_index]) == NULL) ||
					(menuptr[*menu_index] == ':') )
				{
					*error_detected = *error_detected + 1;
					print_parm_invalid_error(*optptr);
				}
				else
				{
					*optptr = &menuptr[*menu_index];
					*long_option_index = -1;
					if (strchr("lLz", (int) menuptr[*menu_index]) != NULL)
					{
						ahead_index = *menu_index+1;
						while ( (ahead_index < menu_len) &&
								(memcmp(&menuptr[ahead_index]," ",1)==0) ) ahead_index++;
						optarg = &menuptr[ahead_index];
						while ( (ahead_index < menu_len) &&
								(memcmp(&menuptr[ahead_index]," ",1)) ) ahead_index++;
						menuptr[ahead_index] = '\0';
						*menu_index = ahead_index;
					}
					return **optptr;
				}

			}
		}
		*menu_index = *menu_index + 1;
	}
	return -1;
}


/**************************************************
* prompt user for menu selection
*************************************************/
int menu_select( char* menu_list[], int max_menu_items )
{
	int i, j;

	for (i=0; i< max_menu_items; i++)
	{
		if (menu_list[i] == NULL) break;
		if (i==0) printf("\n%s:\n\n", N_("your custom menu options (from your config file)"));
		printf("     %d: %s\n",i,menu_list[i]);
	}
	j = i;
	if (i == 0)
	{
		error(0,0,N_("ALERT: -m (--menu) option specified, but no menu items in config file"));
		return -1;
	}
	printf("\n%s: ",N_("enter your selection, or <return> to continue"));
	i = getchar() - 48; // effectively converts valid values to integers
	if ((i < 0) || (i >= j))
	{
		error(0,0,N_("menu selection received was out of bounds"));
		return -1;
	}
	printf("\n");
	return i;
}
