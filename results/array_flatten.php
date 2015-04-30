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


/**
\sa http://www.phpro.org/examples/Flatten-Array.html
*/


/*

function array_flatten_vals(array $array, $preserve_keys = false)
{
	$result = array();

	if ($preserve_keys)
	{
	foreach (new RecursiveIteratorIterator(new RecursiveArrayIterator($array)) as $key => $val)
	{
		$result[$key] = $val;
	}
	}
	else
	{
	foreach (new RecursiveIteratorIterator(new RecursiveArrayIterator($array)) as $val)
	{
		$result[] = $val;
	}
	}

	return $result;
}
*/


function array_flatten_vals(array $array)
{
	$result = array();

	foreach (new RecursiveIteratorIterator(new RecursiveArrayIterator($array)) as $val)
	{
		$result[] = $val;
	}

	return $result;
}


function array_flatten_keys(array $array)
{
	$result = array();

	foreach (new RecursiveIteratorIterator(new RecursiveArrayIterator($array)) as $key => $val)
	{
		$result[] = $key;
	}

	return $result;
}


function array_flatten(array $array, $key_separator = '/')
{
	$result = array();

	// a stack of strings
	$keys = array();

	$prev_depth = -1;

	$iter = new RecursiveIteratorIterator(new RecursiveArrayIterator($array), RecursiveIteratorIterator::SELF_FIRST);

	// rewind() is necessary
	for ($iter->rewind(); $iter->valid(); $iter->next())
	{
		$curr_depth = $iter->getDepth();

		$diff_depth = $prev_depth - $curr_depth + 1;

		//##### TODO: It would be nice to do this with a single function.
		while ($diff_depth > 0)
		{
			array_pop($keys);
			--$diff_depth;
		}
		/*
		Note:
		http://bugs.php.net/bug.php?id=52425
		array_shift/array_pop: add parameter that tells how many to elements to pop
		*/

		array_push($keys, $iter->key());

		if (is_scalar($iter->current()))
		{
			$result[implode($key_separator, $keys)] = $iter->current();
		}

		$prev_depth = $curr_depth;
	}

	return $result;
}


?>
