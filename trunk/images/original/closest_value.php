<?php

/*

Image Quality Assessment Test
Copyright (C) 2010  Steve Ward

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


/// find the key of the array value closest to \a x
function closest_value(array $arr, $x)
{
	$min_key = null;

	if (!is_numeric($x))
	{
		return $min_key;
	}

	/// \sa http://php.net/manual/en/math.constants.php
	$min_val = INF;

	foreach ($arr as $key => $val)
	{
		if (!is_numeric($val))
		{
			continue;
		}

		$diff = abs($x - $val);

		if ($diff < $min_val)
		{
			$min_val = $diff;
			$min_key = $key;
		}
	}

	return $min_key;
}


?>
