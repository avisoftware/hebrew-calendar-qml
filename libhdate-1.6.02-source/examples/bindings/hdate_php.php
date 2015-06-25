#! /usr/bin/php
<?php

# hdate_php.php
# example file for libhdate.
#

#
# run: php hdate_php.php
#

#
#  Copyright (C) 2008  Yaacov Zamir <kzamir@walla.co.il>
#  
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

require ("hdate.php");

# Create a new Hdate object
$h = new Hdate();

# Print gregorian date
echo "Today is:\n";
echo $h->get_gday().".".$h->get_gmonth().",".$h->get_gyear()."\n";

# Print hebrew date: 0 - long format
echo $h->get_format_date(0)."\n";

?>
