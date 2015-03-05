<?php
# @(#)$Id: jobmenu.php,v 1.6 2011/09/28 15:58:24 aprarn Exp $
# vim: set noexpandtab sts=0 sw=8 ts=8:
/*****************************************************************************
	Responsibility Dashboard	SubSystem Menu

	PHP script to create wrapper HTML for SubSystem Flash application.

	Copyright 2008,2009 Maves International Software
	ALL RIGHTS RESERVED
*****************************************************************************/

header( 'Content-type: text/html; charset="utf-8"' );

session_start();		/* Load session information. */

/*
 * Build flashvars string from session information.  This only works if
 * the main dashboard has invoked its rd_settings.php and given it the
 * session information.  Put whatever information we've got into the
 * flashvars string; let the Flash application worry about what to do if
 * something's missing or invalid.
 */

$flashvars	=	'historyUrl=history.htm%3f';
$flashvars	.=	'&sid=' . session_id();
/*
* foreach ( array( 'u', 'n', 'c' , 'cd', 'ch', 'sc','mh' ) as $work ) {
*/   
foreach ( array( 'u', 'n', 'ch', 'sc','mh','so' ) as $work ) {
	if ( array_key_exists( $work, $_SESSION ) )
		$flashvars .=	'&' . $work . '=' .
				urlencode( $_SESSION[$work] );
}
if ( array_key_exists( 'c', $_GET ) ) {
	$flashvars .= '&c=' . $_GET['c'];
}
if ( array_key_exists( 'cd', $_GET ) ) {
	$flashvars .= '&cd=' . $_GET['cd'];
}
if ( array_key_exists( 'mb', $_GET ) ) {
	$flashvars .= '&mb=' . $_GET['mb'];
}

if ( array_key_exists( 'subsys', $_GET ) ) {
	$flashvars .= '&subsys=' . $_GET['subsys'];
}
if ( array_key_exists( 'subname', $_GET ) ) {
	$flashvars .= '&subname=' . $_GET['subname'];
}
session_write_close();
?>
<html lang="en">
<head>
<link rel="shortcut icon" href="image/favicon.ico"> 
<title><?php echo $_GET['c']?> <?php echo $_GET['subname'] . " Job Menu"?></title>
<script src="AC_OETags.js" language="javascript"></script>
<style>
body { margin: 0px; overflow:hidden }
</style>
</head>
<body scroll="no">
<script language="JavaScript" type="text/javascript" src="history/history.js"></script>
<script language="JavaScript" type="text/javascript">
<!--
// Version check for the Flash Player that has the ability to start Player
// Product Install (6.0r65)
var hasProductInstall = DetectFlashVer(6, 0, 65);

// MainBoard requires Flash Player 9.0r0 or later.
var hasRequestedVersion = DetectFlashVer(9, 0, 0);

// Check to see if a player with Flash Product Install is available and
// the version does not meet the requirements for playback.
if ( hasProductInstall && !hasRequestedVersion ) {

	// MMdoctitle is the stored document.title value used by the
	// installation process to close the window that started the
	// process.  This is necessary in order to close browser windows
	// that are still utilizing the older version of the player after
	// installation has completed.
	//
        // Location visited after installation is complete if installation
        // is required
	//
	// DO NOT MODIFY THE FOLLOWING FOUR LINES
	var MMPlayerType = (isIE == true) ? "ActiveX" : "PlugIn";
	var MMredirectURL = window.location;
	document.title = document.title.slice(0, 47) + " - Flash Player Installation";
	var MMdoctitle = document.title;

	AC_FL_RunContent(
		"align",		"middle",
		"allowFullScreen",	"true",
		"allowScriptAccess",	"sameDomain",
		"bgcolor",		"#869ca7",
		"flashvars",		"MMredirectURL="+MMredirectURL+'&MMplayerType='+MMPlayerType+'&MMdoctitle='+MMdoctitle+"",
		"height",		"100%",
		"id",			"JobMenu",
		"name",			"JobMenu",
		"pluginspage",		"http://www.adobe.com/go/getflashplayer",
		"quality",		"high",
		"src",			"playerProductInstall",
		"type",			"application/x-shockwave-flash",
		"width", "100%"
	);
} else if (hasRequestedVersion) {

	// If we've detected an acceptable version, embed the Flash
	// Content SWF when all tests are passed.
	AC_FL_RunContent(
		"align",		"middle",
		"allowFullScreen",	"true",
		"allowScriptAccess",	"sameDomain",
		"bgcolor",		"#869ca7",
		"flashvars",		"<?php echo $flashvars; ?>",
		"height",		"100%",
		"id",			"SubSystemssMenu",
		"name",			"SubSystemMenu",
		"pluginspage",		"http://www.adobe.com/go/getflashplayer",
		"quality",		"high",
		"src",			"JobMenu",
		"type",			"application/x-shockwave-flash",
		"width",		"100%"
	);
  } else {  // flash is too old or we can't detect the plugin
    var alternateContent = 'This content requires the Adobe Flash Player. '
   	+ '<a href=http://www.adobe.com/go/getflash/>Get Flash</a>';
    document.write(alternateContent);  // insert non-flash content
  }
// -->
</script>
<noscript>
	<object
		classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
		id="MainBoard" width="100%" height="100%"
		codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">
		<param name="allowFullScreen"	value="true" />
		<param name="allowScriptAccess"	value="sameDomain" />
		<param name="bgcolor"		value="#869ca7" />
		<param name="flashvars"		value="<?php echo $flashvars; ?>" />
		<param name="movie"		value="JobMenu.swf" />
		<param name="quality"		value="high" />
		<embed
			align			="middle"
			allowFullScreen		="true"
			allowScriptAccess	="sameDomain"
			bgcolor			="#869ca7"
			flashvars		="<?php echo $flashvars; ?>"
			height			="100%"
			loop			="false"
			name			="JobMenu"
			play			="true"
			pluginspage		="http://www.adobe.com/go/getflashplayer"
			src			="JobMenu.swf"
			type			="application/x-shockwave-flash"
			quality			="high"
			width			="100%"
			>
		</embed>
	</object>
</noscript>
</body>
</html>
