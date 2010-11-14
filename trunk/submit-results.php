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


// http://pear.php.net/package/Mail_Mime/
require_once 'Mail/mime.php';

require_once 'json_error_to_string.php';


//------------------------------------------------------------------------------


$iqatest_host_name = parse_url($_SERVER['SCRIPT_URI'], PHP_URL_HOST);

$iqatest_url = 'http://' . $iqatest_host_name;


if (!isset($_SERVER['HTTP_REFERER']))
{
	// redirect user agent to main page
	header('Location: ' . $iqatest_url);
	exit;
}


$referer_host_name = parse_url($_SERVER['HTTP_REFERER'], PHP_URL_HOST);


if ($referer_host_name != $iqatest_host_name)
{
	// redirect user agent to main page
	header('Location: ' . $iqatest_url);
	exit;
}


if (!array_key_exists('results', $_POST))
{
	// redirect user agent to main page
	header('Location: ' . $iqatest_url);
	exit;
}


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


$id         = time();
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

EOT;


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


// MAINTAINER: change the email address below
$to = 'results@email.com';

$cc = '';

// MAINTAINER: change the email address below
$from = 'results@email.com';

// MAINTAINER: change the email address below
$reply_to = 'results@email.com';

$subject = 'iqatest results ' . $id;

$body_text = '';
$body_text .= "//------------------------------------------------------------------------------\n\n";
$body_text .= '$_POST = ' . var_export($_POST, true) . ";\n\n";
$body_text .= "//------------------------------------------------------------------------------\n\n";
$body_text .= '$_SERVER = ' . var_export($_SERVER, true) . ";\n\n";
$body_text .= "//------------------------------------------------------------------------------\n\n";

$attachment_name = 'iqatest_results_' . $id . '.php.gz';


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

$mime->addAttachment($results_exported_file_name, 'application/x-gzip', $attachment_name);


//------------------------------------------------------------------------------


// get() must be called before headers()
$body = $mime->get();

// headers() must be called after get()
$headers = $mime->txtHeaders();
//$headers = $mime->headers();


//------------------------------------------------------------------------------


// send the results
if (!mail($to, $subject, $body, $headers))
{
	throw new Exception('"mail" function failed.');
}


// delete the file
if (!unlink($results_exported_file_name))
{
	throw new Exception('"unlink" function failed.');
}


print "<p>Your results were submitted.  Thank you for participating.</p>\n";


//------------------------------------------------------------------------------


}
catch (Exception $e)
{

//------------------------------------------------------------------------------


// MAINTAINER: change the email address below
$to = 'problem@email.com';

$cc = '';

// MAINTAINER: change the email address below
$from = 'problem@email.com';

// MAINTAINER: change the email address below
$reply_to = 'problem@email.com';

$subject = 'iqatest problem ' . $id;

$body_text = '';
$body_text .= "//------------------------------------------------------------------------------\n\n";
$body_text .= '$_POST = ' . var_export($_POST, true) . ";\n\n";
$body_text .= "//------------------------------------------------------------------------------\n\n";
$body_text .= '$_SERVER = ' . var_export($_SERVER, true) . ";\n\n";
$body_text .= "//------------------------------------------------------------------------------\n\n";
$body_text .= '// ' . $e->getMessage() . "\n\n";
$body_text .= "//------------------------------------------------------------------------------\n\n";


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


print "<p>There was an error.  Your results were <b>not</b> submitted.</p>\n";
print "<p>The problem has been reported.</p>\n";
print "\n";
print "<blockquote><p>" . $e->getMessage() . "</p></blockquote>\n";

}


//------------------------------------------------------------------------------

// 874 865 825 765 458 492 530 629 446 370 359 369

?>

<p>The results of this study will be released after December 31, 2010.</p>

<p><a href="image_credits.html">Image Credits</a></p>

<!-- MAINTAINER: change the email address below -->
<p>If you have any questions regarding this research survey, please address them to <a href="mailto:question@email.com">question@email.com</a>.</p>

</div>

</body>

</html>
