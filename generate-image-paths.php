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

if (assert_options(ASSERT_BAIL, 1) === false)
{
	exit('"assert_options" function failed.');
}

$script_name = basename(__FILE__);

$version = '2013-01-06';

$author = 'Steve Ward';

// default values

$default_verbose = false;

$default_debug = false;

// mutable values

$verbose  = $default_verbose;

$debug  = $default_debug;

/// Print the help message and exit.
function print_help()
{
	global $script_name;

	print(<<<EOT
Usage: php $script_name [OPTIONS]
Generate the JSON data structures to be used in the iqatest app.

OPTIONS:
  --version : Print the version information and exit.
  --help : Print this message and exit.
  --verbose : Print extra output.
  --debug : Print values of many data.

EOT
);

	exit(0);
}

/// Print the version information and exit.
function print_version()
{
	global $script_name;
	global $version;
	global $author;

	print($script_name . ' ' . $version . "\n");

	print("Written by " . $author . "\n");

	exit(0);
}

/// Print the message if verbose mode is on.
function print_verbose($s)
{
	global $verbose;

	if ($verbose)
	{
		print("# $s\n");
	}
}

/// Print the warning message and continue.
function print_warning($s)
{
	fwrite(STDERR, "Warning: $s\n");
}

/// Print the error message and exit.
function print_error($s)
{
	global $script_name;

	fwrite(STDERR, "Error: $s\n");

	fwrite(STDERR, "Try '$script_name --help' for more information.\n");

	exit(1);
}

/// Print the value of the datum.
function print_debug($datum_name)
{
	global $debug;

	if ($debug)
	{
		$datum_value = var_export($GLOBALS[$datum_name], true);

		print("\$$datum_name = $datum_value;\n\n");
	}
}

// remove the script name
assert(array_shift($argv) != null);
--$argc;

// http://www.php.net/manual/en/function.getopt.php

$long_options = array('version', 'help', 'verbose', 'debug',);

$options = getopt(null, $long_options);

if (isset($options['version'])) {print_version();}

if (isset($options['help'])) {print_help();}

if (isset($options['verbose'])) {$verbose = true; assert(array_shift($argv) != null); --$argc;}

if (isset($options['debug'])) {$debug = true; assert(array_shift($argv) != null); --$argc;}

//print('// generated by ' . escapeshellarg($argv[0]) . ' on ' . date_create()->format(DateTime::ISO8601) . "\n");
print('// generated by ' . $script_name . ' on ' . date_create()->format(DateTime::ISO8601) . "\n");
print('// phpversion(): ' . phpversion() . "\n");
print("// phpversion('json'): " . phpversion('json') . "\n");
print("\n");

$image_set_path = 'images/sets/';
print_debug('image_set_path');

if (!file_exists($image_set_path))
{
	print_error(escapeshellarg($image_set_path) . ' does not exist.');
}

if (!is_dir($image_set_path))
{
	print_error(escapeshellarg($image_set_path) . ' is not a directory.');
}

if (!chdir($image_set_path))
{
	print_error('Could not chdir to ' . escapeshellarg($image_set_path) . '.');
}

print('iqatest.image_set_path = ' . escapeshellarg($image_set_path) . ';');
print("\n");
print("\n");

print(<<<EOT
// the results to be submitted

iqatest.results = {};

iqatest.results.id         = "";
iqatest.results.ip_address = "";
iqatest.results.host_name  = "";
iqatest.results.user_agent = "";

iqatest.results.screen_properties = {};

iqatest.results.screen_properties.width      = screen.width     ;
iqatest.results.screen_properties.height     = screen.height    ;
iqatest.results.screen_properties.colorDepth = screen.colorDepth;

iqatest.results.participant_information = {};


EOT
);

$image_sets = glob('*', GLOB_NOSORT | GLOB_ONLYDIR);
print_debug('image_sets');

if ($image_sets === false)
{
	print_error('"glob" function failed.');
}

$image_sets_len = count($image_sets);
print_debug('image_sets_len');

if ($image_sets_len == 0)
{
	print_error('Could not find image sets matching pattern ' . escapeshellarg($image_set_path . '*') . '.');
}

if (sort($image_sets) == false)
{
	print_error('Error sorting image sets.');
}

print_debug('image_sets');

/*

When encoding PHP objects and associative arrays to JSON, you must put parentheses around the JSON.

ECMAScript Language Specification

ECMA-262
5th Edition / December 2009

12.4 Expression Statement
Note:
An ExpressionStatement cannot start with an opening curly brace because that might make it ambiguous with a Block.

*/

//print('iqatest.results.image_sets = (' . json_encode($image_sets) . ');');
print('iqatest.results.image_sets = ' . json_encode($image_sets) . ';');
print("\n");
print("\n");

$image_set_indexes = range(0, $image_sets_len - 1); // example: 0...5 (length: 6)
print_debug('image_set_indexes');

assert($image_sets_len == count($image_set_indexes));

print('iqatest.results.image_set_indexes = ' . json_encode($image_set_indexes) . ';');
print("\n");
print("\n");

$anti_reference_pattern = 'anti-reference*';
print_debug('anti_reference_pattern');

