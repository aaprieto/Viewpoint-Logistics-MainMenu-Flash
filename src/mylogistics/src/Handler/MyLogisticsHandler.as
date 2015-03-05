// ActionScript file

import com.utilities.Utils;

import flash.events.TimerEvent;
import flash.utils.Timer;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.utils.Base64Encoder;

[Bindable] public var logintype:String = new String;
[Bindable] private var g_ccode:String = new String;
[Bindable] public var g_sid:String = new String;
[Bindable] private var base64np:String = new String;
[Bindable] private var base64pw:String = new String;
[Bindable] private var base64un:String = new String;
[Bindable] private var g_usercode:String = new String;
[Bindable] private var loginStatus:String = new String;
[Bindable] private var company_logo:String;
[Bindable] private var hoverhelp_domain:String;
[Bindable] private var myloghoverhelp_domain:String;
[Bindable] private var myloggettingstartedhoverhelp_domain:String;

[Bindable] private var corporate_name:String;
[Bindable] private var copyright_year:String;
[Bindable] private var logoutstat:String;
[Bindable] private var tdcompany:ArrayCollection = new ArrayCollection;
[Bindable] private var g_username_description:String = new String;
[Bindable] private var g_changed_m_codedescription:String = new String;
[Bindable] public var my_c_code:String;
[Bindable] public var my_pass_url:String;
[Bindable] private var arr_kpimenu:ArrayCollection;
[Bindable] public var hoverstatus:String = 'OFF';

[Bindable] private var login_flag:Boolean = false;


public var app_mylog = 'ml';
private function init():void {
	
	HoverHelpDomain.send();
	ConfigCompanyName.send();
	loginStatus = "";
	
	/* Get Year for copyright */
	var currentDate:Date = new Date();
	copyright_year = currentDate.fullYear.toString();
	
	username.setStyle("backgroundColor","#66FFFF")
	initFocus();			
}


private function doLogin(logtype:String):void {
	title_main.setFocus();
	//password.enabled = false;
	if (login_flag == true){
		return;
	}
	
	
	
	login_flag = true;	
	
	logintype = logtype;
	/*  Remove input background color */
	loseAllFocus();
	
	/* User name and password are both required. */
	
	if ( username.text == '' || password.text == '' ) {
		text1.visible=true;
		loginStatus = 'Error:  Must fill in both User ID and Password.';
		login_flag = false;	
		return;
	}
	
	var encoder:Base64Encoder = new Base64Encoder();
	encoder.encode(password.text);
	base64pw = encoder.toString();
	encoder.reset();
	encoder.encode(username.text);
	g_usercode = username.text;
	base64un = encoder.toString();
	
	/* Initialize loginStatus */
	loginStatus = '';
	
	/* Send login request to the server. */
	//Alert.show(base64pw + ":" + base64un);
	httpLogin.send();
	
	
}	


private function initFocus():void{
	
	username.setFocus();
	
	if (ExternalInterface.available) {
		ExternalInterface.call('setFocusMyLogistics');
	} else {
		AlertMessageShow("Browser not available");
	}
	
	focusManager.setFocus(username);
}
private function userNameClick():void{
	username.setStyle("backgroundColor","#85e7ff")
	password.setStyle("backgroundColor","white")	
	
}
private function userNamefocusout():void{
	username.setStyle("backgroundColor","white")
}
private function passwordClick():void{
	password.setStyle("backgroundColor","#85e7ff")
	username.setStyle("backgroundColor","white")	
}
private function passwordfocusout():void{
	password.setStyle("backgroundColor","white")
}

