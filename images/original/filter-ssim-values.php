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

php filter-ssim-values.php --verbose ./red_apple/metrics_jpeg.csv
php filter-ssim-values.php           ./red_apple/metrics_jpeg.csv

php filter-ssim-values.php --verbose $(find -type f -name metrics_jpeg.csv)
php filter-ssim-values.php           $(find -type f -name metrics_jpeg.csv)

php filter-ssim-values.php --verbose --min=0.82 --max=1.00 --inc=0.02 ./{albert_einstein,arnisee_region,bald_eagle,desiccated_sewage,red_apple,sonderho_windmill}/metrics_jpeg.csv
php filter-ssim-values.php           --min=0.82 --max=1.00 --inc=0.02 ./{albert_einstein,arnisee_region,bald_eagle,desiccated_sewage,red_apple,sonderho_windmill}/metrics_jpeg.csv

php filter-ssim-values.php --verbose --min=0.82 --max=0.90 --inc=0.08 ./gizah_pyramids/metrics_jpeg.csv
php filter-ssim-values.php           --min=0.82 --max=0.90 --inc=0.08 ./gizah_pyramids/metrics_jpeg.csv

*/


//------------------------------------------------------------------------------


if (assert_options(ASSERT_BAIL, 1) === false)
{
	exit('"assert_options" function failed.');
}


$script_name = basename(__FILE__);




//##### add print_verbose and print_error functions



//------------------------------------------------------------------------------


function print_usage_message()
{
	global $script_name;

	print "Usage: php $script_name [--version] [--help] [--verbose] --min=MIN --max=MAX --inc=INC METRICS_CSV_FILE ...\n";
	print "Filter the METRICS_CSV_FILE(s) for SSIM values that are closest to the given range.\n";
	print "  --version : Print the version information and exit.\n";
	print "  --help : Print this message and exit.\n";
	print "  --verbose : Print extra output. (default OFF)\n";
	print "  --min=MIN : The minimum SSIM value. (default 0.82)\n";
	print "  --max=MAX : The maximum SSIM value. (default 1.00)\n";
	print "  --inc=INC : The increment of the SSIM values. (default 0.02)\n";
	print "  METRICS_CSV_FILE : A CSV file with the metrics of distorted images. The distorted image is the first field and the SSIM is the second field.\n";
}


//------------------------------------------------------------------------------


// default values

$verbose = false;

$ssim_min = 0.82;
$ssim_max = 1.00;
$ssim_inc = 0.02;


//------------------------------------------------------------------------------


// remove the script name
assert(array_shift($argv) != null);
--$argc;


//------------------------------------------------------------------------------


// http://www.php.net/manual/en/function.getopt.php

$long_options = array('version', 'help', 'verbose', 'min:', 'max:', 'inc:',);

$options = getopt(null, $long_options);

if (isset($options['version'])) {print $script_name . " 2010-08-17\n"; print "Copyright (C) 2011  Steve Ward\n"; exit;}

if (isset($options['help'])) {print_usage_message(); exit;}

if (isset($options['verbose'])) {$verbose = true; assert(array_shift($argv) != null); --$argc;}

if (isset($options['min'])) {$ssim_min = floatval($options['min']); assert(array_shift($argv) != null); --$argc;}
if (isset($options['max'])) {$ssim_max = floatval($options['max']); assert(array_shift($argv) != null); --$argc;}
if (isset($options['inc'])) {$ssim_inc = floatval($options['inc']); assert(array_shift($argv) != null); --$argc;}


//------------------------------------------------------------------------------


//##### use print_error when it's available
if ($ssim_min > $ssim_max)
{
	print "Error: MIN ($ssim_min) must be <= MAX ($ssim_max).\n";
	print_usage_message();
	exit(1);
}

assert($ssim_min <= $ssim_max);


//##### use print_error when it's available
if ($ssim_inc <= 0)
{
	print "Error: INC ($ssim_inc) must be > 0.\n";
	print_usage_message();
	exit(1);
}

assert($ssim_inc > 0);


//##### use print_error when it's available
if ($argc < 1)
{
	print "Error: Must give at least 1 file.\n";
	print_usage_message();
	exit(1);
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
	//print "\n";

	//--------------------------------------------------------------------------

	//##### use print_error when it's available
	if (!file_exists($file_name))
	{
		print 'Error: File ' . escapeshellarg($file_name) . ' does not exist.' . "\n";
		print_usage_message();
		exit(1);
	}

	//##### use print_verbose when it's available
	if ($verbose)
	{
		print 'file_name: ' . escapeshellarg($file_name) . "\n";
		print "\n";
	}

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

	//##### use print_verbose when it's available
	if ($verbose)
	{
		print 'distorted_image_ssim_array: ';
		print_r($distorted_image_ssim_array);
		print "\n";
	}

	//--------------------------------------------------------------------------

	$distorted_images = array();

	foreach (range($ssim_min, $ssim_max, $ssim_inc) as $ssim)
	{
		$distorted_image = closest_value($distorted_image_ssim_array, $ssim);

		$distorted_images[$distorted_image] = $distorted_image_ssim_array[$distorted_image];
	}

	assert(!empty($distorted_images));

	//##### use print_verbose when it's available
	if ($verbose)
	{
		print 'distorted_images: ';
		print_r($distorted_images);
		print "\n";
	}

	//--------------------------------------------------------------------------

	print dirname($file_name) . DIRECTORY_SEPARATOR . '{reference.png,{' . implode(',', array_keys($distorted_images)) . '}}' . "\n";

}


?>
