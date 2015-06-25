// hdate_cpp.cpp
// example file for libhdate.
//

//
// compile: g++ -lm -lhdate -o hdate_cpp hdate_cpp.cpp
//

//
//  Copyright (C) 2008  Yaacov Zamir <kzamir@walla.co.il>
//  
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#include <iostream>
#include <hdatepp.h>

using namespace std;
using namespace hdate;

int
main (int argc, char* argv[])
{
	// create a new Hdate object
	Hdate h;

	// print gregorian date
	cout << "Today is :" << endl;
	cout << h.get_gday () << "," << h.get_gmonth () << "," << h.get_gyear () << endl;
	
	// print hebrew date: 0 - long format
	cout << h.get_format_date (0) << endl;

	return 0;
}
