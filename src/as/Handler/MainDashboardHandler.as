/*****************************************************************************
	Visible Logistics

	Actionscript for login page, change password page and systems menu.

	Copyright 2009,2010 Maves International Software
	ALL RIGHTS RESERVED
------------------------------------------------------------------------------
$Id: MainDashboardHandler.as,v 1.20.2.5 2012/11/28 20:19:21 aprarn Exp $
*****************************************************************************/

import com.utilities.Utils;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.net.URLRequest;
import flash.utils.Timer;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.events.ListEvent;
import mx.utils.Base64Encoder;


[Bindable] private var base64np:String = new String;
[Bindable] private var base64pw:String = new String;
[Bindable] private var base64un:String = new String;
[Bindable] private var tdcompany:ArrayCollection;
[Bindable] private var arr_kpimenu:ArrayCollection;
[Bindable] private var arr_shortcutmenu:ArrayCollection;
[Bindable] private var arrprofile:ArrayCollection;
[Bindable] private var loginStatus:String = new String;
[Bindable] public var logintype:String = new String;
// Declares low if the screen resolution is less than 1260 x 800
[Bindable] private var resolutionflag:String = new String;
[Bindable] public var hoverstatus:String = 'OFF';

[Bindable] private var MyShortcutCollectionMain:ArrayCollection;
/*
 * For action command (run a job) requests.
 *
 *	reqSJ: system code and job number of job to run
 *	example: for job RF.01, this would be "RF01"
 *
 *	reqParms: parameters for job and/or parameters
 *	identifying what refresh data the server is
 *	expected to send back when the job is finished
 */
[Bindable] private var reqSJ:String = new String;
[Bindable] private var reqParms:String = new String;
[Bindable] private var reqParms_treeview:String = new String;
[Bindable] public var jobCodes_status:String = 'ON';

/*
 * Session information:
 *	g_sid	Session ID (server-assigned)
 *	--  g_ccode	Company Code  (not for now)
 *  g_username_description   User Description name + lastname
 *  g_changed_m_code    Company Code
 *  username.text  Username
 */ 
[Bindable] private var g_ccode:String = new String;
[Bindable] public var g_sid:String = new String;
[Bindable] private var windx_port:String = new String;
[Bindable] private var g_username_description:String = new String;
[Bindable] public var g_changed_m_code:String = new String;
[Bindable] private var g_changed_m_codedescription:String = new String;
[Bindable] private var g_tabset:String = new String;
[Bindable] private var g_permanenttabset:int = 0;
[Bindable] private var g_usercode:String = new String;
[Bindable] private var g_fillcolor:String = new String;
[Bindable] private var hoverhelp_domain:String;
[Bindable] private var company_logo:String;
[Bindable] private var logoutstat:String;
[Bindable] private var copyright_year:String;

[Bindable] private var g_syscode:String;
[Bindable] private var g_subsyscode:String;

[Bindable] private var login_flag:Boolean = false;


public var app_mylog = 'vl';
/* AYT (Are You There) timer to fire every 45 seconds. */
private var aytTime:Timer = new Timer(45000);

/* Initialize class Utils from com.utilities.  
	aaprieto - just in case there are trailing spaces in the username.
*/
public var c_utils:Utils = new Utils();
public var pu_menu:String = new String();
public function mytest(S:String):void{
	Alert.show(S);
}
[Bindable]
public var trigger_event:String = new String();
private function drillback(event:Event):void{
	
	trigger_event = 'tree'
	if (btn_breadcrumb.label == "Home"){
		system_text.text = "Systems";
		changecode();
	} else if (btn_breadcrumb.label == "Systems"){
		
	changeAccordionheader(event);
	   
	btn_breadcrumb.label = "Home";
	system_text.text = "Systems";
	    
	} else if (btn_breadcrumb.label == "SubSystems"){
		RetrieveSubSystemMenu(g_syscode);
	}
	
	
	     
	
}


private function tree_labelFunc(item:XML):String {
	
	var children:ICollectionView;
	var suffix:String = "";
	if (XMLtreeoperator.dataDescriptor.isBranch(item)) {
		children = XMLtreeoperator.dataDescriptor.getChildren(item);
		suffix = " (" + children.length + ")";
	}
	return XMLtreeoperator[XMLtreeoperator.labelField] + suffix;
}




private function MyFavoritesClickhandler(e:ListEvent):void{
	var item:Object = Tree(e.currentTarget).selectedItem;
	if (XMLmyfavorites.dataDescriptor.isBranch(item)) {
		XMLmyfavorites.expandItem(item, !XMLmyfavorites.isItemOpen(item), true);
	}

	trigger_event = 'tree';
	
	if ((e.itemRenderer.data.@menu == "subsystem")||(e.itemRenderer.data.@menu == "group")){
		
		if (e.itemRenderer.data.@menu == "group"){
			system_text.text = e.itemRenderer.data.@subsys_cd;	
			RetrieveMyFavoriteJobMenu(e.itemRenderer.data.@subsys_cd);
		} else {
			system_text.text = e.itemRenderer.data.@code;
		RetrieveMyFavoriteJobMenu(e.itemRenderer.data.@code);
		}
		pu_menu = "job";
		
	} else if(e.itemRenderer.data.@menu == "job"){
		system_text.text = e.itemRenderer.data.@subsys_cd;
		var jobid:String = new String;
		jobid = (e.itemRenderer.data.@job_id).toString();
		
		
		if (jobid.length == 1){
			
				if (e.itemRenderer.data.@job_program == 'NETVIEW'){
					runNetView.send();
				} else { 
					
				if ((e.itemRenderer.data.@job_program).substr(0,1) == 'e'){
					
					
					var short_jobprog:String = e.itemRenderer.data.@job_program;
					
					
					var sub_custombtn_jobprogram:String = 	short_jobprog.substr(1,short_jobprog.length);
					var jscommand:String = "window.open('" + sub_custombtn_jobprogram + "','win','top=100,left=0,height=905,width=1200,toolbar=no,scrollbars=yes');";
					var url:URLRequest = new URLRequest("javascript:" + jscommand + " void(0);");   
					
					navigateToURL(url, "_self");
					
					
				} else {
					
					
					
					
					/*  
					Alert.show("check 1");
					Alert.show(e.itemRenderer.data.@job_program+ '&c='+ g_changed_m_code + '&cd='+ g_changed_m_codedescription);
					Alert.show("check 2");
					*/
					//  Remove for now for testing
					navigateToURL(new URLRequest(e.itemRenderer.data.@job_program+ '&c='+ g_changed_m_code + '&cd='+ g_changed_m_codedescription),'_blank');
					//navigateToURL(new URLRequest("../mainboard/mainboard.php?mb=*_123Test"+'@'+g_changed_m_code + '@' + g_usercode + '&c='+ g_changed_m_code + '&cd='+ g_changed_m_codedescription),'_blank');
				
				
				}
				         
				
			}	
		}
		if (jobid.length > 1){ 
			var bol_flag:Boolean = false;
			if (jobid.length > 3){
				var temp:String = new String;
				temp = jobid.substr(jobid.length -4);
				
				if (temp == "[AG]" || temp == "[CR]" || temp == "[CH]" ){
					// -5 includes the space between jobid and type.
				    var prog:String =  "*_" + jobid.substr(0, jobid.length -5) + '@'+g_changed_m_code + '@' + g_usercode;
					
					navigateToURL(new URLRequest("../mainboard/mainboard.php?mb=" + prog + '&c='+ g_changed_m_code + '&cd='+ g_changed_m_codedescription + '&scc=' + e.itemRenderer.data.@job_viewcode)  ,'_blank');
					
					
					
					bol_flag = true;
				} 
			}
			 
			if  (bol_flag == false){  
				ht_jobcode = e.itemRenderer.data.@job_id;
				navigateJobProgram.send();
			}
		}
		 
		
		
		
	}
}




