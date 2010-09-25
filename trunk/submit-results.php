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



?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<!--

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

-->

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">

<head>

<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=utf-8" />

<title>Image Quality Assessment Test</title>

<link rel="stylesheet" type="text/css" href="style.css" media="screen" />

</head>

<body>

<div id="div_submit_results">

<h2>Submit Results</h2>

<?php


try
{


//------------------------------------------------------------------------------


//$now = date(DATE_ISO8601);
$now = date('YmdHis');


$LINE_ENDING = "\r\n";


//------------------------------------------------------------------------------



// MAINTAINER: change the email address below
exit("MAINTAINER: change the email address below");
$to = 'results@email.com';


$subject = 'iqatest results ' . $now;


// MAINTAINER: change the email address below
exit("MAINTAINER: change the email address below");
$headers[] = 'From: results@email.com';
//$headers[] = 'Cc: results@email.com';

$headers[] = 'MIME-Version: 1.0';
$headers[] = 'Content-Type: text/plain; charset=ISO-8859-1';
$headers[] = 'X-Mailer: PHP/' . phpversion();
// Note: no need to check if phpversion fails


//------------------------------------------------------------------------------


$user_agent = $_SERVER['HTTP_USER_AGENT'];

$ip_address = $_SERVER['REMOTE_ADDR'] . ':' . $_SERVER['REMOTE_PORT'];

$host_name = gethostbyaddr($_SERVER['REMOTE_ADDR']);

$referer = $_SERVER['HTTP_REFERER'];


//------------------------------------------------------------------------------


if (!isset($_SERVER['HTTP_REFERER']))
{
	throw new Exception('"HTTP_REFERER" key does not exist in $_SERVER.');
}


if (!array_key_exists('results', $_POST))
{
	throw new Exception('"results" key does not exist in $_POST.');
}


$results = stripslashes($_POST['results']);


$results = json_decode($results, true);


//##### TODO: check if json_decode fails


if (!array_key_exists('screen_properties', $results))
{
	throw new Exception('"screen_properties" key does not exist in $results.');
}

if (!array_key_exists('navigator_properties', $results))
{
	throw new Exception('"navigator_properties" key does not exist in $results.');
}

if (!array_key_exists('participant_information', $results))
{
	throw new Exception('"participant_information" key does not exist in $results.');
}

if (!array_key_exists('image_comparison', $results))
{
	throw new Exception('"image_comparison" key does not exist in $results.');
}


//------------------------------------------------------------------------------


$results['image_comparison_sorted'] = array();


foreach ($results['image_comparison'] as $key => $val)
{
	if (!uksort($val, 'strnatcmp'))
	{
		throw new Exception('"uksort" function failed to sort the $val array using "strnatcmp" function.');
	}

	// get the dirname of the key of the first element of the $val array
	// this will be a key in the parent array ($results['image_comparison_sorted'])

	$image_set_path = key($val);

	// this happens when the $val array is empty
	if ($image_set_path == null)
	{
		throw new Exception('"key" function returned null. The $val array is empty.');
	}

	$image_set_path = dirname($image_set_path);

	// this should not happen
	if ($image_set_path == '')
	{
		throw new Exception('$image_set_path is empty.');
	}

	$results['image_comparison_sorted'][$image_set_path] = $val;
}


if (!ksort($results['image_comparison_sorted']))
{
	throw new Exception('"ksort" function failed to sort the "image_comparison_sorted" array.');
}


//------------------------------------------------------------------------------


$results_image_comparison_sorted_csv = 'result,' . $now . "\n";
$results_image_comparison_sorted_csv .= "\n";


//------------------------------------------------------------------------------


foreach ($results['screen_properties'] as $key => $val)
{
	$results_image_comparison_sorted_csv .= $key . ',' . $val . "\n";
}
$results_image_comparison_sorted_csv .= "\n";


//------------------------------------------------------------------------------


foreach ($results['navigator_properties'] as $key => $val)
{
	$results_image_comparison_sorted_csv .= $key . ',' . $val . "\n";
}
$results_image_comparison_sorted_csv .= "\n";


//------------------------------------------------------------------------------


foreach ($results['participant_information'] as $key => $val)
{
	$results_image_comparison_sorted_csv .= $key . ',' . $val . "\n";
}
$results_image_comparison_sorted_csv .= "\n";


//------------------------------------------------------------------------------


foreach ($results['image_comparison_sorted'] as $key => $val)
{
	foreach ($val as $key2 => $val2)
	{
		$results_image_comparison_sorted_csv .= $key2 . ',' . $val2 . "\n";
	}

	$results_image_comparison_sorted_csv .= "\n";
}


//------------------------------------------------------------------------------


$results_exported = var_export($results, true);
// Note: not possible to check if var_export fails


$body = <<<END_RESULTS_EMAIL
<?php

//---------------------------------------------------------------------------

// participant info
// user agent: $user_agent
// ip address: $ip_address
// host name: $host_name

// message info
// referer: $referer
// date-time: $now

//---------------------------------------------------------------------------

\$results[$now] = $results_exported;

?>

#----------------------------------------------------------------------------

cat <<END_RESULTS_FILE > results_${now}.csv
$results_image_comparison_sorted_csv
END_RESULTS_FILE

#----------------------------------------------------------------------------

END_RESULTS_EMAIL;


//------------------------------------------------------------------------------


// send the results

if (!mail($to, $subject, $body, implode($LINE_ENDING, $headers) . $LINE_ENDING))
{
	throw new Exception('"mail" function failed.');
}


print "<p>Your results were submitted.  Thank you for participating</p>\n";


//------------------------------------------------------------------------------


}
catch (Exception $e)
{
	print "<p>There was an error.  Your results were <b>not</b> submitted.</p>\n";
	print "\n";
	print "<blockquote><p>" . $e->getMessage() . "</p></blockquote>\n";
}


//------------------------------------------------------------------------------


?>

<p>The results of this study will be released after December 31, 2010.</p>

<p><a href="image_credits.html">Image Credits</a></p>

<!-- MAINTAINER: change the email address below -->
<p>If you have any questions or concerns, please send an email to <a href="mailto:question@email.com">question@email.com</a></p>

</div>

</body>

</html>
