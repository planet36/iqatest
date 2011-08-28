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


// constant 'JSON_ERROR_UTF8' exists in PHP PHP 5.3.3+
if (!defined('JSON_ERROR_UTF8'))
{
	define('JSON_ERROR_UTF8', 5);
}


// convert the json error value to a string
function json_error_to_string($error)
{
	switch ($error)
	{
	case JSON_ERROR_NONE:      return "JSON_ERROR_NONE ($error) No error has occurred"; break;
	case JSON_ERROR_DEPTH:     return "JSON_ERROR_DEPTH ($error) The maximum stack depth has been exceeded"; break;
	case JSON_ERROR_CTRL_CHAR: return "JSON_ERROR_CTRL_CHAR ($error) Control character error, possibly incorrectly encoded"; break;
	case JSON_ERROR_SYNTAX:    return "JSON_ERROR_SYNTAX ($error) Syntax error"; break;
	case JSON_ERROR_UTF8:      return "JSON_ERROR_UTF8 ($error) Malformed UTF-8 characters, possibly incorrectly encoded"; break;
	default:                   return "??? ($error) Unknown error"; break;
	}
}


?>