private function itemClickHandler(e:ListEvent, obj_id:String):void
{
	
	if (obj_id == 'oper'){
		var item:Object = Tree(e.currentTarget).selectedItem;
		if (XMLtreeoperator.dataDescriptor.isBranch(item)) {
			XMLtreeoperator.expandItem(item, !XMLtreeoperator.isItemOpen(item), true);
		}
	}
	if (obj_id == 'admin'){
		var item:Object = Tree(e.currentTarget).selectedItem;
		if (XMLtreeadministrator.dataDescriptor.isBranch(item)) {
			XMLtreeadministrator.expandItem(item, !XMLtreeadministrator.isItemOpen(item), true);
		}
		
	}	 
	
	trigger_event = 'tree';
	         
	if (e.itemRenderer.data.@menu == "system"){
		RetrieveSubSystemMenu(e.itemRenderer.data.@code);
		pu_menu = "subsystem";
		
		
	} else if (e.itemRenderer.data.@menu == "subsystem"){
		//RetrieveJobMenu(e.itemRenderer.data.@syscode, e.itemRenderer.data.@code, e.itemRenderer.data.@name);
		RetrieveJobMenu(e.itemRenderer.data.@syscode, e.itemRenderer.data.@code);
		pu_menu = "job";
		
	} else if (e.itemRenderer.data.@menu == "job"){
		
				var jobid:String = new String;
				jobid = (e.itemRenderer.data.@job_id).toString();
				
				
				
						if (jobid.length == 1){
							
							if (e.itemRenderer.data.@job_program == 'NETVIEW'){
								runNetView.send();
							} else {
							
								
								
								if ((e.itemRenderer.data.@job_program).substr(0,1) == 'e'){
									
									
									var short_jobprog:String = e.itemRenderer.data.@job_program;
									
									
									var sub_custombtn_jobprogram:String = 	short_jobprog.substr(1,short_jobprog.length);
									var jscommand:String = "window.open('" + sub_custombtn_jobprogram + "','win','top=100,left=0,height=905,width=1200,toolbar=no,scrollbars=yes');";
									var url:URLRequest = new URLRequest("javascript:" + jscommand + " void(0);");   
									
									navigateToURL(url, "_self");
									 
									
								} else {
									navigateToURL(new URLRequest(e.itemRenderer.data.@job_program+ '&c='+ g_changed_m_code + '&cd='+ g_changed_m_codedescription),'_blank');
								}
								
							
							}	
						}
						if (jobid.length > 1){ 
							ht_jobcode = e.itemRenderer.data.@job_id;
							navigateJobProgram.send();
						}
				
				
				
				
	}
}  



public function RetrieveSubSystemMenu(sysc:String):void{  
	var flag:Boolean = false
	
	if(trigger_event == 'chicklets'){
			flag = SystemSearchRel(ChainCombo.selectedItem.id, sysc);
	}
		if (flag != true){
		
			g_syscode = sysc;
			
			system_text.text = g_syscode.substr(2,g_syscode.length) + " - SubSystems";
			
			pu_menu = "subsystem";
			reqParms = "REFRESH,RETRIEVE|SUBSYSTEM|" + g_usercode + "|" + g_changed_m_code  + "|" + ChainCombo.selectedItem.id +"|" + sysc +"|";
			getsubsystem.send();  
		}
	
}
//public function RetrieveJobMenu(sysc:String, subsysc:String, subsysdesc:String):void{ 
public function RetrieveJobMenu(sysc:String, subsysc:String):void{ 	
	var flag:Boolean = false
	if(trigger_event == 'chicklets'){
		flag = SubSystemSearchRel(ChainCombo.selectedItem.id,  subsysc, sysc);
	}
	
	if (flag != true){
		g_syscode = sysc;
		g_subsyscode = subsysc;
		
		
		system_text.text = g_changed_m_code + " " + g_syscode.substr(2,g_syscode.length) + " " + g_subsyscode.substr(2,g_subsyscode.length)  + " Job Menu";
		
		pu_menu = "job";
		
		reqParms = "REFRESH,RETRIEVE|JOB|" + g_usercode + 
			//"|" +  g_ccode + 
			"|" +  g_changed_m_code +  
			"|" + ChainCombo.selectedItem.id + 
			"|" + sysc +
			"|" + subsysc + "|";
		getjob.send();
		btn_breadcrumb.label = "SubSystems";
		
	}
	/*
	var flag:Boolean = false
	if(trigger_event == 'chicklets'){
		flag = SubSystemSearchRel(ChainCombo.selectedItem.id,  subsysc, sysc);
	} 
	
	if (flag != true){
			g_syscode = sysc;
			g_subsyscode = subsysc;
			
			
			system_text.text = g_syscode.substr(2,g_syscode.length) + " - " + subsysdesc  + " - Job Menu";
			
			pu_menu = "job";
		
		reqParms = "REFRESH,RETRIEVE|JOB|" + g_usercode +  
			"|" +  g_changed_m_code + 
			"|" + ChainCombo.selectedItem.id + 
			"|" + sysc +
			"|" + subsysc + "|";
			getjob.send();
			btn_breadcrumb.label = "SubSystems";
	
	}
	*/
}	


public function RetrieveMyFavoriteJobMenu(code:String):void{ 
	
	pu_menu = "job";
		reqParms = "REFRESH,RETRIEVE|MYFAVORITEJOBS|" + g_usercode +
			"|" +  g_changed_m_code + 
			"|" + code + "|";
		
		getjob.send();
		btn_breadcrumb.label = "Home";
	
}	


public function opentab():void {

var urlRequest:URLRequest = new URLRequest('http://www.adobe.com/');
navigateToURL(urlRequest,'about:blank');

}  



import flash.external.ExternalInterface;
import mx.managers.PopUpManager;
import mx.managers.BrowserManager;
import mx.managers.IBrowserManager;

private const UNSAVED_DATA_WARNING:String = 'You have unsaved changes. You will lose them if you continue.';
[Bindable] private var commitRequired:Boolean;



private function init():void {
	
	
	
	
	
	aytTime.addEventListener(
		TimerEvent.TIMER,
		sendAYT
	);
	HoverHelpDomain.send();
	loginStatus = "";
	/* Get Year for copyright */
	var currentDate:Date = new Date();
	copyright_year = currentDate.fullYear.toString();
	
	
	username.setStyle("backgroundColor","#66FFFF");
	
	bm = BrowserManager.getInstance();
	bm.init("","MAVES ViewPoint Logistics");
	
	initFocus();			
}

private function initFocus():void{
					
	username.setFocus();

	if (ExternalInterface.available) {
		ExternalInterface.call('setFocus');
	} else {
		AlertMessageShow("Browser not available");
	}

	focusManager.setFocus(username);
}

