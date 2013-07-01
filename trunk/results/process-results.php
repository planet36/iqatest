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


/*

example:

gzip --decompress iqatest_results_*.php.gz

TMP_OUTFILE=iqatest_results_TMP.csv

php process-results.php iqatest_results_*.php | sort | uniq > "${TMP_OUTFILE}"

OUTFILE=iqatest_results_$(date +'%Y%m%d_%H%M%S').csv

# Put the last line (column names) at the top.
tail --lines=1 "${TMP_OUTFILE}" > "${OUTFILE}"
head --lines=-1 "${TMP_OUTFILE}" >> "${OUTFILE}"
#{ tail --lines=1 "${TMP_OUTFILE}" ; head --lines=-1 "${TMP_OUTFILE}" ; } > "${OUTFILE}"

rm "${TMP_OUTFILE}"

chmod go-rwx "${OUTFILE}"

*/


//------------------------------------------------------------------------------


require_once('array_flatten.php');

require_once('quote_csv.php');


//------------------------------------------------------------------------------


if (assert_options(ASSERT_BAIL, 1) === false)
{
	exit('"assert_options" function failed.');
}


$script_name = basename(__FILE__);


//------------------------------------------------------------------------------


// default values

$default_verbose = false;


// mutable values

$verbose  = $default_verbose;

//------------------------------------------------------------------------------


function print_help()
{
	global $script_name;
	global $default_verbose;

	print(<<<EOT
Usage: php $script_name [--version] [--help] [--verbose] RESULTS_PHP_FILE ...
Process the RESULTS_PHP_FILE(s) and print the output in CSV format.
  --version : Print the version information and exit.
  --help : Print this message and exit.
  --verbose : Print extra output. (default $default_verbose)
  RESULTS_PHP_FILE : A PHP file with results submitted from the iqatest.
EOT
);

	exit(0);
}


/// Print the version information and exit.
function print_version()
{
	global $script_name;

	print("$script_name 2011-08-28\n");

	print("Written by Steve Ward\n");

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


//------------------------------------------------------------------------------


// remove the script name
assert(array_shift($argv) != null);
--$argc;


//------------------------------------------------------------------------------


// http://www.php.net/manual/en/function.getopt.php

$long_options = array('version', 'help', 'verbose',);

$options = getopt(null, $long_options);

if (isset($options['version'])) {print_version();}

if (isset($options['help'])) {print_help();}

if (isset($options['verbose'])) {$verbose = true; assert(array_shift($argv) != null); --$argc;}


//------------------------------------------------------------------------------


if ($argc < 1)
{
	print_error("Must give at least 1 file.");
}


//------------------------------------------------------------------------------


function process_results_to_array($results_exported_file_name)
{
	//#####
	//global $verbose;

	// $results_exported is instantiated
	require_once($results_exported_file_name);

	assert(isset($results_exported));

	// $results_exported has the results that were submitted

	print_verbose('results_exported: ' . print_r($results_exported, true));

	//--------------------------------------------------------------------------

	$results_array = array();

	//--------------------------------------------------------------------------

	assert(array_key_exists('id'        , $results_exported));
	assert(array_key_exists('ip_address', $results_exported));
	assert(array_key_exists('host_name' , $results_exported));
	assert(array_key_exists('user_agent', $results_exported));

	$results_array['id'        ] = $results_exported['id'        ];
	$results_array['ip_address'] = $results_exported['ip_address'];
	$results_array['host_name' ] = $results_exported['host_name' ];
	$results_array['user_agent'] = $results_exported['user_agent'];

	//--------------------------------------------------------------------------

	assert(array_key_exists('screen_properties', $results_exported));

	//$results_array['screen_properties'] = $results_exported['screen_properties'];
	//$results_array += $results_exported['screen_properties'];
	$results_array['screen_properties'] = implode('x', $results_exported['screen_properties']);

	//--------------------------------------------------------------------------

	assert(array_key_exists('participant_information', $results_exported));

	//$results_array['participant_information'] = $results_exported['participant_information'];
	$results_array += $results_exported['participant_information'];

	//--------------------------------------------------------------------------

	assert(array_key_exists('image_sets', $results_exported));

	assert(array_key_exists('image_set_indexes', $results_exported));

	assert(array_key_exists('images', $results_exported));

	assert(array_key_exists('image_indexes', $results_exported));

	assert(array_key_exists('image_comparisons', $results_exported));

	//--------------------------------------------------------------------------

	/*
	$image_set_order = array();

	foreach ($results_exported['image_set_indexes'] as $image_set_index)
	{
		$image_set_name = $results_exported['image_sets'][$image_set_index];

		$image_set_order[] = $image_set_name;
	}

	$results_array['image_set_order'] = implode(',', $image_set_order);
	*/
	$results_array['image_set_order'] = implode(',', $results_exported['image_set_indexes']);

	//--------------------------------------------------------------------------

	$image_order = array();

	//foreach ($results_exported['image_indexes'] as /*$image_set_index =>*/ $image_set)
	foreach ($results_exported['image_indexes'] as $image_set_index => $image_set)
	{
		$image_order[$image_set_index] = implode(',', $image_set);
		//$image_order[] = implode(',', $image_set);
	}

	$results_array['image_order'] = $image_order;

	//--------------------------------------------------------------------------

	$image_comparisons = array();

	foreach ($results_exported['image_comparisons'] as $image_set_index => $image_set)
	{
		$image_set_name = $results_exported['image_sets'][$image_set_index];

		$image_comparisons[$image_set_name] = array();

		foreach ($image_set as $image_index => $image_comparison)
		{
			$image_name = $results_exported['images'][$image_set_index][$image_index];

			$image_comparisons[$image_set_name][$image_name] = $image_comparison;
		}
	}

	$results_array += $image_comparisons;

	//--------------------------------------------------------------------------

	return $results_array;
}


//------------------------------------------------------------------------------


// each arg is a file name of exported results
foreach ($argv as $results_exported_file_name)
{
	if (!file_exists($results_exported_file_name))
	{
		continue;
	}

	if (filesize($results_exported_file_name) == 0)
	{
		continue;
	}

	// get the results array from the exported results in the file
	$results_array = process_results_to_array($results_exported_file_name);
	print_verbose('results_array: ' . print_r($results_array, true));

	// flatten the results array
	$results_array_flattened = array_flatten($results_array);
	print_verbose('results_array_flattened: ' . print_r($results_array_flattened, true));

	// convert the flattened results array to a CSV string
	print(implode(',', array_map('quote_csv', array_keys($results_array_flattened))) . "\n");
	print(implode(',', array_map('quote_csv', array_values($results_array_flattened))) . "\n");
}


// 264 209 189 305

?>
