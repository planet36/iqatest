<?php

# SPDX-FileCopyrightText: Steven Ward
# SPDX-License-Identifier: OSL-3.0

/// return (as a string) the Unix timestamp with microsecond resolution
/**
\sa http://php.net/manual/en/function.gettimeofday.php
\sa http://php.net/manual/en/function.microtime.php
*/
function utime($t = NULL)
{
	if (is_null($t))
	{
		$t = gettimeofday(false);
	}

	return sprintf('%d.%06d', $t['sec'], $t['usec']);
}

?>