private function finishLogout():void {

	g_changed_m_code		='';
	g_sid		='';
	
	aytTime.reset();
	
	if (logoutstat != "Y"){
		loginStatus	='';
		
		if (logintype == 'rl'){
			logoutFunction();
		}
	}
	login_flag = false;
	logoutstat = "";
}

private function logoutFunction():void{
	navigateToURL(new URLRequest('../dashhome/wc_maindashboard.html'), '_self')
}

private function pickWin():void {
	currentState='PickPage';
}

private function receiveWin():void {
	currentState='ReceivePage';
}

private function moveWin():void {
	currentState='MovePage';
}

private function queryWin():void {
	currentState='QueryPage';
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
 
	
	
	
 	/* Login to Arboretum */
		
		/* Requested by tim to be removed first */
	
 	   // ArboretumLogin.url = "https://www.diditinc.com/maves/Login.php?user_name=" + username.text + "&user_pass=" + password.text;
       // ArboretumLogin.send();
		 
	/*
	 * User name and password end up as the content of an XML element.
	 * Encode them both so we don't run into trouble if they contain
	 * characters that would normally be problematic in such a place,
	 * such as "&".  We should put both of these items into CDATA
	 * elements, but the server-side code currently isn't capable of
	 * properly parsing those.
	 */ 
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
	
	httpLogin.send();
}

[Embed(source='image/Lightning3.png')]
private var shazamIcon:Class;


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
		doLogout()
	} 
	/*
	else if (event.detail == Alert.NO) {
		// what to do if user selected "no"
		result.text = “No”;
	}
	*/
}

private function doLogout():void {

	/*
	 * Send logout message to server.  Let the result handler do the
	 * rest.
	 */
	httpLogout.send();
}

private function sendAYT(event:TimerEvent):void {
	//Alert.show('ayt');
	httpAYT.send();
}

private function runJob(sysAndJob:String,parms:String):void {
	reqSJ	= sysAndJob;
	
	reqParms= parms;
	httpRunJob.send();

	/*
	 * The above request will reset the server's dead session
	 * detection timer, so we reset our own AYT timer here too.
	 */

	aytTime.stop();
	aytTime.start();
}


private function changeJobCodeStatus():void{
	if (jobCodes_status == 'OFF'){
		jobCodes_status = 'ON';
		
		
		
		
	} else {
		jobCodes_status = 'OFF'
		
	}
	
	
	system_text.text = "Systems";
	btn_breadcrumb.label = "Home";
	changecode();
	
} 

private function pre_change_companycode():void{
	g_tabset = "0";
	changecode();
	jobcode.text = '';
	jobcode.setFocus();
}
public function changecode():void{
	system_text.text = "Systems";
	g_changed_m_code = company_code.selectedItem.company;
	g_changed_m_codedescription = company_code.selectedItem.company_desc;

	passGlobalVariable();
	
} 

public function passGlobalVariable():void{

	g_changed_m_code = company_code.selectedItem.company;
	g_changed_m_codedescription = company_code.selectedItem.company_desc;
	httpGlobalVariable.url = "rd_settings.php?sid=" + g_sid + "&u=" + g_usercode + "&n=" + g_username_description + "&c=" + g_changed_m_code + "&cd=" + g_changed_m_codedescription + "&mh=NO";
	httpGlobalVariable.send();
}

public function passChainGlobalVariable():void{

	httpChainGlobalVariable.url = "rd_settings.php?sid=" + g_sid + "&ch=" + ChainCombo.selectedItem.id;	 
	httpChainGlobalVariable.send();
}  
  private function runNetViewHandler(event:ResultEvent):void {
			if (event.result.ezware_response.status == 'OK'){
				navigateToURL(new URLRequest('../../nv/' + event.result.ezware_response.refresh_data.netview_url),'_blank');
			}
			if (event.result.ezware_response.status == 'FAIL'){
				Alert.okLabel = "OK";
					AlertMessageShow(event.result.ezware_response.reason);
					return;
			}
			if (event.result.ezware_response.status == 'EXPIRED'){
				Alert.okLabel = "OK";
				AlertMessageShow("Session EXPIRED due to inactivity.  Please log out and log back in again to create a new session.");
				return;
			}
		}

/*****************************************************************************
	Function to go to the Change Password state.
*****************************************************************************/

private function goToCPW( initStatus:String ):void {

	currentState	= 'changePassword';

	newPassword.text	= '';
	newPasswordAgain.text	= '';
	cpwStatus.text		= initStatus;

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
	Function to cancel from the Change Password state.
*****************************************************************************/

private function cpwCancel():void {
	//doLogout();
	/* Go back to the base state (the login page). */
	loginStatus	= '';
	currentState	= '';
	
	
	btn_login.visible = true;
	text1.visible=false;
	pbar.visible=false;

	if ( username.text == '' )
		username.setFocus();
	else
		password.setFocus();

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
		//cpwStatus.text = event.result.reason.toString();
		//return;
		cpwStatus.text = resultStatus(event.result.status, event.result.reason);  
		//AlertMessageShow(s_ret);
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

	/*
	 * Show the operator that we're logging in.  At the moment, this
	 * has to be done on the base state.
	 */
	loginStatus		= 'Starting session ...'; 
	pbar.visible	= true;
	text1.visible	= true; 
	currentState		= '';

	/* Trigger browser to start WindX. */
	var urWindX:URLRequest = new URLRequest();
	urWindX.url="ae_tlstartwindx.php?sid="+g_sid;
	navigateToURL( urWindX, '_blank' );

	
	
	
	/* Start AreYouThere timer. */
	aytTime.start();

	/* Ask server for operator profile. */
	companyCode.send()
}



/*
Changing of color for selected user and password input
*/


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


private function hoverHelpSwitch():void{
	if (hoverstatus == 'OFF'){
		hoverstatus = 'ON';
	} else {
			hoverstatus = 'OFF';
	}
	
	
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
		img_changepassword_1.source = "";
		img_changepassword_2.source = "";
		
	}
	else if (stylespeedoptions == 'standard'){
		img_company_logo.source = company_logo;
		img_users.source = "image/icon_users_small.png";
		img_eagle.source = "image/blue_eagle.png";
		img_lock.source = "image/password.png";
		
		this.setStyle("backgroundImage","image/Blue3.png");
		
		// This should be on the last 
		img_changepassword_1.source = "image/password.png";
		img_changepassword_2.source = "image/password.png";
	
		
	}
		
}

private function tree_collapseChildrenOf(evt:Event):void {
	
	XMLtreeoperator.selectedIndex = 0;
	for (var i:int = 0; i < XMLtreeoperator.dataProvider.length; i ++){ 
		XMLtreeoperator.expandChildrenOf(XMLtreeoperator.dataProvider[i], false) 
	} 
	XMLtreeoperator.selectedIndex = -1;
	
	
	
	
	XMLtreeadministrator.selectedIndex = 0;
	for (var i:int = 0; i < XMLtreeadministrator.dataProvider.length; i ++){ 
		XMLtreeadministrator.expandChildrenOf(XMLtreeadministrator.dataProvider[i], false) 
	} 
	XMLtreeadministrator.selectedIndex = -1;
	 
}

