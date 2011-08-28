<?php

/*

Image Quality Assessment Test
Copyright (C) 2011  Steve Ward

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3 of the License.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

*/


//------------------------------------------------------------------------------


/// if the haystack contains the needle
function string_contains($haystack, $needle)
{
	return strpos($haystack, $needle) !== false;
}


//------------------------------------------------------------------------------


/// if the string begins with a space
function string_begins_with_space($str)
{
	return preg_match('/^[[:space:]]/', $str) == 1;
}


/// if the string ends with a space
function string_ends_with_space($str)
{
	return preg_match('/[[:space:]]$/', $str) == 1;
}


//------------------------------------------------------------------------------


/// Quote the string for a CSV field
/**

\sa http://creativyst.com/Doc/Articles/CSV/CSV01.htm

\sa http://en.wikipedia.org/wiki/Comma-separated_values

*/
function quote_csv($str,
	$csv_record_separator = "\n",
	$csv_field_separator = ',',
	$csv_incloser = '"')
{
	if (string_contains($str, $csv_incloser))
	{
		return $csv_incloser . str_replace($csv_incloser, $csv_incloser . $csv_incloser, $str) . $csv_incloser;
	}

	if (string_contains($str, $csv_record_separator) ||
		string_contains($str, $csv_field_separator) ||
		string_begins_with_space($str) ||
		string_ends_with_space($str))
	{
		return $csv_incloser . $str . $csv_incloser;
	}

	return $str;
}


//------------------------------------------------------------------------------


?>
