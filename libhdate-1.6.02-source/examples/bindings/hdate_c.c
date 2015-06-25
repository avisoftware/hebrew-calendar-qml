/* hdate_c.c
 * example file for libhdate.
 */

/*
 compile: gcc -lm -lhdate -o hdate_c hdate_c.c
 */

/*
 *  Copyright (C) 2008  Yaacov Zamir <kzamir@walla.co.il>
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

#include <stdio.h> /* for printf */
#include <hdate.h> /* for hebrew date */

int
main()
{
	/* date will be stored in h */
	hdate_struct *h; 

	/* alocate the hdate memory */
	h = new_hdate ();
	
	/* copy the hebrew date struct of today <day=0, month=0, year=0> */
	hdate_set_gdate(h, 0, 0, 0); 
	
	/* print gregorian date */
	printf ("Today is :\n");
	printf ("%d,%d,%d\n", hdate_get_gday (h), hdate_get_gmonth (h), hdate_get_gyear (h));
	
	/* print hebrew date: 0 - israely holidays, 0 - long format */
	printf ("%s\n", hdate_get_format_date (h, 0, 0));
	printf ("\n");
	
	/* unref the used memory */
	delete_hdate (h);
	
	return 0;
}