public var myfav_dom:Boolean = false;
private function changeAccordionheader(event:Event):void {  
	hoverstatus = 'OFF';
	
	/* Remove the Jobcanvass children */
	columnone.removeAllChildren(); 
	columntwo.removeAllChildren();
	columnthree.removeAllChildren();
	
	
	if ((accordion_treeview.selectedIndex == 0) || (accordion_treeview.selectedIndex == 1)){
		myfav_dom = false;
		ChainCombo.selectedIndex = accordion_treeview.selectedIndex;
		
		//Alert.show(accordion_treeview.selectedIndex.toString() + ":" + ChainCombo.selectedItem.id);
		if ((accordion_treeview.selectedIndex == 0)&&(ChainCombo.selectedItem.id == '20')){
			ChainCombo.selectedItem.id = '10';
		}
		if ((accordion_treeview.selectedIndex == 1)&&(ChainCombo.selectedItem.id == '10')){
			ChainCombo.selectedItem.id = '20';
		}
		
		system_text.text = "Systems"; 
		btn_breadcrumb.label = "Home";
		getMenu(event);
		storeViews.selectedChild = kpi;
	} 
	if (accordion_treeview.selectedIndex == 2){
		myfav_dom = true;
		//system_text.text = "Job Menu"; 
		system_text.text = ""; 
		btn_breadcrumb.label = "Home";
		
		trigger_event = "tree";
		
		var myData:ArrayCollection;
		
		myData = new ArrayCollection(mx.utils.ArrayUtil.toArray(treeviewmyfavorites_xml));
		
		if (myData[0].toString() == ''){
			
			columnone.removeAllChildren();
			columntwo.removeAllChildren();
			columnthree.removeAllChildren();	
			//storeViews.selectedChild = jobcanvas;
			resequence = false;
  
		} else {
			
		RetrieveMyFavoriteJobMenu(treeviewmyfavorites_xml.node[0].attribute("code"));
		//storeViews.selectedChild = jobcanvas;     
		resequence = false;
		system_text.text = treeviewmyfavorites_xml.node[0].attribute("code");
		   
		} 
		
		storeViews.selectedChild = jobcanvas;  
		
	}     
	
	if (accordion_treeview.selectedIndex == 3){
		
		// Remove this for now.   4/9/2013
		//AddMyShortcutstoJobMenu(event);
		system_text.text = ""; 
		RetrieveMyShortcutPianokeys(event);     
		////////
	/////////Alert.show("going here");                
		storeViews.selectedChild = jobcanvas;    
		    
		
	}   
	
	if (accordion_treeview.selectedIndex == 4){
		system_text.text = "Settings"; 
		storeViews.selectedChild = settings;
		
	}          

  
  
  
  
  
}
private var bm:IBrowserManager;

// For Anthony's Help Testing. Will remove this later if everything on the e-Z learn has been set-up.
private function eZLearn_for_help():void{
				
   					var urlpass:String = hoverhelp_domain
   					var jscommand:String = "window.open('" + urlpass + "','win','top=100,left=0,height=775,width=900,toolbar=no,scrollbars=yes');"; 
					var url:URLRequest = new URLRequest("javascript:" + jscommand + " void(0);"); 
					navigateToURL(url, "_self");
}


public var newObject:CustomHead;
public var newObjectBtn:CustomButton;
public var row_ctr:int = 0;
private var aFormFields:Array = new Array();
private function addObjectToArray(formField:DisplayObject):void{
	this.aFormFields.push(formField);
}
private function AddtoJobMenu(event:Event):void{
	
	columnone.removeAllChildren();
	columntwo.removeAllChildren();
	columnthree.removeAllChildren();
	   
	row_ctr = 0;
	 
	for (var i:int=0;i<arr_kpimenu.length;i++)  {
		//var newObject:CustomTextInput = new CustomTextInput();
		newObject = new CustomHead();
		
		newObject.customacb_id = arr_kpimenu[i]["id"];   
		newObject.customacb_name = arr_kpimenu[i]["name"];
		newObject.label = arr_kpimenu[i]["name"];
		
		DisplayToColumnObject(row_ctr);
		row_ctr = row_ctr + 1;
		// Add the 'job' for each group.
		if (arr_kpimenu[i].job is ObjectProxy){
			arr_kpimenu[i].job = new ArrayCollection(ArrayUtil.toArray(arr_kpimenu[i].job)); 
		}
		for (var ib:int=0;ib<(arr_kpimenu[i].job).length;ib++){
			newObjectBtn = new CustomButton();
			newObjectBtn.group_code = arr_kpimenu[i]["id"];   
			newObjectBtn.custombtn_code = arr_kpimenu[i].job[ib].code;
			newObjectBtn.custombtn_name = arr_kpimenu[i].job[ib].name;
			newObjectBtn.custombtn_image = arr_kpimenu[i].job[ib].image;
			newObjectBtn.custombtn_jobid = arr_kpimenu[i].job[ib].job_id;
			newObjectBtn.custombtn_jobprogram = arr_kpimenu[i].job[ib].job_program;
			newObjectBtn.custombtn_viewcode = arr_kpimenu[i].job[ib].job_viewcode;
			
			
			
			
			newObjectBtn.custombtn_usercode = g_usercode;
			newObjectBtn.custombtn_company = g_changed_m_code;
			newObjectBtn.custombtn_company_description = g_changed_m_codedescription;
			
		
			
			newObjectBtn.custombtn_chain = ChainCombo.selectedItem.id;
			
			newObjectBtn.system_code = arr_kpimenu[i].job[ib].syscode;   
			newObjectBtn.subsystem_code = arr_kpimenu[i].job[ib].subsyscode;
			     
			
			if(myfav_dom == true){
				newObjectBtn.styleName="jobButton10";
			}else {
			
				newObjectBtn.styleName="jobButton" + ChainCombo.selectedItem.id;
			}
			newObjectBtn.connection = (cb_speedoptions.selectedItem.data).toString();
			
			DisplayToColumnObjectButton(row_ctr, ib, (arr_kpimenu[i].job).length);
			row_ctr = row_ctr + 1;
		}
	}   
	
}
private function DisplayToColumnObjectButton(rc:int, rowno:int, len:int):void{
	//	Alert.show("len: " + len);
	if ((rc >= 0) && (rc < 21)){
		addObjectToArray(newObjectBtn);
		columnone.addChild(newObjectBtn);
		if  ((rc== 20) && (rowno != (len - 1))) {
			
			swapObject(newObject,20);
			
		}
		
	} else if ((rc >= 21 ) && (rc < 41)){
		
		addObjectToArray(newObjectBtn);
		columntwo.addChild(newObjectBtn);
		
		
		if ((rc == 40) && (rowno != (len - 1))) { 
			//Alert.show(rc + " : " + len);
			swapObject(newObject,40);
		}
	} else if (rc >= 41){
		addObjectToArray(newObjectBtn);
		columnthree.addChild(newObjectBtn); 
	}
	return
}
private var obj_gen_id:int = new int;
private var obj_gen_name:String = new String;
private var obj_gen_label:String = new String;
private function swapObject(obj_gen:Object, col:int):void{
	
	obj_gen_id = obj_gen.customacb_id;
	obj_gen_name = obj_gen.customacb_name;
	obj_gen_label = obj_gen.label;
	
	newObject = new CustomHead();
	
	newObject.customacb_id = obj_gen_id;   
	newObject.customacb_name = obj_gen_name + " (Continued)";
	newObject.label = obj_gen_label + " (Continued)";
	
	
	if (col == 20){
		columntwo.addChild(newObject);
	}
	if (col == 40){
		columnthree.addChild(newObject);
	}
	
	return;
	
}
private function DisplayToColumnObject(rc:int):void{
	
	if ((rc >= 0) && (rc < 21)){
		
		// check for last Column Header
		addObjectToArray(newObject);
		
		if (rc == 20){
			columntwo.addChild(newObject);
			row_ctr = row_ctr + 1;
		} else{
			
			columnone.addChild(newObject);
		}
		
	} else if ((rc >= 21 ) && (rc < 41)){
		addObjectToArray(newObject);
		
		
		if (rc == 40){
			columnthree.addChild(newObject);
			row_ctr = row_ctr + 1;
		} else{
			
			columntwo.addChild(newObject);
		}
		
	} else if (rc >= 41){
		addObjectToArray(newObject);
		columnthree.addChild(newObject);
	}
	return
}


