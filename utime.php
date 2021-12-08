<?php

/*

Image Quality Assessment Test
Copyright (C) 2013 Steve Ward

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

/// return (as a string) the Unix timestamp with microsecond resolution
/**
\sa http://php.net/manual/en/function.gettimeofday.php
\sa http://php.net/manual/en/function.microtime.php
*/
function utime($t = NULL)
{
	if (is_null($t))
	{
		$t = gettimeofday(false);
	}

	return sprintf('%d.%06d', $t['sec'], $t['usec']);
}

?>
