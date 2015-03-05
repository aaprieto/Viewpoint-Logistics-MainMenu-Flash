<?php
# $Id: ae_tlch_xmlreq.php,v 1.9 2013/06/14 18:01:34 clamat Exp $
/*****************************************************************************
	Application Environment -- Communications Hub

	Pass request from Responsibility Dashboard to server and pass
	response back.
 
	Copyright 2009,2010 Maves International Software
	ALL RIGHTS RESERVED  
------------------------------------------------------------------------------
Must be invoked via a POST request.  Request body must be a well-formed
XML document.
*****************************************************************************/
 
/* Response is always an XML document.  Tell the client so. */
header( 'Content-type: application/xml' );
 
/*
 * Normally, the server provides the entire response for the dashboard,
 * but if we can't get far enough through our operation to get that
 * response, we should provide the dashboard a response that it will
 * understand.  This function creates a response that is identical in
 * format to what the server would create for a failed request.
 *
 * We include the empty <refresh_data> element because some client-side
 * code assumes that that element is always present.
 */
function ae_fnmkfailresp( $ae_lvreason ) {
	return	'<?xml version="1.0" encoding="utf-8" ?>'	.
		'<ezware_response>'				.
		'<status>FAIL</status>'				.
		'<refresh_data></refresh_data>'			.
		'<reason>' . $ae_lvreason . '</reason>'		.
		'<version>1</version>'				.
		'</ezware_response>';
}

/*
 * Convenience function to make our error log messages consistent. 
 */
function ae_fnerror_log( $ae_lvmessage ) {
	error_log( 'ae_tlch_xmlreq.php: ' . $ae_lvmessage );
}  

/* Ensure that we were invoked via POST. */
if ( $_SERVER['REQUEST_METHOD'] != 'POST' ) {
	ae_fnerror_log( 'not invoked via POST request' );
	echo ae_fnmkfailresp( 'Internal Client Error' );
	exit();
}

/* Ensure we have monitor connection information. */
if	(
	! array_key_exists( 'MIS_CH_HOST', $_SERVER )	||  
	! array_key_exists( 'MIS_CH_PORT', $_SERVER )	||
	$_SERVER['MIS_CH_HOST'] == ''			||
	$_SERVER['MIS_CH_PORT'] == 0
	) {
		ae_fnerror_log	(
				'"SetEnv MIS_CH_HOST" or '	.
				'related setting missing or '	.
				'invalid in httpd configuration.'
				);
		echo ae_fnmkfailresp( 'Internal Server Error' );
		exit();
}

/* Get remote IP address. */
if ( array_key_exists( 'REMOTE_ADDR', $_SERVER ) ) {
	$ae_lvremote_addr = $_SERVER['REMOTE_ADDR'];
} else {
	$ae_lvremote_addr = 'unknown';
}

/*
 * Mostly, we want to send the request body (an XML document) to the
 * monitor.  We may want to adjust the document before sending it on.  The
 * XML document may be quite large, so we avoid loading the whole document
 * into memory at once; we use the XMLReader and XMLWriter classes to deal
 * with the XML as a stream instead.
 */
$ae_lvxml_r	= new XMLReader();
$ae_lvxml_w_m	= new XMLWriter();	/* Main output. */
$ae_lvxml_w_d	= new XMLWriter();	/* For diversion of some output. */

if ( $ae_lvxml_w_m->openMemory() === false ) {
	ae_fnerror_log( 'main XMLWriter::openMemory() failed' );
	echo ae_fnmkfailresp( 'Internal Server Error' );
	$ae_lvxml_r->close();
	exit();
}

if ( $ae_lvxml_w_d->openMemory() === false ) {
	ae_fnerror_log( 'diversion XMLWriter::openMemory() failed' );
	echo ae_fnmkfailresp( 'Internal Server Error' );
	$ae_lvxml_r->close();
	exit();
}

/* No need to pretty-print the XML we're sending to the monitor. */
$ae_lvxml_w_m->setIndent( false );

/*
 * Start the main output XML document.
 * No need to do this for the diversion writer.
 */
if ( $ae_lvxml_w_m->startDocument( '1.0', 'UTF-8' ) === false ) {
	ae_fnerror_log( 'main XMLWriter::startDocument() failed' );
	echo ae_fnmkfailresp( 'Internal Server Error' );
	$ae_lvxml_r->close();
	exit();
}

/* Initialize various things related to the incoming XML document. */
$ae_lvsend_debug= false;	/* Found debug trigger? */
$ae_lvin_action	= '';		/* Action Code */
$ae_lvin_company= '';		/* Company Code */
$ae_lvin_sid	= '';		/* Session ID */