public var popMyFavoritesList:MyFavorites;
private function clickMyFavorites(event:Event):void{
	
	popMyFavoritesList = MyFavorites( 
		PopUpManager.createPopUp(this, MyFavorites, true));   
	
	popMyFavoritesList["btn_myfavorite_create"].addEventListener("click", createMyFavorite);
	popMyFavoritesList["btn_myfavorite_modify"].addEventListener("click", modifyMyFavorite);
	
	popMyFavoritesList["btn_myfavorite_close"].addEventListener("click", closeMyFavoriteList);
	
	popMyFavoritesList.loc_user = g_usercode;
	popMyFavoritesList.loc_company_code = g_changed_m_code;
	popMyFavoritesList.loc_sessionid = g_sid;
	    

	
}  

public var popMyShortcutsList:MyShortcuts;
private function clickMyShortcuts(event:Event):void{
	
	popMyShortcutsList = MyShortcuts( 
		PopUpManager.createPopUp(this, MyShortcuts, true));   
	
	popMyShortcutsList["btn_myshortcut_create"].addEventListener("click", createMyShortcut);
	
	popMyShortcutsList["btn_myshortcut_modify"].addEventListener("click", modifyMyShortcut);
	    
	 
	popMyShortcutsList["btn_myshortcut_close"].addEventListener("click", closeMyShortcutList);
	
	
	
	
	popMyShortcutsList.loc_user = g_usercode;
	popMyShortcutsList.loc_company_code = g_changed_m_code;
	popMyShortcutsList.loc_sessionid = g_sid;
	
	PopUpManager.centerPopUp(popMyShortcutsList);
	
	
	
	
} 

private function updateMyListSequence(event:Event):void{
	//Alert.show(popMyFavoritesList.MyFavoriteCollection.length.toString());
	var finalres:String = new String;
	for (var i:int=0;i<popMyFavoritesList.MyFavoriteCollection.length;i++)  {
		finalres = finalres + c_utils.trim(popMyFavoritesList.MyFavoriteCollection[i]['code']) + ",";
	}
	
	finalres = finalres.substr(0,finalres.length-1);
	
	reqParms = 'REFRESH,UPDATE|MYFAVORITESEQ|' +  g_usercode + "|" + g_changed_m_code + "|" + finalres + "|";
	//Alert.show(reqParms);
	updateMyFavoritesSequence.send(); 
}



private function updateMyListSequence_Shortcut(event:Event):void{
	//Alert.show(popMyShortcutsList.MyShortcutCollection.length.toString());
	var finalres:String = new String;
	for (var i:int=0;i<popMyShortcutsList.MyShortcutCollection.length;i++)  {
		finalres = finalres + c_utils.trim(popMyShortcutsList.MyShortcutCollection[i]['shtcutcode']) + ",";
	}
	     
	finalres = finalres.substr(0,finalres.length-1);
	
	reqParms = 'REFRESH,UPDATE|MYSHORTCUTSEQ|' +  g_usercode + "|" + g_changed_m_code + "|" + finalres + "|";
	//Alert.show(reqParms);
	updateMyShortcutsSequence.send(); 
}



private function closeMyFavoriteList(event:Event):void{
	   
	updateMyListSequence(event);
	
	
	
	PopUpManager.removePopUp(popMyFavoritesList); 
	resetMyFavorites(event);
	
	
}


public var popMyFavoritesCM:MyFavoritesCM;
private function createMyFavorite(event:Event):void{
	updateMyListSequence(event);
	PopUpManager.removePopUp(popMyFavoritesList);
	popMyFavoritesCM = MyFavoritesCM(
		PopUpManager.createPopUp(this, MyFavoritesCM, true));
	popMyFavoritesCM["btn_close_window"].addEventListener("click", closeMyFavorite);
	
	popMyFavoritesCM.loc_user_code = g_usercode;
	popMyFavoritesCM.loc_company_code = g_changed_m_code;
	popMyFavoritesCM.loc_session_id = g_sid;
	popMyFavoritesCM.loc_mod_type = "create"; 
	popMyFavoritesCM.callbackFunction = clickMyFavorites;
	popMyFavoritesCM.loc_myfav_List   = popMyFavoritesList.MyFavoriteCollection;
    
		
	
}

private function modifyMyFavorite(event:Event):void{
	
	
	if (popMyFavoritesList.dg_myfavorites.selectedItems.length == 0){
		AlertMessageShow("Please select a row to modify.");
		return;
	}
	
	if (popMyFavoritesList.dg_myfavorites.selectedItems.length > 1){
		AlertMessageShow("Please select only one row to modify.");
		return;
	}
	updateMyListSequence(event);
	PopUpManager.removePopUp(popMyFavoritesList);
	popMyFavoritesCM = MyFavoritesCM(
		PopUpManager.createPopUp(this, MyFavoritesCM, true));
	popMyFavoritesCM["btn_close_window"].addEventListener("click", closeMyFavorite);
	
	popMyFavoritesCM.loc_user_code = g_usercode;
	popMyFavoritesCM.loc_company_code = g_changed_m_code;
	popMyFavoritesCM.loc_session_id = g_sid;
	popMyFavoritesCM.loc_mod_type = "modify";     
	popMyFavoritesCM.callbackFunction = clickMyFavorites;
	
	popMyFavoritesCM.loc_menu_code = popMyFavoritesList.dg_myfavorites.selectedItem.code; 
	popMyFavoritesCM.loc_menu_desc = popMyFavoritesList.dg_myfavorites.selectedItem.desc; 
	
}


private function closeMyFavorite(event:Event):void{      
	PopUpManager.removePopUp(popMyFavoritesCM); 
	clickMyFavorites(event);
	
}

	
private function ExpandAllOperations(evt:MouseEvent):void {
	XMLtreeoperator.selectedIndex = 0;
	for (var i:int = 0; i < XMLtreeoperator.dataProvider.length; i ++){ 
		XMLtreeoperator.expandChildrenOf(XMLtreeoperator.dataProvider[i], true) 
	} 
	XMLtreeoperator.selectedIndex = -1;
	
	
}

private function ExpandAllAdministration(evt:MouseEvent):void {
	XMLtreeadministrator.selectedIndex = 0;
	for (var i:int = 0; i < XMLtreeadministrator.dataProvider.length; i ++){ 
		XMLtreeadministrator.expandChildrenOf(XMLtreeadministrator.dataProvider[i], true) 
	} 
	XMLtreeadministrator.selectedIndex = -1;
	
	
} 