private function loseAllFocus():void{
	password.setStyle("backgroundColor","white")
	username.setStyle("backgroundColor","white")	
	
}
private function loadSpeedStyles(stylespeedoptions:String):void {
	//Alert.show(stylespeedoptions);
	if (stylespeedoptions == 'basic'){
		//Icons are styles, not properties.
		img_company_logo.source = "";
		img_users.source = "";
		img_eagle.source = "";
		img_lock.source = "";
		
		this.setStyle("backgroundImage","");
		
		// This should be on the last 
//		img_changepassword_1.source = "";
//		img_changepassword_2.source = "";
		//img_cap_ezlearn = "";
		//btn_login.setStyle("icon", 'image/keys_none.png');  
		//btn_login.label = "Log In";
	}
	else if (stylespeedoptions == 'standard'){
		img_company_logo.source = company_logo;
		img_users.source = "image/icon_users_small.png";
		img_eagle.source = "image/blue_eagle.png";
		img_lock.source = "image/password.png";
		
		this.setStyle("backgroundImage","image/Blue3.png");
		
		// This should be on the last 
//		img_changepassword_1.source = "image/password.png";
//		img_changepassword_2.source = "image/password.png";
		
		//btn_login.setStyle("icon", "@Embed('image/keys.png')");  
		//btn_login.label = "Log In";
	}
	
}

// For Anthony's Help Testing. Will remove this later if everything on the e-Z learn has been set-up.
private function eZLearn_for_help():void{
	//http://rhcert.tor.maves.ca/maves/vl/helpdocs/VLHelp/eZLearn_CSH
	//Alert.show(hoverhelp_domain);
	//var urlpass:String = hoverhelp_domain;
	//var urlpass:String = myloghoverhelp_domain
	
	//myloghoverhelp_domain = evt.result.data.mylogdomain;
	var urlpass:String = myloghoverhelp_domain;
	
	//var urlpass:String = 'www.e-zlearn.net/MLSHelp/MLSHelp.htm';
	//var urlpass:String = '../../helpdocs/Output/MLSHelp/MLSHelp.htm';      
		
	//var urlpass:String = "../helpdocs/VLHelp/eZLearn_CSH.htm";
	var jscommand:String = "window.open('" + urlpass + "','win','top=100,left=0,height=775,width=900,toolbar=no,scrollbars=yes');"; 
	//Alert.show(jscommand);
	var url:URLRequest = new URLRequest("javascript:" + jscommand + " void(0);"); 
	//	url.contentType = "text/xhtml; charset=UTF-8";
	navigateToURL(url, "_self");
}


private function eZLearn_getting_started():void{
	//http://rhcert.tor.maves.ca/maves/vl/helpdocs/VLHelp/eZLearn_CSH
	//var urlpass:String = hoverhelp_domain
	//var urlpass:String = "../../helpdocs/Output/VLHelp/eZLearn_CSH.htm#7004";
	
	
	//var urlpass:String = "www.e-zlearn.net/MLSHelp/MLSHelp_CSH.htm#7004";
	var urlpass:String = myloggettingstartedhoverhelp_domain; 
	
	//var urlpass:String = "../helpdocs/VLHelp/eZLearn_CSH.htm";
	var jscommand:String = "window.open('" + urlpass + "','win','top=100,left=0,height=775,width=900,toolbar=no,scrollbars=yes');"; 
	//Alert.show(jscommand);
	var url:URLRequest = new URLRequest("javascript:" + jscommand + " void(0);"); 
	//	url.contentType = "text/xhtml; charset=UTF-8";
	navigateToURL(url, "_self");
}



/*****************************************************************************
 Function to go to the Change Password state.
 *****************************************************************************/

