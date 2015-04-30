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


/*

Usage:

php filter-ssim-values.php --verbose ./red_apple/metrics_quality.csv
php filter-ssim-values.php           ./red_apple/metrics_quality.csv

php filter-ssim-values.php --verbose $(find -type f -name metrics_quality.csv | sort)
php filter-ssim-values.php           $(find -type f -name metrics_quality.csv | sort)

php filter-ssim-values.php --verbose --min=0.82 --max=1.00 --inc=0.02 ./{albert_einstein,arnisee_region,bald_eagle,desiccated_sewage,red_apple,sonderho_windmill}/metrics_quality.csv
php filter-ssim-values.php           --min=0.82 --max=1.00 --inc=0.02 ./{albert_einstein,arnisee_region,bald_eagle,desiccated_sewage,red_apple,sonderho_windmill}/metrics_quality.csv

php filter-ssim-values.php --verbose --min=0.82 --max=0.90 --inc=0.08 ./gizah_pyramids/metrics_quality.csv
php filter-ssim-values.php           --min=0.82 --max=0.90 --inc=0.08 ./gizah_pyramids/metrics_quality.csv

*/


//------------------------------------------------------------------------------


if (assert_options(ASSERT_BAIL, 1) === false)
{
	exit('"assert_options" function failed.');
}


$script_name = basename(__FILE__);


//------------------------------------------------------------------------------


// default values

$default_verbose = false;

$default_ssim_min = 0.82;
$default_ssim_max = 1.00;
$default_ssim_inc = 0.02;

$default_limit = 0;


// mutable values

$verbose  = $default_verbose;

$ssim_min = $default_ssim_min;
$ssim_max = $default_ssim_max;
$ssim_inc = $default_ssim_inc;

$limit    = $default_limit;


//------------------------------------------------------------------------------


/// Print the help message and exit.
function print_help()
{
	global $script_name;
	global $default_verbose;
	global $default_ssim_min;
	global $default_ssim_max;
	global $default_ssim_inc;
	global $default_limit;

	print(<<<EOT
Usage: php $script_name [--version] [--help] [--verbose] [--min=MIN] [--max=MAX] [--inc=INC] METRICS_CSV_FILE ...
Filter the METRICS_CSV_FILE(s) for SSIM values that are closest to values in the given range.
  --version : Print the version information and exit.
  --help : Print this message and exit.
  --verbose : Print extra output. (default $default_verbose)
  --min=MIN : The minimum SSIM value. (default $default_ssim_min)
  --max=MAX : The maximum SSIM value. (default $default_ssim_max)
  --inc=INC : The increment of the SSIM values. (default $default_ssim_inc)
  --limit=LIMIT : Print no more than LIMIT entries.  A limit of 0 means unlimited. (default $default_limit)
  METRICS_CSV_FILE : A CSV file with the metrics of distorted images. The distorted image is the first field and the SSIM is the second field.

EOT
);

	exit(0);
}


/// Print the version information and exit.
function print_version()
{
	global $script_name;

	print($script_name . " 2013-03-01\n");

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

$long_options = array('version', 'help', 'verbose', 'min:', 'max:', 'inc:', 'limit:',);

$options = getopt(null, $long_options);

if (isset($options['version'])) {print_version();}

if (isset($options['help'])) {print_help();}

if (isset($options['verbose'])) {$verbose = true; assert(array_shift($argv) != null); --$argc;}

if (isset($options['min'])) {$ssim_min = floatval($options['min']); assert(array_shift($argv) != null); --$argc;}
if (isset($options['max'])) {$ssim_max = floatval($options['max']); assert(array_shift($argv) != null); --$argc;}
if (isset($options['inc'])) {$ssim_inc = floatval($options['inc']); assert(array_shift($argv) != null); --$argc;}

if (isset($options['limit'])) {$limit = intval($options['limit']); assert(array_shift($argv) != null); --$argc;}


//------------------------------------------------------------------------------


if ($ssim_min > $ssim_max)
{
	print_error("MIN ($ssim_min) must be <= MAX ($ssim_max).");
}

assert($ssim_min <= $ssim_max);


if ($ssim_inc <= 0)
{
	print_error("INC ($ssim_inc) must be > 0.");
}

assert($ssim_inc > 0);


if ($limit < 0)
{
	print_error("LIMIT ($limit) must be >= 0.");
}

assert($limit >= 0);


if ($argc < 1)
{
	print_error("Must give at least 1 file.");
}


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


//------------------------------------------------------------------------------


foreach ($argv as $file_name)
{
	//--------------------------------------------------------------------------

	if (!file_exists($file_name))
	{
		print_error('File ' . escapeshellarg($file_name) . ' does not exist.');
	}

	print_verbose('file_name: ' . escapeshellarg($file_name));

	//--------------------------------------------------------------------------

	$distorted_image_ssim_array = array();

	$fp = fopen($file_name, 'r');

	assert($fp !== false);

	while ($line = fgets($fp))
	{
		assert($line !== false);

		$line = trim($line);

		if (empty($line))
		{
			continue;
		}

		list($distorted_image, $ssim) = explode(',', $line);

		$distorted_image_ssim_array[$distorted_image] = $ssim;
	}

	assert(fclose($fp));

	assert(!empty($distorted_image_ssim_array));

	print_verbose('distorted_image_ssim_array: ' . print_r($distorted_image_ssim_array, true));

	//--------------------------------------------------------------------------

	$distorted_images = array();

	foreach (range($ssim_min, $ssim_max, $ssim_inc) as $ssim)
	{
		$distorted_image = closest_value($distorted_image_ssim_array, $ssim);

		$distorted_images[$distorted_image] = $distorted_image_ssim_array[$distorted_image];
	}

	assert(!empty($distorted_images));

	print_verbose('distorted_images: ' . print_r($distorted_images, true));

	$distorted_images_keys = array_keys($distorted_images);

	print_verbose('distorted_images_keys: ' . print_r($distorted_images_keys, true));

	if ($limit != 0)
	{
		// calling 'count' every iteration is inefficient yet acceptable
		while (count($distorted_images_keys) > $limit)
		{
			array_pop($distorted_images_keys);
		}
	}

	print_verbose('distorted_images_keys: ' . print_r($distorted_images_keys, true));

	print(implode(',', $distorted_images_keys));
	print("\n");
}

?>