private function ExpandAllMyFavorites(evt:MouseEvent):void {
	XMLmyfavorites.selectedIndex = 0;
	for (var i:int = 0; i < XMLmyfavorites.dataProvider.length; i ++){ 
		XMLmyfavorites.expandChildrenOf(XMLmyfavorites.dataProvider[i], true) 
	} 
	XMLmyfavorites.selectedIndex = -1;
	
	
} 

private function tree_collapseChildrenOfOperations(evt:MouseEvent):void {
	XMLtreeoperator.selectedIndex = 0;
	for (var i:int = 0; i < XMLtreeoperator.dataProvider.length; i ++){ 
		XMLtreeoperator.expandChildrenOf(XMLtreeoperator.dataProvider[i], false) 
	} 
	XMLtreeoperator.selectedIndex = -1;
	changeAccordionheader(evt)
}
private function tree_collapseChildrenOfAdministration(evt:MouseEvent):void {
	XMLtreeadministrator.selectedIndex = 0;
	for (var i:int = 0; i < XMLtreeadministrator.dataProvider.length; i ++){ 
		XMLtreeadministrator.expandChildrenOf(XMLtreeadministrator.dataProvider[i], false) 
	} 
	XMLtreeadministrator.selectedIndex = -1;
	changeAccordionheader(evt)
}

private function tree_collapseChildrenOfMyFavorites(evt:MouseEvent):void {
	XMLmyfavorites.selectedIndex = 0;
	for (var i:int = 0; i < XMLmyfavorites.dataProvider.length; i ++){ 
		XMLmyfavorites.expandChildrenOf(XMLmyfavorites.dataProvider[i], false) 
	} 
	XMLmyfavorites.selectedIndex = -1;
	changeAccordionheader(evt)
}




        


private var popMyShortcutsCM:MyShortcutCM;
private function createMyShortcut(event:Event):void{
	updateMyListSequence_Shortcut(event);
	PopUpManager.removePopUp(popMyShortcutsList);
	popMyShortcutsCM = MyShortcutCM(
		PopUpManager.createPopUp(this, MyShortcutCM, true));
	popMyShortcutsCM["btn_cancel"].addEventListener("click", closeMyShortcut);
	//popMyShortcutsCM["btn_save_current"].addEventListener("click", saveMyShortcut);
	
	popMyShortcutsCM["btn_save_current"].addEventListener("click", saveMyShortcut_create);
	
	
	
	
	popMyShortcutsCM.loc_user_code = g_usercode;
	popMyShortcutsCM.loc_company_code = g_changed_m_code;
	popMyShortcutsCM.loc_session_id = g_sid;
	popMyShortcutsCM.loc_mod_type = "create";  
	popMyShortcutsCM.callbackFunction = clickMyShortcuts;
	
	PopUpManager.centerPopUp(popMyShortcutsCM);
	
	
	
}

private function modifyMyShortcut(event:Event):void{
	
	  
	
	
	if (popMyShortcutsList.dg_myshortcuts.selectedItems.length == 0){
		AlertMessageShow("Please select a row to modify.");
		return;
	}
	
	if (popMyShortcutsList.dg_myshortcuts.selectedItems.length > 1){
		AlertMessageShow("Please select only one row to modify.");
		return;
	}
	//  We'll get back to this later.
	
	updateMyListSequence_Shortcut(event);(event);
	PopUpManager.removePopUp(popMyShortcutsList);
	popMyShortcutsCM = MyShortcutCM(
		PopUpManager.createPopUp(this, MyShortcutCM, true));
	 
	
	popMyShortcutsCM.loc_user_code = g_usercode;
	popMyShortcutsCM.loc_company_code = g_changed_m_code;
	popMyShortcutsCM.loc_session_id = g_sid;
	popMyShortcutsCM.loc_mod_type = "modify";     
	popMyShortcutsCM.callbackFunction = clickMyShortcuts;
	popMyShortcutsCM.inputcode.enabled = false;
	popMyShortcutsCM.inputcode.text = popMyShortcutsList.dg_myshortcuts.selectedItem.shtcutcode;   
	popMyShortcutsCM.inputdescription.text = popMyShortcutsList.dg_myshortcuts.selectedItem.shtcutdesc; 
	popMyShortcutsCM.ti_shortcutcode.text = popMyShortcutsList.dg_myshortcuts.selectedItem.mbdcode; 
	popMyShortcutsCM.ti_shortcutdescription.text = popMyShortcutsList.dg_myshortcuts.selectedItem.buttonlabel; 
	popMyShortcutsCM.ti_viewcode.text = popMyShortcutsList.dg_myshortcuts.selectedItem.viewcode; 
	popMyShortcutsCM.ti_viewdescription.text = popMyShortcutsList.dg_myshortcuts.selectedItem.viewdesc; 
	
	
	PopUpManager.centerPopUp(popMyShortcutsCM);         
	
	popMyShortcutsCM["btn_save_current"].addEventListener("click", saveMyShortcut);
	popMyShortcutsCM["btn_cancel"].addEventListener("click", closeMyShortcut);
	
	
	
}



private function closeMyShortcutList(event:Event):void{  
	updateMyListSequence_Shortcut(event);
	PopUpManager.removePopUp(popMyShortcutsList); 
}


private function closeMyShortcut(event:Event):void{   
	PopUpManager.removePopUp(popMyShortcutsCM); 
	clickMyShortcuts(event);
}

private function saveMyShortcut(event:Event):void{   
	
	    
	if (popMyShortcutsCM.inputcode.text == ""){
		AlertMessageShow("Please Enter Shortcut Code");
		return;
	}
	if (popMyShortcutsCM.inputdescription.text == ""){
		AlertMessageShow("Please Enter Shortcut Description");
		return;
	}
	if (popMyShortcutsCM.ti_shortcutcode.text == ""){
		AlertMessageShow("Please Enter Assigned Action Grid");
		return;
	}
	if (popMyShortcutsCM.ti_viewcode.text == ""){
		AlertMessageShow("Please Enter Assigned View"); 
		return;
	}
	
		
	reqParms = "REFRESH,UPDATE|MYSHORTCUT|" + popMyShortcutsCM.inputcode.text + "|" +
												popMyShortcutsCM.inputdescription.text + "|" + 
												g_usercode + "|" + 
												popMyShortcutsCM.ti_shortcutcode.text + "|" +
												popMyShortcutsCM.ti_viewcode.text + "|" + 
												g_changed_m_code + "|";
	getmyshortcuts.send();  
	
	   
	/*
	REFRESH,DELETE|MYSHORTCUT|usercode|shortcutcode|companycode|
	*/
	
}

