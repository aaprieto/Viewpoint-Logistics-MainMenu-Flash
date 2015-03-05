<?php
# @(#)$Id: rd_settings.php,v 1.8 2011/09/28 15:58:24 aprarn Exp $
# vim: set noexpandtab sts=0 sw=8 ts=8:
/*****************************************************************************
	Responsibility Dashboard

	Store session information for use by future PHP scripts.

	Copyright 2008 Maves International Software
	ALL RIGHTS RESERVED
------------------------------------------------------------------------------
Usage:
	rd_settings?sid=SID&u=LOGIN&n=NAME&c=COMPANY

SID	Session ID.  Mandatory.
LOGIN	User's login name (e.g. aprarn).
NAME	User's real name (e.g. Arnold Aprieto)
COMPANY	Company code.

Returns a single line of text, either:
	OK
or
	ERR explanation of what went wrong
*****************************************************************************/

header( 'Content-type: text/plain' );



/* Session ID is mandatory. */
if ( ! array_key_exists( 'sid', $_GET ) ) {
	error_log( 'sid missing' );
	echo 'ERR sid missing';
	exit();
}

/* Assign session ID and start or resume session. */
session_id( $_GET['sid'] );
if ( session_id() != $_GET['sid'] ) {
	error_log( 'could not set PHP session ID' );
	echo 'ERR could not set PHP session ID';
	exit();
}
if ( ! session_start() ) {
	error_log( 'session_start() failed' );
	echo 'ERR session_start() failed';
	exit();
}
 
/* Save other information into session. */

if ( array_key_exists( 'c', $_GET ) ) {
	if	(
		2 == strlen( $_GET['c'] )	&&
		1 == preg_match( '/[A-Z0-9]{2}/', $_GET['c'] )
		)
		$_SESSION['c'] = $_GET['c'];
	else {
		error_log( 'invalid company code given' );
		echo 'ERR invalid company code';
		exit();
	}
}

if ( array_key_exists( 'u', $_GET ) )
	$_SESSION['u'] = $_GET['u'];

if ( array_key_exists( 'n', $_GET ) ) 
	$_SESSION['n'] = $_GET['n'];

if ( array_key_exists( 'cd', $_GET ) )
	$_SESSION['cd'] = $_GET['cd'];

if ( array_key_exists( 'ch', $_GET ) )
	$_SESSION['ch'] = $_GET['ch'];

if ( array_key_exists( 'mh', $_GET ) )
	$_SESSION['mh'] = $_GET['mh'];
if ( array_key_exists( 'subsys', $_GET ) ) 
	$_SESSION['subsys'] = $_GET['subsys'];  

/*  Access Rendition */
if ( array_key_exists( 'ar', $_GET ) ) 
	$_SESSION['ar'] = $_GET['ar'];  

/*  Access Rendition */
if ( array_key_exists( 'av', $_GET ) ) 
	$_SESSION['av'] = $_GET['av'];  


/* Add sc for system code  */
if ( array_key_exists( 'sc', $_GET ) )
	$_SESSION['sc'] = $_GET['sc'];


/*  Action Grid Trigger */

if ( array_key_exists( 'ag', $_GET ) ) 
	$_SESSION['ag'] = $_GET['ag'];  

/* Speed Option Mode */
if ( array_key_exists( 'so', $_GET ) )
	$_SESSION['so'] = $_GET['so'];
	
	
/*  Client Restriction for Client Code */

if ( array_key_exists( 'crcc', $_GET ) ) 
	$_SESSION['crcc'] = $_GET['crcc'];  	
	
	
/* Checks if the application is a "Visible Logistics" or "MyLogistics" */
/*  vl = Visible Logistics, ml=My Logistics */
if ( array_key_exists( 'app', $_GET ) )
	$_SESSION['app'] = $_GET['app'];	
/* Ensure session is saved. */
session_write_close();

echo 'OK';
?>
