<?php

# SPDX-FileCopyrightText: Steven Ward
# SPDX-License-Identifier: OSL-3.0

// constant 'JSON_ERROR_UTF8' exists in PHP 5.3.3+
if (!defined('JSON_ERROR_UTF8'))
{
	define('JSON_ERROR_UTF8', 5);
}

// convert the json error value to a string
/**
\sa http://php.net/manual/en/function.json-last-error.php
*/
function json_error_to_string($error)
{
	switch ($error)
	{
	case JSON_ERROR_NONE:      return "JSON_ERROR_NONE ($error) No error has occurred"; break;
	case JSON_ERROR_DEPTH:     return "JSON_ERROR_DEPTH ($error) The maximum stack depth has been exceeded"; break;
	case JSON_ERROR_CTRL_CHAR: return "JSON_ERROR_CTRL_CHAR ($error) Control character error, possibly incorrectly encoded"; break;
	case JSON_ERROR_SYNTAX:    return "JSON_ERROR_SYNTAX ($error) Syntax error"; break;
	case JSON_ERROR_UTF8:      return "JSON_ERROR_UTF8 ($error) Malformed UTF-8 characters, possibly incorrectly encoded"; break;
	default:                   return "??? ($error) Unknown error"; break;
	}
}

?>
