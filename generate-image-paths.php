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


$debug = false;


function debug_print($var, $var_name)
{
	global $debug;

	if ($debug)
	{
		print "$var_name = ";
		//var_dump($var);
		var_export($var);
		print ";\n";
		print "\n";
	}
}


//------------------------------------------------------------------------------


$image_sets_path = 'images/sets/';

debug_print($image_sets_path, '$image_sets_path');


if (!file_exists($image_sets_path))
{
	exit('Path to image sets does not exist.');
}


if (!is_dir($image_sets_path))
{
	exit('Path to image sets is not a directory.');
}


//------------------------------------------------------------------------------


$image_set_names = glob($image_sets_path . '*', GLOB_MARK | GLOB_NOSORT | GLOB_ONLYDIR);

debug_print($image_set_names, '$image_set_names');


if ($image_set_names === false)
{
	exit('Could not find image sets matching pattern ' . escapeshellarg($image_sets_path . '*') . '.');
}

if (natcasesort($image_set_names) == false)
{
	exit('Error sorting image sets.');
}

debug_print($image_set_names, '$image_set_names');


//------------------------------------------------------------------------------


$reference_image_pattern = 'reference*';

debug_print($reference_image_pattern, '$reference_image_pattern');


$distorted_pattern = 'distorted*';

debug_print($distorted_pattern, '$distorted_pattern');


//------------------------------------------------------------------------------


$image_sets = array();


foreach($image_set_names as $image_set)
{
	debug_print($image_set, '$image_set');

	//--------------------------------------------------------------------------
	// get the reference image

	$reference_image = glob($image_set . $reference_image_pattern, GLOB_NOSORT);

	debug_print($reference_image, '$reference_image');

	if ($reference_image === false)
	{
		exit('Could not find reference image for image set ' . escapeshellarg($image_set) . '.');
	}

	if (count($reference_image) < 1)
	{
		exit('Could not find reference image for image set ' . escapeshellarg($image_set) . '.');
	}

	if (count($reference_image) > 1)
	{
		exit('There may only be one reference image for image set ' . escapeshellarg($image_set) . '.');
	}

	$reference_image = $reference_image[0];

	debug_print($reference_image, '$reference_image');

	//--------------------------------------------------------------------------
	// get the distorted images

	$distorted = glob($image_set . $distorted_pattern, GLOB_NOSORT);

	debug_print($distorted, '$distorted');

	if ($distorted === false)
	{
		exit('Could not find distorted images for image set ' . escapeshellarg($image_set) . '.');
	}

	if (count($distorted) < 1)
	{
		exit('Could not find distorted images for image set ' . escapeshellarg($image_set) . '.');
	}

	if (natcasesort($distorted) == false)
	{
		exit('Error sorting distorted images.');
	}

	$distorted = array_values($distorted);

	debug_print($distorted, '$distorted');

	//--------------------------------------------------------------------------

	$image_sets[] = array('reference_image' => $reference_image, 'distorted' => $distorted);
}


debug_print($image_sets, '$image_sets');


//------------------------------------------------------------------------------


foreach ($image_sets as $val)
{
	print "<img alt=\"reference image\" src=\"" . $val['reference_image'] . "\" />\n";

	foreach ($val['distorted'] as $val2)
	{
		print "<img alt=\"distorted image\" src=\"" . $val2 . "\" />\n";
	}
}
print "\n";


//------------------------------------------------------------------------------


print '// phpversion(): ' . phpversion() . "\n";
print "// phpversion('json'): " . phpversion('json') . "\n";
print "\n";


$json = json_encode($image_sets);

debug_print($json, '$json');


//------------------------------------------------------------------------------


/*

ECMAScript Language Specification

ECMA-262
5th Edition / December 2009

12.4 Expression Statement
Note:
An ExpressionStatement cannot start with an opening curly brace because that might make it ambiguous with a Block.

*/

print 'iqatest.image_sets = (' . $json . ');';
print "\n";
print "\n";


//------------------------------------------------------------------------------


/*

function json_last_error() is only in PHP 5.3.0+

if (json_last_error() != JSON_ERROR_NONE)
{
	exit("Could not encode images into JSON format.");
}
*/


$json_decoded_1 = json_decode($json);

//##### TODO: check if json_decode fails

debug_print($json_decoded_1, '$json_decoded_1');


//------------------------------------------------------------------------------


$json_decoded_2 = json_decode($json, true);

//##### TODO: check if json_decode fails

debug_print($json_decoded_2, '$json_decoded_2');


//------------------------------------------------------------------------------


?>