/* Connect to monitor. */
$ae_lvmonsock=fsockopen	(
			$_SERVER['MIS_CH_HOST'],
			$_SERVER['MIS_CH_PORT'],
			$ae_lvserrno,
			$ae_lvserrstr,
			5
			);
if ( $ae_lvmonsock === false ) {
	ae_fnerror_log	(
			'fsockopen('			.
			$_SERVER['MIS_CH_HOST']	.
			', '				.
			$_SERVER['MIS_CH_PORT']	.
			'): '				.
			$ae_lvserrstr
			);
	echo ae_fnmkfailresp( 'Internal Server Error' );
	$ae_lvxml_r->close();
	exit();
}

/* Send command keyword so monitor knows what's coming. */
$ae_lvwork = fwrite( $ae_lvmonsock, 'MIS_RD_REQUEST/v2/' );
if ( $ae_lvwork === false || $ae_lvwork != 18 ) {
	ae_fnerror_log( 'fwrite keyword to monitor failed' );
	echo ae_fnmkfailresp( 'Internal Server Error' );
	fclose( $ae_lvmonsock );
	exit();
}

/*
 * Tell the XML reader where to find the incoming XML document.
 */
if ( $ae_lvxml_r->open( 'php://input' ) === false ) {
	ae_fnerror_log( 'XMLReader::open failed' );
	echo ae_fnmkfailresp( 'Internal Server Error' );
	fclose( $ae_lvmonsock );
	exit();
}

/* Start out writing to the main writer, not the diversion writer. */
$ae_lvxml_w = &$ae_lvxml_w_m;

/*
 * Copy incoming document to monitor, possibly capturing and diverting
 * some elements of that document along the way.  We don't copy some
 * things (comments, for example) because we know that they're not useful
 * to the server-side code.
 */
while ( $ae_lvxml_r->read() ) {

	switch ( $ae_lvxml_r->nodeType ) {

		/* Element opening tag or empty element tag. */
		case XMLReader::ELEMENT:

			$ae_lvce_name = $ae_lvxml_r->name;

			/* Divert? */
			switch ( $ae_lvxml_r->depth . $ae_lvce_name ) {

				case '1company':
				case '1sid':
					$ae_lvxml_w = &$ae_lvxml_w_d;
					break;
			}

			$ae_lvxml_w->startElement( $ae_lvce_name );

			/* Copy all attributes. */
			if ( $ae_lvxml_r->hasAttributes )
				while ( $ae_lvxml_r->moveToNextAttribute() ) {
					$ae_lvxml_w->writeAttribute	(
							$ae_lvxml_r->name,
							$ae_lvxml_r->value
									);
				}

			/* Element not empty?  Done with this node. */
			if	( ! $ae_lvxml_r->isEmptyElement )	break;

			/* Empty element?  Fall through to the next case. */

		/* 
		 * Element closing tag (or fall-through from above in the
		 * case of an empty element).
		 *
		 * We don't end the root element in the output stream
		 * here because we may need to inject additional elements
		 * into the output stream after this loop.
		 */
		case XMLReader::END_ELEMENT:

			/* Root element? */
			if	( $ae_lvxml_r->depth == 0 )	break;

			/* Not root element.  End element. */
			$ae_lvxml_w->endElement();

			/* Undivert? */
			switch ( $ae_lvxml_r->depth . $ae_lvce_name ) {

				case '1company':
				case '1sid':
					$ae_lvxml_w = &$ae_lvxml_w_m;
					break;
			}

			/* Only send main XML output to monitor. */
			if	( $ae_lvxml_w !== $ae_lvxml_w_m )	break;

			/*
			 * Ask XML writer stream for whatever output
			 * we've created so far.  This also clears the
			 * memory buffer used by the XML writer stream,
			 * preparing for the next chunk we're going to
			 * build.  The main writer may have nothing in
			 * the buffer (e.g., after a diversion), so
			 * skip the socket writes in that case.
			 */
			$ae_lvto_write	= $ae_lvxml_w->outputMemory();
			$ae_lvw_total	= strlen( $ae_lvto_write );
			if	( $ae_lvw_total == 0 )	break;

			/*
			 * Send to monitor.  Loop is because writing to a
			 * network stream (like our socket) may not write
			 * everything all at once.
			 */
			for	(
				$ae_lvw_sofar = 0;
				$ae_lvw_sofar < $ae_lvw_total;
				$ae_lvw_sofar += $ae_lvw_thistime
				) {
				$ae_lvw_thistime = fwrite	(
								$ae_lvmonsock,
					substr( $ae_lvto_write, $ae_lvw_sofar )
								);

				if	( ! $ae_lvw_thistime )	break;
			}

			/* Did a write fail? */
			if ( $ae_lvw_sofar < $ae_lvw_total ) {
				ae_fnerror_log( 'fwrite chunk to monitor failed' );
				echo ae_fnmkfailresp( 'Internal Server Error' );
				fclose( $ae_lvmonsock );
				$ae_lvxml_r->close();
				exit();
			}

			break;

		/* Copy text nodes. */
		case XMLReader::TEXT:

			/* Capture text content of some elements. */
			switch ( $ae_lvxml_r->depth . $ae_lvce_name ) {

				case '2action':
					$ae_lvin_action .= $ae_lvxml_r->value;
					break;

				case '2company':
					$ae_lvin_company .= $ae_lvxml_r->value;
					break;

				case '2sid':
					$ae_lvin_sid .= $ae_lvxml_r->value;
					break;
			}

			/*
			 * Set debug-injection flag for certain requests.
			 *
			 * UNCOMMENT AND ADJUST THE FOLLOWING TO DEBUG THE
			 * SERVER-SIDE refreshData COLLECTION PROCESS IN A
			 * FOREGROUND WORKER PROCESS.
			 */
			/*
			if ( strpos( $ae_lvxml_r->value, ',AEPROFILE' ) )
				$ae_lvsend_debug = true;
			*/

			/* Copy text. */
			$ae_lvxml_w->text( $ae_lvxml_r->value );
			break;

		/* Copy CDATA nodes. */
		case XMLReader::CDATA:
			$ae_lvxml_w->writeCData( $ae_lvxml_r->value );
			break;

		/* Must copy Processing Instruction (PI) nodes. */
		case XMLReader::PI:
			$ae_lvxml_w->writePI	(
						$ae_lvxml_r->name,
						$ae_lvxml_r->value
						);
			break;
	}
}