$reference_pattern = 'reference*';
print_debug('reference_pattern');

$distorted_pattern = 'distorted*';
print_debug('distorted_pattern');

$images = array();

$image_indexes = array();

$image_comparisons = array();

foreach($image_sets as $image_set)
{
	print_verbose('--------------------------------------------------------------------------');

	print_debug('image_set');

	if (!chdir($image_set))
	{
		print_error('Could not chdir to ' . escapeshellarg($image_set) . '.');
	}

	// get the anti-reference image

	$anti_reference = glob($anti_reference_pattern, GLOB_NOSORT);
	print_debug('anti_reference');

	// validate the anti-reference image

	if ($anti_reference === false)
	{
		print_error('"glob" function failed.');
	}

	if (empty($anti_reference))
	{
		print_error('Could not find anti-reference image for image set ' . escapeshellarg($image_set) . '.');
	}

	$anti_reference_len = count($anti_reference);
	print_debug('anti_reference_len');

	if ($anti_reference_len > 1)
	{
		print_error('There may only be one anti-reference image for image set ' . escapeshellarg($image_set) . '.');
	}

	assert($anti_reference_len == 1);

	// get the reference image

	$reference = glob($reference_pattern, GLOB_NOSORT);
	print_debug('reference');

	// validate the reference image

	if ($reference === false)
	{
		print_error('"glob" function failed.');
	}

	if (empty($reference))
	{
		print_error('Could not find reference image for image set ' . escapeshellarg($image_set) . '.');
	}

	$reference_len = count($reference);
	print_debug('reference_len');

	if ($reference_len > 1)
	{
		print_error('There may only be one reference image for image set ' . escapeshellarg($image_set) . '.');
	}

	assert($reference_len == 1);

	// get the distorted images

	$distorted = glob($distorted_pattern, GLOB_NOSORT);
	print_debug('distorted');

	// validate the distorted images

	if ($distorted === false)
	{
		print_error('"glob" function failed.');
	}

	if (empty($distorted))
	{
		print_error('Could not find distorted images for image set ' . escapeshellarg($image_set) . '.');
	}

	$distorted_len = count($distorted);
	print_debug('distorted_len');

	assert($distorted_len > 0);

	if (natcasesort($distorted) == false)
	{
		print_error('Error sorting distorted images.');
	}

	// do not maintain key association
	$distorted = array_values($distorted);
	print_debug('distorted');

	// the anti-reference image is at index 0
	// the reference image is at index 1
	// the distorted images are at indexes [2, 11]

	$image_arr = array_merge($anti_reference, $reference, $distorted);
	print_debug('image_arr');

	$image_arr_len = count($image_arr);
	print_debug('image_arr_len');

	assert($image_arr_len == ($anti_reference_len + $reference_len + $distorted_len));

	$images[] = $image_arr;

	$new_anti_reference_len = intval($distorted_len / 2);
	print_debug('new_anti_reference_len');

	$new_reference_len = $distorted_len - $new_anti_reference_len;
	print_debug('new_reference_len');

	assert($distorted_len == ($new_anti_reference_len + $new_reference_len));

	// indexes of the anti-reference image
	// the anti-reference image is always index 0
	$anti_reference_indexes = array_fill(0, $new_anti_reference_len, 0);
	print_debug('anti_reference_indexes');

	// indexes of the reference image
	// the reference image is always index 1
	$reference_indexes = array_fill(0, $new_reference_len, 1);
	print_debug('reference_indexes');

	// indexes of the distorted images
	$distorted_indexes = range(2, $distorted_len + 1); // ex: 2...11 (length: 10)
	print_debug('distorted_indexes');

	assert(count($distorted_indexes) == (count($anti_reference_indexes) + count($reference_indexes)));

	// create the image_indexes array

	$image_index_arr = array_merge($anti_reference_indexes, $reference_indexes, $distorted_indexes);
	print_debug('image_index_arr');

	$image_index_arr_len = count($image_index_arr);
	print_debug('image_index_arr_len');

	// there are twice as many image_indexes as distorted images
	assert($distorted_len * 2 == $image_index_arr_len);

	$image_indexes[] = $image_index_arr;

	// create the image_comparisons array

	$image_comparison_arr = array_fill(0, $image_arr_len, 0);
	print_debug('image_comparison_arr');

	$image_comparison_arr_len = count($image_comparison_arr);
	print_debug('image_comparison_arr_len');

	assert($image_arr_len == $image_comparison_arr_len);

	$image_comparisons[] = $image_comparison_arr;

	if (!chdir('..'))
	{
		print_error('Could not chdir to ' . escapeshellarg('..') . '.');
	}
}

print_verbose('--------------------------------------------------------------------------');

print_debug('images');

print('iqatest.results.images = ' . json_encode($images) . ';');
print("\n");
print("\n");

print_debug('image_indexes');

print('iqatest.results.image_indexes = ' . json_encode($image_indexes) . ';');
print("\n");
print("\n");

print_debug('image_comparisons');

print('iqatest.results.image_comparisons = ' . json_encode($image_comparisons) . ';');
print("\n");
print("\n");

?>