private function saveMyShortcut_create(event:Event):void{
	
	
	popMyShortcutsCM.inputcode.text = c_utils.trim(popMyShortcutsCM.inputcode.text);
	
	var fl:Boolean = false;
	for (var i:int=0;i<popMyShortcutsList.MyShortcutCollection.length;i++)  {
		//finalres = finalres + c_utils.trim(popMyFavoritesList.MyFavoriteCollection[i]['code']) + ",";
		
		if (popMyShortcutsList.MyShortcutCollection[i]['shtcutcode'] == popMyShortcutsCM.inputcode.text){
				fl = true;
				break
		}   
		
	}
	if (fl == true){
		AlertMessageShow("MyShortcut Code already exist");
		return
	} else{
		saveMyShortcut(event);
	} 
	
	
	
	
}   
/*
private function AddMyShortcutstoJobMenu(event:Event):void{
	//Alert.show(MyShortcutCollectionMain.length.toString());
	  
	columnone.removeAllChildren();
	columntwo.removeAllChildren();
	columnthree.removeAllChildren();
	
	row_ctr = 0;
	for (var i:int=0;i<MyShortcutCollectionMain.length;i++)  {
		newObject = new CustomHead();
		
		newObject.customacb_id = 0;   
		newObject.customacb_name = MyShortcutCollectionMain[i]["shtcutcode"];
		newObject.label = MyShortcutCollectionMain[i]["shtcutcode"];
		
		DisplayToColumnObject(row_ctr);
		row_ctr = row_ctr + 1;
		
		
		//var main:String = "../mainboard/mainboard.php?mb=*_"+adg_shortcuts.selectedItem.shtcutcode+'@'+g_changed_m_code + '@' + g_usercode; 
		
		
		newObjectBtn = new CustomButton();
		newObjectBtn.group_code = "";   
		newObjectBtn.custombtn_code = "*";
		//newObjectBtn.custombtn_name =  MyShortcutCollectionMain[i]["mbdcode"];
		newObjectBtn.custombtn_name =  MyShortcutCollectionMain[i]["mbddesc"] + " [" +  MyShortcutCollectionMain[i]["type"] + "]";   
		newObjectBtn.custombtn_image = "";
		newObjectBtn.custombtn_jobid = "*";
		newObjectBtn.custombtn_jobprogram = "../mainboard/mainboard.php?mb=*_"+MyShortcutCollectionMain[i]["shtcutcode"]+'@'+
			g_changed_m_code + '@' + 
			g_usercode + '&scc=' + MyShortcutCollectionMain[i]["viewcode"];
		
		
		
		newObjectBtn.custombtn_company = g_changed_m_code;
		newObjectBtn.custombtn_company_description = g_changed_m_codedescription;
		
		
		
		newObjectBtn.custombtn_chain = ChainCombo.selectedItem.id;
		
		newObjectBtn.system_code = "";   
		newObjectBtn.subsystem_code = "";
		newObjectBtn.styleName="jobButton10";
		row_ctr = row_ctr + 1;
		
		
		DisplayToColumnObjectButton(row_ctr, i, MyShortcutCollectionMain.length);
		
	}
		
	
	
	
}

*/
private function myLabelFunc(item:Object):String {
	return item.shtcutcode + " - " + item.shtcutdesc; 
}




private function MyShortcutClickhandler(event:Event):void{
	
	//Alert.show(adg_shortcuts.selectedItem.shtcutcode);
	
	var main:String = "../mainboard/mainboard.php?mb=*_"+adg_shortcuts.selectedItem.shtcutcode+'@'+g_changed_m_code + '@' + g_usercode; 
	
		navigateToURL(new URLRequest(main+ '&c='+ g_changed_m_code + '&cd='+ g_changed_m_codedescription + '&scc='+adg_shortcuts.selectedItem.viewcode),'_blank');
	    
	
	//navigateToURL(new URLRequest(e.itemRenderer.data.@job_program+ '&c='+ g_changed_m_code + '&cd='+ g_changed_m_codedescription),'_blank');
	  
	
	/*
	var item:Object = Tree(e.currentTarget).selectedItem;
	if (XMLmyfavorites.dataDescriptor.isBranch(item)) {
		XMLmyfavorites.expandItem(item, !XMLmyfavorites.isItemOpen(item), true);
	}
	
	trigger_event = 'tree';
	   
	if ((e.itemRenderer.data.@menu == "subsystem")||(e.itemRenderer.data.@menu == "group")){
		
		if (e.itemRenderer.data.@menu == "group"){
			system_text.text = e.itemRenderer.data.@subsys_cd;	
			RetrieveMyFavoriteJobMenu(e.itemRenderer.data.@subsys_cd);
		} else {
			system_text.text = e.itemRenderer.data.@code;
			RetrieveMyFavoriteJobMenu(e.itemRenderer.data.@code);
		}
		pu_menu = "job";
		
	} else if(e.itemRenderer.data.@menu == "job"){
		system_text.text = e.itemRenderer.data.@subsys_cd;
		var jobid:String = new String;
		jobid = (e.itemRenderer.data.@job_id).toString();
		
		
		if (jobid.length == 1){
			Alert.show(e.itemRenderer.data.@job_program);
			if (e.itemRenderer.data.@job_program == 'NETVIEW'){
				runNetView.send();
			} else {
				
				if ((e.itemRenderer.data.@job_program).substr(0,1) == 'e'){
					
					
					var short_jobprog:String = e.itemRenderer.data.@job_program;
					
					
					var sub_custombtn_jobprogram:String = 	short_jobprog.substr(1,short_jobprog.length);
					var jscommand:String = "window.open('" + sub_custombtn_jobprogram + "','win','top=100,left=0,height=905,width=1200,toolbar=no,scrollbars=yes');";
					var url:URLRequest = new URLRequest("javascript:" + jscommand + " void(0);");   
					
					navigateToURL(url, "_self");
					
					
				} else {
					
					navigateToURL(new URLRequest(e.itemRenderer.data.@job_program+ '&c='+ g_changed_m_code + '&cd='+ g_changed_m_codedescription),'_blank');
				}
				
				
			}	
		}
		if (jobid.length > 1){ 
			
			ht_jobcode = e.itemRenderer.data.@job_id;
			navigateJobProgram.send();    
		}
		
		
		
		
	}
	*/
}







private var popJobCodesMenu:JobCodesMenu;
private function openJobCodesMenu(event:Event):void{
	
	/*     
	popJobCodesMenu = JobCodesMenu(
		PopUpManager.createPopUp(this, JobCodesMenu, true));
	popJobCodesMenu["btn_close_window"].addEventListener("click", closeMyFavorite);
	
	popMyFavoritesCM.loc_user_code = g_usercode;
	popMyFavoritesCM.loc_company_code = g_changed_m_code;
	popMyFavoritesCM.loc_session_id = g_sid;
	popMyFavoritesCM.loc_mod_type = "create"; 
	popMyFavoritesCM.callbackFunction = clickMyFavorites;
	popMyFavoritesCM.loc_myfav_List   = popMyFavoritesList.MyFavoriteCollection;
	*/
	
	popJobCodesMenu = JobCodesMenu(
		PopUpManager.createPopUp(this, JobCodesMenu, true));
	popJobCodesMenu["btn_close_window"].addEventListener("click", closeJobsMenu);
	popJobCodesMenu["dataGrid1"].addEventListener("click", clickJobsMenu);     
	
	popJobCodesMenu.loc_user_code = g_usercode;
	popJobCodesMenu.loc_company_code = g_changed_m_code;
	popJobCodesMenu.loc_session_id = g_sid;
	
	PopUpManager.centerPopUp(popJobCodesMenu);
	
}    

private function closeJobsMenu(event:Event):void{
	PopUpManager.removePopUp(popJobCodesMenu); 
}

private function clickJobsMenu(event:Event):void{
	
	
	jobcode.text = popJobCodesMenu.dataGrid1.selectedItem.job_exec;
	jobCodeHandler();
	closeJobsMenu(event);
	
	
	
	
}





private function RetrieveMyShortcutPianokeys(event:Event):void{ 
	
	/*
	reqParms = "REFRESH,RETRIEVE|MYFAVORITEJOBS|" + g_usercode +
		"|" +  g_changed_m_code + 
		"|" + code + "|";
	*/
	reqParms = "REFRESH,RETRIEVE|MYSHORTCUTS_JOBS|" + g_usercode + "|" + g_changed_m_code+ "|";
	getshortcutpianokeys.send(); 
	//btn_breadcrumb.label = "Home";
	
}	  


