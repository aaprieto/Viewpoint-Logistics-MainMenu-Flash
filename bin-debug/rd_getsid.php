<?php
# @(#)$Id: rd_getsid.php,v 1.2 2009/10/15 07:36:58 clamat Exp $
# vim: set noexpandtab sts=0 sw=8 ts=8:
/*****************************************************************************
	Responsibility Dashboard

	Return session ID stored earlier by rd_settings.php.

	Copyright 2008 Maves International Software
	ALL RIGHTS RESERVED
------------------------------------------------------------------------------
Usage:
	rd_getsid.php

Returns a single line of text, either "OK" and a space and the session ID,
or "ERR", a space, and an indication of what went wrong
*****************************************************************************/

header( 'Content-type: text/plain' );

if ( ! session_start() ) {
	error_log( 'session_start() failed' );
	echo 'ERR session_start() failed';
	exit();
}

echo 'OK ' . session_id();
?>