private function goToCPW( initStatus:String ):void {
	
	currentState	= 'changePassword';
	
	newPassword.text	= '';
	newPasswordAgain.text	= '';
	cpwStatus.text		= initStatus;
	
	
	
//	cpwStatus.text		= 'c' 

	/*
	cpwStatus.text = 'Valid password must match the following criteria: \n ' + 
		'\n'+ 
		'- At least 8 characters \n' +
		'- One uppercase letter \n' +
		'- One lowercase letter \n' +
		'- One number';
	*/
		/*
		'- One number \n' + 
		'- One special character (!,@,#,%, etc)';
		*/
		/*
	'Et nisi iucunde me qua consequamur ab ea perspicio differunt. Certum accusatoris sermone viderent partis omni orationem vacillant quo deditum esse. Certe reprehendat esse accommodatior praetermittatur remota homini ea dico alterius vestri magno maxime videmus alterius. Et communitatemque in iudicia esse. Contentionis et eum etiam dicendi. Iudicium viam ipsas habere magnificentius eas quae qui? Vestri ea exquisitaque esse dicitis alterius vivendi itaque quam meditati ipsas directam in ardentius. Esse non diviserunt, et quod voluissent. Quam is est corporis partis retentam? Ingeniis omnes animadverti elucere? Concitatis nisi communiter est animadverteretur et. Maximis aere se vetere societatem et vestri scientiae communitatemque quam libertatemque dixerim generis adiuvet iustituiam. ' +  
			'Altera natosque in insitam criminibus esse. Eas viam tanti seditiose hanc mihi facere communis melius criminibus maximis vehementer, quem meliorem apti. Quam pars summis invidiosum videtur condemnatus brevis temperantiam et in qua, praeclaram agendo in. Mihi alter ea quae beate, in natos voluisse servare simplicem in modo bonum esse? Altera nisi altera fuisse eandem honeste divisam invidiae nec sit dolore neque consuetudinis esse. Non natos et in inter re certum. Moderatisque ad esse etiam quosdam mihi initio illud quam et constituta nisi. Videmus vitam voluptatibus cum causa contentionis constituta partes ut, partitionem, modo honeste alter nec quae. Similes voluissent confidere esse vos, esse vim iudicia qui in quam honeste quaestionis summum virtutes. Partes enim criminibus nec. Dicendo in essemus, ut iusteque elucere me, molestia quam et nihil, is itaque illustresque mandaremus distributionem. Condicionem fuisse non non, aere agendo altera. ' +  
				'Nos veneficii opere eiusdem possit esse quam et timendum! Vacillant tractavissent et vetere iucunde is nos exquisitaque nihil in reprehendat miseram tractatione brevis propria et et differunt. Ad modo animi homini partes diffidenter. Partes sic iudicium si notae timide quam non quaestio vivi contionibus esse non facere apti tum! Maxime iustituiam apti est maturius vitam administrandae voluissent easque scientiae philosophi et accusatoris eandem retentam? In ut fore omnem, moderatisque quarum animadverti perspicio, modo meliorem et orationem? Elucere quod altera et mihi. ' + 
					'Tractatione virtutes etiam similes appetere debet. Illustresque vacare remota quae exquisitaque! Quosdam considero etiam in. Pars altera mihi, obscurare, diviserunt, partes eandem, et ea accusatores confidere. Criminum inveterata meditati cum confidere quo differunt. Argumento concitatis nos directam habitura voluptatibus communiter invidiae cum artium doctrina contentionis consuetudinis esse. Maxime communis est sortito lege videtisne magnae proprium quem et iudices. Est constituta iudicium veneficii quo maxime in opere esse eaque quantum ut et. Vacare eandem esse dicendo iucunde iuste adiuvet, retentam alieno animadverti re haec partes laboris orationem! Iam lege ardentius utraque non haec maximis argumento non ad voluissent quo? Honeste non criminibus tranquillis, de accommodatior altera, orationem administrandae esse! Sua quam concitatis tranquillis constituta animi. ' +  
						'Videtur iudicia artium directam cum maturius. Eiusdem scientiae vetere mihi appetere ea, differunt id certum tractavissent condicionem ipsi accusatoris contentionis in. In nec intellegant ab quo accusatoris generis Iuniani autem, procul ego exquisitaque causa est iudicium. Sic ad tum altera sumptibus modo ardentius. Omnes in ut et. Consequamur timide dicendo altera est modo sunt modo videmus! Moderatisque et partes altera perspicio! Et societatem ad invidia facere mihi voluptatibus ardentius vivendi. Habitura est defensione, diviserunt difficultatis sapienter nos doctrina praetermittatur et perspicio easque causa quae vivendi ab veneficii sumptibus. Certum etiam illustresque nec quosdam diviserunt vos altera lege partem hanc, ut exquisitaque lege ea ingeniis? Et certe certum scientiae. Voluissent criminum quo etiam ipsas eaque videmus.';
	*/
	
	cpwChangeButton.visible	= true;
	cpwCancelButton.visible	= true;
	cpwOKButton.visible	= false;
	
	if ( username.text == '' )
		username.setFocus();
	else
		if ( password.text == '' )
			password.setFocus();
		else
			newPassword.setFocus();
	
}
/*****************************************************************************
 Function to cancel from the Change Password state.
 *****************************************************************************/

