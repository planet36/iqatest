<?php

/*

Image Quality Assessment Test
Copyright (C) 2015 Steve Ward

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


// http://pear.php.net/package/Mail_Mime/
require_once('Mail/mime.php');

require_once('json_error_to_string.php');

require_once('submit-results_contact_info.php');

require_once('utime.php');


//------------------------------------------------------------------------------


$iqatest_host_name = parse_url($_SERVER['SCRIPT_URI'], PHP_URL_HOST);

$iqatest_url = 'http://' . $iqatest_host_name;


if (!isset($_SERVER['HTTP_REFERER']))
{
	// Redirect user agent to main page.
	header('Location: ' . $iqatest_url);
	exit;
}


$referer_host_name = parse_url($_SERVER['HTTP_REFERER'], PHP_URL_HOST);


if ($referer_host_name != $iqatest_host_name)
{
	// Redirect user agent to main page.
	header('Location: ' . $iqatest_url);
	exit;
}


if (!array_key_exists('results', $_POST))
{
	// Redirect user agent to main page.
	header('Location: ' . $iqatest_url);
	exit;
}


//------------------------------------------------------------------------------


?>
<!DOCTYPE html>
<!--<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">-->

<!--

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

-->

<html lang="en">
<!--<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">-->

<head>

<meta charset="utf-8">
<!--<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=utf-8" />-->

<title>Image Quality Assessment Test</title>

<link rel="stylesheet" type="text/css" href="style.css" media="screen" />

</head>

<body>

<div id="div_submit_results">

<h1>Image Quality Assessment Test</h1>

<h2>Submit Results</h2>

<?php


try
{


//------------------------------------------------------------------------------


$id         = utime(); // microsecond resolution
$ip_address = $_SERVER['REMOTE_ADDR'];
$host_name  = gethostbyaddr($_SERVER['REMOTE_ADDR']);
$user_agent = $_SERVER['HTTP_USER_AGENT'];


//------------------------------------------------------------------------------


$results = json_decode(stripslashes($_POST['results']), true);

// function 'json_last_error' exists in PHP 5.3.0+
if (function_exists('json_last_error'))
{
	if (json_last_error() != JSON_ERROR_NONE)
	{
		$error = json_error_to_string(json_last_error());

		//throw new Exception('Could not decode results into JSON format.');
		throw new Exception('"json_decode" function failed.  ' . $error . '.');
	}
}


$results['id'        ] = $id        ;
$results['ip_address'] = $ip_address;
$results['host_name' ] = $host_name ;
$results['user_agent'] = $user_agent;


$results_exported = var_export($results, true);
// Note: not possible to check if var_export fails


$results_exported_string = <<<EOT
<?php

\$results_exported = $results_exported;

?>
EOT
;


//------------------------------------------------------------------------------


// compress the string
$results_exported_string_gz = gzencode($results_exported_string);

if ($results_exported_string_gz === false)
{
	throw new Exception('"gzencode" function failed.');
}


// create a file
$results_exported_file_name = tempnam(sys_get_temp_dir(), '');

if ($results_exported_file_name === false)
{
	throw new Exception('"tempnam" function failed.');
}


// write the string to the file
$bytes_written = file_put_contents($results_exported_file_name, $results_exported_string_gz);

if ($bytes_written === false)
{
	throw new Exception('"file_put_contents" function failed.');
}


//------------------------------------------------------------------------------


$subject = 'iqatest results ' . $id;

$tmp1 = var_export($_POST, true);
$tmp2 = var_export($_SERVER, true);

$body_text = <<<EOT
//------------------------------------------------------------------------------

\$_POST = $tmp1;

//------------------------------------------------------------------------------

\$_SERVER = $tmp2;

//------------------------------------------------------------------------------

EOT
;


unset($tmp1);
unset($tmp2);


//------------------------------------------------------------------------------


$mime = new Mail_mime();

// method 'addTo' exists in Mail_Mime-1.8.0+
if (method_exists('Mail_mime', 'addTo'))
{
	$mime->addTo($to);
}

$mime->setFrom($from);

$mime->setSubject($subject);

//$mime->addCc($cc);

$mime->setTxtBody($body_text);
//$mime->setHTMLBody($body_html);

$attachment_name = 'iqatest_results_' . $id . '.php.gz';

$mime->addAttachment(
	$results_exported_file_name,
	'application/x-gzip',
	$attachment_name);

// get() must be called before headers()
$body = $mime->get();

// headers() must be called after get()
$headers = $mime->txtHeaders();
//$headers = $mime->headers();


//------------------------------------------------------------------------------


// Send the results.
if (!mail($to, $subject, $body, $headers))
{
	throw new Exception('"mail" function failed.');
}


// Delete the file.
if (!unlink($results_exported_file_name))
{
	throw new Exception('"unlink" function failed.');
}


print(<<<EOT
<p>Your results were submitted.</p>

<p>Thanks for your participation.</p>
EOT


//------------------------------------------------------------------------------


}
catch (Exception $e)
{

//------------------------------------------------------------------------------


$subject = 'iqatest problem ' . $id;

$tmp1 = var_export($_POST, true);
$tmp2 = var_export($_SERVER, true);
$tmp3 = $e->getMessage();

$body_text = <<<EOT
//------------------------------------------------------------------------------

\$_POST = $tmp1;

//------------------------------------------------------------------------------

\$_SERVER = $tmp2;

//------------------------------------------------------------------------------

// $tmp3

//------------------------------------------------------------------------------

EOT
;


unset($tmp1);
unset($tmp2);
unset($tmp3);


//------------------------------------------------------------------------------


$mime = new Mail_mime();

// method 'addTo' exists in Mail_Mime-1.8.0+
if (method_exists('Mail_mime', 'addTo'))
{
	$mime->addTo($to);
}

$mime->setFrom($from);

$mime->setSubject($subject);

//$mime->addCc($cc);

$mime->setTxtBody($body_text);
//$mime->setHTMLBody($body_html);


//------------------------------------------------------------------------------


// get() must be called before headers()
$body = $mime->get();

// headers() must be called after get()
$headers = $mime->txtHeaders();
//$headers = $mime->headers();


//------------------------------------------------------------------------------


// send the problem
if (!mail($to, $subject, $body, $headers))
{
	throw new Exception('"mail" function failed.');
}


$tmp1 = $e->getMessage();


print(<<<EOT
<p>There was an error.  Your results were <b>not</b> submitted.</p>

<p>The problem has been reported.</p>

<blockquote><p>$tmp1</p></blockquote>
EOT
);


unset($tmp1);


}


//------------------------------------------------------------------------------

?>

<?php include('question_email_message.html'); ?>

</div>

</body>

</html>
