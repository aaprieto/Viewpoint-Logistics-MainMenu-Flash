/*****************************************************************************
	Application Environment -- Visible Logistics

	Client-side JavaScript for Visible Logistics.

	Copyright 2009 Maves International Software
	ALL RIGHTS RESERVED
------------------------------------------------------------------------------
$Id: ae_slvlcs.js,v 1.4 2010/08/12 07:12:19 clamat Exp $
*****************************************************************************/

/*
 * ae_rtrunjob( code, category )
 *	Ask a Visible Logistics session to run a job.
 *
 *	code	Job code.  Either four characters (system code plus job
 *		number at 2 characters each) or six characters (company
 *		code plus system code plus job number all at 2 characters
 *		each).
 *
 *	category
 *		Job category.  The server uses this to adjust for the
 *		type of job (e.g., operations, administration).
 *
 * Primarily used by e-Z Learn web pages via imagemap <area> tags with
 * targets like href="javascript:ae_rtrunjob("WP11");".  We expect job
 * codes given in this way to be valid the vast majority of the time.
 * We therefore conclude that a (very rare) slight delay waiting for
 * the server to send an "invalid request" message back is much less
 * detrimental to the overall user experience than the cumulative time
 * spent delaying every single "run a job" request by validating the job
 * code in this function.
 */
function ae_rtrunjob( ae_syjobcode, ae_syjobcat ) {

	var ae_lvezw_req=	<ezware_request>
					<action>runJob</action>
					<company></company>
					<jobCategory></jobCategory>
					<sid></sid>
					<systemAndJob></systemAndJob>
					<version>1</version>
				</ezware_request>;

	/*
	 * Fill in request to send to server.
	 *
	 * The client-side pages on which we use this function don't have
	 * access to the VL session's company code, session ID or other
	 * session-related information.  If the job code were were given
	 * is 6 characters long, the first two characters are the company
	 * code and we can use that to fill in the <company> element of
	 * the request.  Otherwise, we leave that element empty and let
	 * the server figure it out.
	 *
	 * The <systemAndJob> element of the request must never include
	 * the company code, so if we were given 6 characters we have to
	 * strip the first two from the value we put into the request.
	 */
	ae_lvezw_req.jobCategory = ae_syjobcat;
	if ( ae_syjobcode.length == 6 ) {
		ae_lvezw_req.company		=ae_syjobcode.substring(0,2);
		ae_lvezw_req.systemAndJob	=ae_syjobcode.substring(2);
	} else {
		ae_lvezw_req.systemAndJob	=ae_syjobcode;
	}

	/* Send request to server and set up to handle response. */
	var ae_lvreqparms =	{
				contentType: "application/xml",
				onFailure: ae_fnrunjob_f,
				onSuccess: ae_fnrunjob_s,
				postBody: ae_lvezw_req.toString()
				};
	var ae_lvreq = new Ajax.Request	(
					"../../../../../vl/dashhome/ae_tlch_xmlreq.php",
					ae_lvreqparms
					);
}

/*
 * ae_fnrunjob_f( ae_syreq )
 *
 *	ae_syreq	The XMLHttpRequest object.
 *
 * Helper for ae_rtrunjob() to notify web page viewer that their request
 * to run a job has failed.  This is invoked if the request failed at the
 * network or HTTP level (browser can't connect to server, server sent
 * back a 404 (not found) or 500 (internal server error) or some-such
 * reponse, etc.).
 */
function ae_fnrunjob_f( ae_syreq ) {

	var ae_lvgrowler = new k.Growler( { width: "260px" } );
	ae_lvgrowler.warn	(
				ae_syreq.status + " " + ae_syreq.statusText,
				{ header: "Job Request Failed" }
				);
}

/*
 * ae_fnrunjob_s( ae_syreq )
 *
 *	ae_syreq	The XMLHttpRequest object.
 *
 * Helper for ae_rtrunjob() to notify web page viewer that their request
 * to run a job has failed.  Our application doesn't report some errors
 * by failing the HTTP request (404 not found, 500 internal server error
 * or the like) but by sending back an XML document as the reponse body.
 * Here, we look inside the reponse body to see if it is such an XML
 * document and if that document contains a "success" indicator.
 */
function ae_fnrunjob_s( ae_syreq ) {

	var	ae_lvgrowler	= new k.Growler( { width: "260px" } ),
		ae_lvmessage	= "invalid server response",
		ae_lvwork,
		ae_lvxmldoc;

	/*
	 * NDY: How to test if there's really an XML document in
	 * ae_syreq.responseXML?
	 */
	ae_lvxmldoc = ae_syreq.responseXML.documentElement;
	ae_lvwork = ae_lvxmldoc.getElementsByTagName("status");
	if ( ae_lvwork.length == 1 && ae_lvwork[0].textContent == "OK" )
		ae_lvmessage = "";
	else {
		ae_lvwork = ae_lvxmldoc.getElementsByTagName("reason");
		if ( ae_lvwork.length == 1 )
			ae_lvmessage = ae_lvwork[0].textContent;
	}

	if ( ae_lvmessage != "" ) {
		ae_lvgrowler.warn	(
					ae_lvmessage,
					{ header: "Job Request Failed" }
					);
	}
}