private function cpwCancel():void {
	// do lougout first
	//doLogout();
	btn_login.visible = true;
	text1.visible=false;
	pbar.visible=false;
	loginStatus	= '';
	currentState	= '';
	
	if ( username.text == '' )
		username.setFocus();
	else
		password.setFocus();
	
}
/*****************************************************************************
 Function to submit the Change Password request.
 *****************************************************************************/

private function cpwChange():void {
	// do lougout first
	//doLogout();
	/* Do we have all necessary information? */
	if	(
		username.text == ''
		||
		password.text == ''
		||
		newPassword.text == ''
		||
		newPasswordAgain.text == ''
	) {
		cpwStatus.text ="The password was not changed.  Reason:"+
			"\n\n"					+
			"Not enough information was given.\n"	+
			"All values are required; please fill "	+
			"in all fields.";
		return;
	}
	
	/*
	* NDY:  Use events to enable the "Change" button only when
	* both new password fields are not empty and match each other?
	*/
	if ( newPassword.text != newPasswordAgain.text ) {
		cpwStatus.text ="The password was not changed.  Reason:"+
			"\n\n"					+
			"The new passwords do not match.  "	+
			"Please re-enter them.";
		return;
	}
	
	/*
	* Tell operator that we're processing the request.
	* NDY:  Disable "Change" and "Cancel" buttons while processing?
	*/
	cpwStatus.text		= "Processing ...\n";
	
	/*
	* Encode user ID and passwords.  These really should go in CDATA
	* sections in the XML document that we send, but the server-side
	* doesn't know how to handle CDATA sections yet, so we make these
	* values safe by base64-encoding them for now.
	*/
	var encoder:Base64Encoder = new Base64Encoder();
	encoder.encode(newPassword.text);
	base64np = encoder.toString();
	encoder.reset();
	encoder.encode(password.text);
	base64pw = encoder.toString();
	encoder.reset();
	encoder.encode(username.text);
	g_usercode = username.text;
	base64un = encoder.toString();
	
	/*
	* Build "Change Password" request.  This is actually a login
	* request with both current and new passwords included.
	*/
	logintype = 'conf_cp';
	httpCPW.request =	<ezware_request>
					<action>login</action>
					<newpass>{base64np}</newpass>
					<password>{base64pw}</password>
					<user>{base64un}</user>
					<version>1</version>
				</ezware_request>;
	
	/* Send request. */
	httpCPW.send();
}


/*****************************************************************************
 Functions to handle the "httpCPW" HTTPService results.
 *****************************************************************************/

private function cpwResultHandler(event:ResultEvent):void {
	
	/*
	* Did the request fail?  If so, expect the server to send us a
	* complete status message explaining why in the "reason" element
	* of the result.
	*/
	
	
	
	if ( event.result.status != 'OK' ) {
		cpwStatus.text = event.result.reason.toString();
		return;
	}
	
	/* Password changed and session login accepted by server. */
	cpwStatus.text		= "The password was changed.";
	cpwChangeButton.visible	= false;
	cpwCancelButton.visible = false;
	cpwOKButton.visible	= true;
	newPassword.enabled = false;
	newPasswordAgain.enabled = false;
	password.text = newPassword.text;
	/* Get the session ID from the result. */
	// No more session id
	g_sid		=event.result.sid;
}

private function cpwFaultHandler(event:FaultEvent):void {
	
	cpwStatus.text=	"The password was not changed.  Reason:"	+
		"\n\n"						+
		"Problem communicating with server.\n"		+
		event.message.toString();
}
/*****************************************************************************
 Handle a "cpwOKButton" Button Click Event
 
 This button is normally hidden.  It is made visible in cpwResultHandler()
 when a password change request is successful.  On the server side, a
 successful password request is also a successful login request, so when
 this button is pressed we must complete our client-side login sequence.
 The cpwResultHandler() function set "g_sid" for us.
 *****************************************************************************/