/* We're finished with the incoming XML document. */
$ae_lvxml_r->close();

/* Make sure we've undiverted back to the main XML writer. */
$ae_lvxml_w = &$ae_lvxml_w_m;

/*
 * Inject company and sid elements, filling in their content if there
 * was no such content in the incoming XML document.  This occurs, for
 * example, when e-Z Learn sends a "run a job" request.
 */
if ( $ae_lvin_action != 'login' ) {

	session_start();

	if ( $ae_lvin_company == '' && array_key_exists( 'c', $_SESSION ) )
		$ae_lvin_company = $_SESSION['c'];

	if	( $ae_lvin_sid == '' )	$ae_lvin_sid = session_id();

	$ae_lvxml_w->writeElement( 'company', $ae_lvin_company );
	$ae_lvxml_w->writeElement( 'sid', $ae_lvin_sid );
}

/*
 * Inject the debug element, if something in the copy loop decided that we
 * need to do that.
 */
if ( $ae_lvsend_debug ) $ae_lvxml_w->writeElement( 'debug', 'true' );

/* Inject remote side IP address. */
$ae_lvxml_w->writeElement( 'remote_address', $ae_lvremote_addr );

/* End the root element and the document. */
$ae_lvxml_w->endElement();
$ae_lvxml_w->endDocument();

/* Send the final chunk of the XML output stream to the monitor. */
$ae_lvto_write	= $ae_lvxml_w->outputMemory();
$ae_lvw_total	= strlen( $ae_lvto_write );

for	(
	$ae_lvw_sofar = 0;
	$ae_lvw_sofar < $ae_lvw_total;
	$ae_lvw_sofar += $ae_lvw_wrote
	) {
	$ae_lvw_wrote = fwrite	(
				$ae_lvmonsock,
				substr( $ae_lvto_write, $ae_lvw_sofar )
				);

	if	( ! $ae_lvw_wrote )	break;
}

if ( $ae_lvw_sofar < $ae_lvw_total ) {
	ae_fnerror_log( 'fwrite trailer to monitor failed' );
	echo ae_fnmkfailresp( 'Internal Server Error' );
	fclose( $ae_lvmonsock );
	exit();
}

/*
 * Get response from monitor.  Response from monitor goes straight out to
 * client, as is.
 */
if ( fpassthru( $ae_lvmonsock ) === false ) {
	ae_fnerror_log( 'fpassthru() from monitor socket failed' );
	echo ae_fnmkfailresp( 'Internal Server Error' );
	exit();
}

/* Be neat and close the socket. */     
fclose( $ae_lvmonsock );
?>