private function changeEvtTabSetting(event:Event):void{
/*
	forChange.text+=event.currentTarget.selectedItem.label + " " + 
		event.currentTarget.selectedIndex 
	*/	
		//Alert.show(event.currentTarget.selectedItem.data + " : " + event.currentTarget.selectedItem.label );
	
	
//	Alert.show("Work in Process.");
	
	
	
	g_permanenttabset = settingstab.selectedIndex;
	
	
	reqParms = "REFRESH,UPDATE|OPER_PREF|" + g_usercode + "|" + event.currentTarget.selectedItem.data + '|';
	updatetabsettings.send();	
}



private function AddtoShortcutMenu(event:Event):void{
	
	columnone.removeAllChildren(); 
	columntwo.removeAllChildren();
	columnthree.removeAllChildren();
	
	row_ctr = 0;
	
	for (var i:int=0;i<arr_shortcutmenu.length;i++)  {
		//var newObject:CustomTextInput = new CustomTextInput();
		newObject = new CustomHead();
		
		newObject.customacb_id = arr_shortcutmenu[i]["id"];   
		newObject.customacb_name = arr_shortcutmenu[i]["name"];
		newObject.label = arr_shortcutmenu[i]["name"];
		
		DisplayToColumnObject(row_ctr);
		row_ctr = row_ctr + 1;
		// Add the 'job' for each group.
		if (arr_shortcutmenu[i].job is ObjectProxy){
			arr_shortcutmenu[i].job = new ArrayCollection(ArrayUtil.toArray(arr_shortcutmenu[i].job)); 
		}
		
		for (var ib:int=0;ib<(arr_shortcutmenu[i].job).length;ib++){
			
			newObjectBtn = new CustomButton();
			newObjectBtn.group_code = arr_shortcutmenu[i]["id"];   
			newObjectBtn.custombtn_code = "*";
			newObjectBtn.custombtn_name = arr_shortcutmenu[i].job[ib].shtcutcode + "  [" +  arr_shortcutmenu[i].job[ib].type + "]";
			newObjectBtn.custombtn_image = "";
			newObjectBtn.custombtn_jobid = "*";
			//newObjectBtn.custombtn_jobprogram = arr_shortcutmenu[i].job[ib].job_program;
			newObjectBtn.custombtn_jobprogram = "../mainboard/mainboard.php?mb=*_"+arr_shortcutmenu[i].job[ib].shtcutcode+'@'+
				g_changed_m_code + '@' + 
				g_usercode + '&scc=' + arr_shortcutmenu[i].job[ib].viewcode;
			    
			/////////////////////////////////////////
			/*
			newObjectBtn = new CustomButton();
			newObjectBtn.group_code = "";   
			newObjectBtn.custombtn_code = "*";
			//newObjectBtn.custombtn_name =  MyShortcutCollectionMain[i]["mbdcode"];
			newObjectBtn.custombtn_name =  MyShortcutCollectionMain[i]["mbddesc"] + " [" +  MyShortcutCollectionMain[i]["type"] + "]";   
			newObjectBtn.custombtn_image = "";
			newObjectBtn.custombtn_jobid = "*";
			newObjectBtn.custombtn_jobprogram = "../mainboard/mainboard.php?mb=*_"+MyShortcutCollectionMain[i]["shtcutcode"]+'@'+
				g_changed_m_code + '@' + 
				g_usercode + '&scc=' + MyShortcutCollectionMain[i]["viewcode"];
			
			
			*/
			
			/////////////////////////////////////////
		
			newObjectBtn.custombtn_company = g_changed_m_code;
			newObjectBtn.custombtn_company_description = g_changed_m_codedescription;
			
			/*
			
			newObjectBtn.custombtn_chain = ChainCombo.selectedItem.id;
			
			newObjectBtn.system_code = arr_shortcutmenu[i].job[ib].syscode;   
			newObjectBtn.subsystem_code = arr_shortcutmenu[i].job[ib].subsyscode;
			
			
			
			
			
			
			if(myfav_dom == true){
				newObjectBtn.styleName="jobButton10";
			}else {
				
				newObjectBtn.styleName="jobButton" + ChainCombo.selectedItem.id;
			}
			newObjectBtn.connection = (cb_speedoptions.selectedItem.data).toString();
			
			DisplayToColumnObjectButton(row_ctr, ib, (arr_shortcutmenu[i].job).length);
			*/
			
			newObjectBtn.custombtn_chain = ChainCombo.selectedItem.id;
			
			newObjectBtn.system_code = "";   
			newObjectBtn.subsystem_code = "";
			newObjectBtn.styleName="jobButton10";
			
			DisplayToColumnObjectButton(row_ctr, ib, (arr_shortcutmenu[i].job).length);
			row_ctr = row_ctr + 1;
		}    
	}   
	//storeViews.selectedChild = jobcanvas;            
}

/*
private function AddMyShortcutstoJobMenu(event:Event):void{
	//Alert.show(MyShortcutCollectionMain.length.toString());
	
	columnone.removeAllChildren();
	columntwo.removeAllChildren();
	columnthree.removeAllChildren();
	
	row_ctr = 0;
	for (var i:int=0;i<MyShortcutCollectionMain.length;i++)  {
		newObject = new CustomHead();
		
		newObject.customacb_id = 0;   
		newObject.customacb_name = MyShortcutCollectionMain[i]["shtcutcode"];
		newObject.label = MyShortcutCollectionMain[i]["shtcutcode"];
		
		DisplayToColumnObject(row_ctr);
		row_ctr = row_ctr + 1;
		
		
		//var main:String = "../mainboard/mainboard.php?mb=*_"+adg_shortcuts.selectedItem.shtcutcode+'@'+g_changed_m_code + '@' + g_usercode; 
		
		
		newObjectBtn = new CustomButton();
		newObjectBtn.group_code = "";   
		newObjectBtn.custombtn_code = "*";
		//newObjectBtn.custombtn_name =  MyShortcutCollectionMain[i]["mbdcode"];
		newObjectBtn.custombtn_name =  MyShortcutCollectionMain[i]["mbddesc"] + " [" +  MyShortcutCollectionMain[i]["type"] + "]";   
		newObjectBtn.custombtn_image = "";
		newObjectBtn.custombtn_jobid = "*";
		newObjectBtn.custombtn_jobprogram = "../mainboard/mainboard.php?mb=*_"+MyShortcutCollectionMain[i]["shtcutcode"]+'@'+
			g_changed_m_code + '@' + 
			g_usercode + '&scc=' + MyShortcutCollectionMain[i]["viewcode"];
		
		
		
		newObjectBtn.custombtn_company = g_changed_m_code;
		newObjectBtn.custombtn_company_description = g_changed_m_codedescription;
		
		
		
		newObjectBtn.custombtn_chain = ChainCombo.selectedItem.id;
		
		newObjectBtn.system_code = "";   
		newObjectBtn.subsystem_code = "";
		newObjectBtn.styleName="jobButton10";
		row_ctr = row_ctr + 1;
		
		
		DisplayToColumnObjectButton(row_ctr, i, MyShortcutCollectionMain.length);
		
	}
	
	*/