private function cpwOK():void {
	// do special logout
	specialhttpLogout.send();
	/*
	* Show the operator that we're logging in.  At the moment, this
	* has to be done on the base state.
	*/
	loginStatus		= 'Starting session ...'; 
	pbar.visible	= true;
	text1.visible	= true; 
//	currentState		= '';
	
	password.text = newPassword.text;
	doLogin('rl');
	/* Trigger browser to start WindX. */
//	var urWindX:URLRequest = new URLRequest();
//	urWindX.url="ae_tlstartwindx.php?sid="+g_sid;
//	navigateToURL( urWindX, '_blank' );
	
	/* Start AreYouThere timer. */
//	aytTime.start();
	
	/* Ask server for operator profile. */
	//companyCode.send()
	//currentState	='main_dashhome';
}


private function doLogout():void {
	
	/*
	* Send logout message to server.  Let the result handler do the
	* rest.
	*/
	httpLogout.send();
	

}
private function finishLogout():void {
	
//	g_ccode		='';
	g_sid		='';
	
//	aytTime.reset();
	
	if (logoutstat != "Y"){
		loginStatus	='';
		if (logintype == 'rl'){
		logoutFunction();
		}
	}
	logoutstat = "";
}

private function specialfinishLogout():void {
	
	//	g_ccode		='';
	g_sid		='';
	
	//	aytTime.reset();
	
	if (logoutstat != "Y"){
		loginStatus	='';
		
	}
	logoutstat = "";
}   
private function logoutFunction():void{
	navigateToURL(new URLRequest('../dashhome/mylogistics.html'), '_self')
}
private function hoverHelpSwitch():void{
	if (hoverstatus == 'OFF'){
		hoverstatus = 'ON';
	} else {
		hoverstatus = 'OFF';
	}
	
	
	
/*	
	if (mousehoverparslabel == "OFF")
	{
		mbdg_objecttitle = object_id;
		mbdg_objecttitleheader =  object_type;
		mbdg_objecthelpfortitle = object_title;
		mbdg_PopEZLearn(event);
		
	}
	else
		//if (mousehoverparslabel = "ON")
	{
		//popezlearnmenu.hoverswitch.label = "ON";
		mousehoverpars = "NO";
		mousehoverparslabel = "OFF"
	}
	
*/	
	
	
	
	
	
	
}

[Embed(source='image/Question_Mark_Orb_175.png')]
private var confirmIcon:Class;
private function alertListener():void {
	
	Alert.okLabel = "Log-out";
	Alert.buttonWidth = 140;
	
	// instantiate the Alert box
	var a:Alert = Alert.show(
		"Are you sure you want to navigate away from this page?\n"  +
		"Leaving this page will cause you to lose any unsaved data (related tabs and windows should be closed first).\n"  +
		"Press Log-out or Cancel to stay on the current page.\n",
		"Confirmation of Log-out",
		Alert.OK|Alert.CANCEL,
		this, 
		confirmHandler,
		confirmIcon,
		Alert.CANCEL
	);
	
	// modify the look of the Alert box
	a.setStyle("backgroundColor", '#C3D9FA');
	a.setStyle("borderColor", 0xffffff);
	a.setStyle("borderAlpha", 0.75);
	a.setStyle("fontSize", 14); 
	a.setStyle("fontWeight", "bold");
	a.setStyle("color", 0x000000); // text color
}
private function confirmHandler(event:CloseEvent):void {
	
	if (event.detail == Alert.OK) {
		// what to do if user selected "yes"
		doLogout();
	} 
	/*
	else if (event.detail == Alert.NO) {
	// what to do if user selected "no"
	result.text = “No”;
	}
	*/
}
private function rdSet(event:ResultEvent):void {
	
 
 if (event.result == 'OK'){
 my_pass_url = "REFRESH,RETRIEVE|JOB_ML|" + username.text+ "|10|";
 	httpp_kpi_srv.send();
	}
 if (event.result == 'EXPIRED'){
 
 	AlertMessageShow("Session expired due to inactivity");
	return;
 	 
 }
 
}