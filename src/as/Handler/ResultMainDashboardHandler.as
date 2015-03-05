/*****************************************************************************
	Visible Logistics

	Actionscript handlers for successful HTTPService results.

	Copyright 2009,2010 Maves International Software
	ALL RIGHTS RESERVED
------------------------------------------------------------------------------
$Id: ResultMainDashboardHandler.as,v 1.18.2.4 2012/11/28 20:19:21 aprarn Exp $
*****************************************************************************/

import flash.external.ExternalInterface;

import mx.collections.ArrayCollection;
import mx.containers.ViewStack;
import mx.messaging.messages.HTTPRequestMessage;
import mx.rpc.events.ResultEvent;
import mx.utils.ArrayUtil;
import mx.utils.ObjectProxy;

			private const TIMER_INTERVAL:int = 1500;
            private var baseTimer:int;
        	private const TIMER_INTERVAL_FOR_HOVER_MBDG:int = 1;
			public var nt:Timer;	
			public var mbdg_objecttitle:String;
   			public var mbdg_objecttitleheader:String;
   			public var mbdg_objecthelpfortitle:String;

[Bindable] public var treeviewoperations_xml:XML = new XML;
[Bindable] public var treeviewadministration_xml:XML = new XML;


[Bindable] public var treeviewoperations_xml2:XML = new XML;
[Bindable] public var treeviewadministration_xml2:XML = new XML;


[Bindable] public var treeviewmyfavorites_xml:XML = new XML;

[Bindable]
private var treeviewoperations_arr:ArrayCollection = new ArrayCollection;
[Bindable]
private var treeviewadministrations_arr:ArrayCollection = new ArrayCollection;

private function treeviewOperationsHandler(evt:ResultEvent):void {

	if ( evt.result.ezware_response.status == 'OK' ) {
		if (jobCodes_status == 'OFF'){
			
			treeviewoperations_xml = XML(evt.result.ezware_response.refresh_data.dbxmldata.value);
			//treeviewoperations_arr = evt.result.ezware_response.refresh_data.jobs.job;  
			
		} else {
			
			treeviewoperations_xml = XML(evt.result.ezware_response.refresh_data.dbxmldata2.value);
			//treeviewoperations_arr = evt.result.ezware_response.refresh_data.jobs2.job;  
			
		}
		
		
	}else {
		
		var s_ret:String = resultStatus(evt.result.ezware_response.status, evt.result.ezware_response.reason);  
		AlertMessageShow(s_ret);
		return;
		
	}	
	   
	
	
}

private function treeviewAdministrationHandler(evt:ResultEvent):void {
	
	if ( evt.result.ezware_response.status == 'OK' ) {
		if (jobCodes_status == 'OFF'){
			treeviewadministration_xml = XML(evt.result.ezware_response.refresh_data.dbxmldata.value);
			//treeviewadministrations_arr = evt.result.ezware_response.refresh_data.jobs.job;
		} else {
			treeviewadministration_xml = XML(evt.result.ezware_response.refresh_data.dbxmldata2.value);
			//treeviewadministrations_arr = evt.result.ezware_response.refresh_data.jobs2.job;
		}
	}else {
		
		var s_ret:String = resultStatus(evt.result.ezware_response.status, evt.result.ezware_response.reason);  
		AlertMessageShow(s_ret);
		return;
		
	}		
	
}


private function treeviewMyFavoritesHandler(evt:ResultEvent):void {
	
	if ( evt.result.ezware_response.status == 'OK' ) {
		treeviewmyfavorites_xml = new XML;
		if (jobCodes_status == 'OFF'){
			treeviewmyfavorites_xml = XML(evt.result.ezware_response.refresh_data.dbxmldata.value);
			  
			//treeviewadministrations_arr = evt.result.ezware_response.refresh_data.jobs.job;
		} else {
			treeviewmyfavorites_xml = XML(evt.result.ezware_response.refresh_data.dbxmldata2.value);
			//treeviewadministrations_arr = evt.result.ezware_response.refresh_data.jobs2.job;
		}
		
		
		
		//if (resequence == true){
		/*  Only call its own*/
		if (accordion_treeview.selectedIndex == 2){
		  changeAccordionheader(evt);
		}
		//}
		
		//PopUpManager.removePopUp(myAlert);
	}else {
		
		var s_ret:String = resultStatus(evt.result.ezware_response.status, evt.result.ezware_response.reason);  
		AlertMessageShow(s_ret);
		return;
		
	}		
	
}



private function getsubsystemHandler_designer(event:Event):void{
	//arr_kpimenusubsystem=new ArrayCollection();

	kpi2.pass_companycode = g_changed_m_code;
	kpi2.pass_url = my_pass_url;
	kpi2.pass_arr_kpimenu = arr_kpimenusubsystem;
	/*
	kpi2.percentWidth = 100;
	kpi2.percentHeight = 100;
	*/
	storeViews.selectedChild = kpi2;
	 
	/*
	nt = new Timer(TIMER_INTERVAL);
	nt.addEventListener(TimerEvent.TIMER, nt_update); 
	nt.start(); 
	 */ 
	//storeViews.selectedChild = kpi2;  
	//btn_breadcrumb.label = "Systems"; 
}

//private const TIMER_INTERVAL:int = 1500;
//private var nt:Timer;
/*
private function nt_update(evt:TimerEvent):void {
	nt.stop();
	storeViews.selectedChild = kpi2;  
	btn_breadcrumb.label = "Systems"; 
}
*/
  
private var arr_kpimenusubsystem:ArrayCollection = new ArrayCollection;
private function getsubsystemHandler(event:ResultEvent):void {
	 
//	var arr_kpimenusubsystem:ArrayCollection = new ArrayCollection;
	if (event.result.ezware_response.refresh_data.subsystems == null)
	{
		arr_kpimenusubsystem=new ArrayCollection();
		getsubsystemHandler_designer(event);
		
	}
	if (event.result.ezware_response.refresh_data.subsystems.subsystem != null){
		
		if (event.result.ezware_response.refresh_data.subsystems.subsystem == null)
		{
			arr_kpimenusubsystem=new ArrayCollection()
		}
		else if (event.result.ezware_response.refresh_data.subsystems.subsystem is ArrayCollection)
		{
			arr_kpimenusubsystem=event.result.ezware_response.refresh_data.subsystems.subsystem;
		}
		else if (event.result.ezware_response.refresh_data.subsystems.subsystem is ObjectProxy)
		{
			arr_kpimenusubsystem = new ArrayCollection(ArrayUtil.toArray(event.result.ezware_response.refresh_data.subsystems.subsystem));  
		}
		arr_kpimenusubsystem.refresh();
		
		
	
		if (arr_kpimenusubsystem.length == 1){ 
		
			if (trigger_event == 'chicklets'){
			
				g_syscode = arr_kpimenusubsystem[0]['syscode'];
				g_subsyscode = arr_kpimenusubsystem[0]['code'];
				
				//RetrieveJobMenu(arr_kpimenusubsystem[0]['syscode'], arr_kpimenusubsystem[0]['code'], arr_kpimenusubsystem[0]['name']  );
				RetrieveJobMenu(arr_kpimenusubsystem[0]['syscode'], arr_kpimenusubsystem[0]['code'] );
			}	
			else if(trigger_event == 'tree'){
				if (cb_speedoptions.selectedItem.data =='basic'){
					for (var i:int=0;i<arr_kpimenusubsystem.length;i++) {
						arr_kpimenusubsystem[i].image = '';
					}
					
				}
				
				getsubsystemHandler_designer(event);
				
				
			}
		   
		} else if (arr_kpimenusubsystem.length > 1){
			
			if (cb_speedoptions.selectedItem.data =='basic'){
				for (var i:int=0;i<arr_kpimenusubsystem.length;i++) {
					arr_kpimenusubsystem[i].image = '';
				}
				
			}
			 
			getsubsystemHandler_designer(event);
			
		}
		
	}

}

private function getjobHandler_designer(event:Event):void{

	AddtoJobMenu(event);
	
	storeViews.selectedChild = jobcanvas; 
	//btn_breadcrumb.label = "SubSystems";

}
private function getjobHandler(event:ResultEvent):void{

	if (event.result.ezware_response.refresh_data.jobs == null)
	{
		arr_kpimenu=new ArrayCollection();
	//	getjobHandler_designer(event);
	}
	
	 /*  Qualify Job Codes turned OFF or ON */
	  if (jobCodes_status == 'OFF'){
				if (event.result.ezware_response.refresh_data.jobs.group != null){
					if (event.result.ezware_response.refresh_data.jobs.group == null)
					{
						arr_kpimenu=new ArrayCollection()
						
					}  
					else if (event.result.ezware_response.refresh_data.jobs.group is ArrayCollection)
					{
						
						arr_kpimenu=event.result.ezware_response.refresh_data.jobs.group;
						
					}
					else if (event.result.ezware_response.refresh_data.jobs.group is ObjectProxy)
					{
						
						arr_kpimenu = new ArrayCollection(ArrayUtil.toArray(event.result.ezware_response.refresh_data.jobs.group));  
					}
					arr_kpimenu.refresh();
					
					if (arr_kpimenu.length == 1){
						
						if (trigger_event == 'chicklets'){
							
							var arr_job:ArrayCollection = new ArrayCollection;
							
							if (event.result.ezware_response.refresh_data.jobs.group.job == null)
							{
								arr_job=new ArrayCollection()
							}  
							else if (event.result.ezware_response.refresh_data.jobs.group.job is ArrayCollection)
							{
								arr_job=event.result.ezware_response.refresh_data.jobs.group.job;
							}
							else if (event.result.ezware_response.refresh_data.jobs.group.job is ObjectProxy)
							{
								arr_job = new ArrayCollection(ArrayUtil.toArray(event.result.ezware_response.refresh_data.jobs.group.job));  
							}
							arr_job.refresh();
							
							   if (arr_job.length == 1){
							
										var loc_jobid:String = event.result.ezware_response.refresh_data.jobs.group.job.job_id;
										var loc_jobprogram:String = event.result.ezware_response.refresh_data.jobs.group.job.job_program;
									
										if ((loc_jobid).length == 1){
											navigateToURL(new URLRequest(loc_jobprogram+ '&c='+ g_changed_m_code + '&cd='+ g_changed_m_codedescription),'_blank');
										} else {
											if ((loc_jobid).length > 1){
												
												ht_jobcode = event.result.ezware_response.refresh_data.jobs.group.job.job_id;
												navigateJobProgram_ArnoldTest2.send();
											
											} 
										}
										
							
							   }else {
								   getjobHandler_designer(event);
							   }	
							
							
							
							
						} else if (trigger_event == 'tree'){
							getjobHandler_designer(event);
						}		
						
					} else if (arr_kpimenu.length > 1){
						getjobHandler_designer(event);
					}
				}
	  } else {
			  if (event.result.ezware_response.refresh_data.jobs2.group != null){
				  if (event.result.ezware_response.refresh_data.jobs2.group == null)
				  {
					  arr_kpimenu=new ArrayCollection()
				  }  
				  else if (event.result.ezware_response.refresh_data.jobs2.group is ArrayCollection)
				  {
					  arr_kpimenu=event.result.ezware_response.refresh_data.jobs2.group;
				  }
				  else if (event.result.ezware_response.refresh_data.jobs2.group is ObjectProxy)
				  {
					  arr_kpimenu = new ArrayCollection(ArrayUtil.toArray(event.result.ezware_response.refresh_data.jobs2.group));  
				  }
				  arr_kpimenu.refresh();
				
				  if (arr_kpimenu.length == 1){    
					
					 
					  if (trigger_event == 'chicklets'){
					
					  		
							var arr_job:ArrayCollection = new ArrayCollection;
							
								if (event.result.ezware_response.refresh_data.jobs2.group.job == null)
								{
									arr_job=new ArrayCollection()
								}  
								else if (event.result.ezware_response.refresh_data.jobs2.group.job is ArrayCollection)
								{
									arr_job=event.result.ezware_response.refresh_data.jobs2.group.job;
								}
								else if (event.result.ezware_response.refresh_data.jobs2.group.job is ObjectProxy)
								{
									arr_job = new ArrayCollection(ArrayUtil.toArray(event.result.ezware_response.refresh_data.jobs2.group.job));  
								}
								arr_job.refresh();
									
									if (arr_job.length == 1){
										var loc_jobid:String = event.result.ezware_response.refresh_data.jobs2.group.job.job_id;
										var loc_jobprogram:String = event.result.ezware_response.refresh_data.jobs2.group.job.job_program;
											  if ((loc_jobid).length == 1){
												  
												  
												  navigateToURL(new URLRequest(loc_jobprogram+ '&c='+ g_changed_m_code + '&cd='+ g_changed_m_codedescription),'_blank');
											  
											  }else {
												
												  if ((loc_jobid).length > 1){
													  
													  ht_jobcode = event.result.ezware_response.refresh_data.jobs2.group.job.job_id;
													  navigateJobProgram_ArnoldTest2.send();
													  
												  }
											  }
									}else {
										getjobHandler_designer(event);
									}		  
						
					  
					  } else if (trigger_event == 'tree'){
						  getjobHandler_designer(event);
					  }		
					  
				  } else if (arr_kpimenu.length > 1){
					  getjobHandler_designer(event);
				  }
			  }
		  
	  
	  }		
}


private function KPIMenuResultHandler(event:ResultEvent):void {
	if (event.result.ezware_response.status == 'OK' ) {
	
			arr_kpimenu=new ArrayCollection();
			if (event.result.ezware_response.refresh_data.systems == null)
			{
				arr_kpimenu=new ArrayCollection();
				kpi.percentWidth = 100;
				kpi.percentHeight = 100;
				kpi.pass_companycode = g_changed_m_code;
				kpi.pass_url = my_pass_url;
				kpi.pass_arr_kpimenu = arr_kpimenu;
				kpi.pass_menu = "system";
				storeViews.selectedChild = kpi;
			}
		
			if (event.result.ezware_response.refresh_data.systems.system != null) {
		
				if (event.result.ezware_response.refresh_data.systems.system == null)
				{
					arr_kpimenu=new ArrayCollection()
				}
				else if (event.result.ezware_response.refresh_data.systems.system is ArrayCollection)
				{
					arr_kpimenu=event.result.ezware_response.refresh_data.systems.system;
				}
				else if (event.result.ezware_response.refresh_data.systems.system is ObjectProxy)
				{
				arr_kpimenu = new ArrayCollection(ArrayUtil.toArray(event.result.ezware_response.refresh_data.systems.system));
				}
				arr_kpimenu.refresh();
			}
			detectScreenResolutionforSystem();   
			/* Time to refresh the KPI Menu records. */
			
			//Alert.show(cb_speedoptions.selectedItem.data);
			if (cb_speedoptions.selectedItem.data =='basic'){
				for (var i:int=0;i<arr_kpimenu.length;i++) {
					arr_kpimenu[i].image = '';
				}
			}
			pu_menu = "system";
			//kpi.percentWidth = 100;
			//kpi.percentHeight = 100;
			
				/*
				var storeViews:ViewStack = new ViewStack;
				storeViews.percentHeight = 100;
				storeViews.percentWidth = 50;
				*/				
				
				
				   
			/*
			id="kpi"
			label="Transport Dispatch"
			width="100%" height="100%"
			pass_companycode = "{my_c_code}"
			pass_usercode = "{username.text}"
			pass_url="{my_pass_url}"
			pass_arr_kpimenu = "{arr_kpimenu}"
			pass_menu = "{pu_menu}"
			icon="@Embed('image/icon_bar1.png')"
			*/
			
			
		
			
			
			kpi.percentWidth = 100;
			kpi.percentHeight = 100;
			kpi.pass_companycode = g_changed_m_code;
			kpi.pass_url = my_pass_url;
			kpi.pass_arr_kpimenu = arr_kpimenu;
			kpi.pass_menu = "system";
			
			storeViews.selectedChild = kpi;
			
			
			
			// 
			//storeViews.addChild(kpi);
			
			/* Im not sure, but it works much faster when I removed the 'kpi.initialize() command.  */
			//kpi.initialize();
			
	}else {
		
		var s_ret:String = resultStatus(event.result.ezware_response.status, event.result.ezware_response.reason);  
		AlertMessageShow(s_ret);
		return;
		
	}
}

private function loginResultHandler(event:ResultEvent):void {
	
		text1.visible=true; 
	
	if ( event.result.status == 'OK' ) {
		

		/*
		 * Did we get messages (e.g., warnings about a password
		 * that's about to expire) from the server?
		 */
		
		if	(
			event.result.messages.length() > 0
			&&
			event.result.messages != ''
			) {
			
			AlertMessageShow	(
					'Messages - ' + event.result.messages.toString()
					
					);
		}
		
	//	var str_windxport:String = new String();
	//	str_windxport = event.result.windx_port;
		//Alert.show(str_windxport.length.toString());
		
		windx_port = event.result.windx_port;
		loginStatus = 'Starting session ...';
	    
		text1.visible=true;
		if (cb_speedoptions.selectedItem.data == 'standard'){
			pbar.visible=true;
		} else{
			pbar.visible=false;
		}
			
		/* Trigger browser to start WindX. */
		//////////////////////////////////////////////////////////////////////
		//var urWindX:URLRequest = new URLRequest();
		//urWindX.url=	"ae_tlstartwindx.php?sid="+
		//		event.result.sid;
		//navigateToURL( urWindX, '_blank' );
		//////////////////////////////////////////////////////////////////////////
		
		
		
		/* Get session information from result. */
		g_ccode		='L1';	/* NDY */
		g_sid		=event.result.sid;
	
		/* Checks whether the <windx_port>
		element is empty, and, if so, it does not invoke the javascript:startWindX
		function.*/
		
		if (windx_port.length > 0){ 
				var urWindX:URLRequest = new URLRequest();
				var WindXURL:String = "javascript:startWindX( '" + windx_port + "','" + g_sid + "');void(0)";
				urWindX.url=WindXURL;	
				navigateToURL( urWindX, "_self" );
		} 
		
		
		/* Start AreYouThere timer. */
		aytTime.start();
		
		if (logintype == 'conf_cp'){
			logintype = 'rl';
		}
		if (logintype == 'rl'){
		/* Save the Value of the Speed Option Connection to the Global Variable */
		
		httpGlobalVariableSo.url = "rd_settings.php?sid=" + g_sid + "&so=" + cb_speedoptions.selectedItem.data+ "&app=vl";
		httpGlobalVariableSo.send();     
			
		/* Check if user only has one job code */
		//Alert.show("original sid: " + event.result.sid);
		
		SystemMenuCheck();
		//return;
		
		
		//treeviewoperations.send();
		

		}
		  else if (logintype == 'cp'){
			 doLogout();
			btn_login.visible = false;
			currentState	= 'changePassword';
			newPassword.text = '';
			newPasswordAgain.text = '';
			cpwStatus.text = '';
			login_flag = false;
		}

		/* Switch us to the home page. */
		//companyCode.send();
	
	} else {

		/*
		 * Did the login fail because the user has to change their
		 * password?
		 */ 
		if (( event.result.status == 'CHANGEPW' )|| (logintype == 'conf_cp')) {
			login_flag = false;
			goToCPW( event.result.reason.toString() );

		} else {
			
			loginStatus = event.result.reason;
			
			
			var s_ret:String = resultStatus(event.result.status, event.result.reason);  
			loginStatus = s_ret;
			login_flag = false;
			
		}
	}
	
}

private function logoutResultHandler(event:ResultEvent):void {
	//Alert.show("go here 2: " + event.result.status);
	/* NDY: for now log out even if server failed */

	if ( event.result.status == 'OK' ) {
		finishLogout();
		
	}else {
		
		var s_ret:String = resultStatus(event.result.status, event.result.reason);  
		AlertMessageShow('logout failed - ' + s_ret);
		
	}
	
}

private function aytResultHandler(event:ResultEvent):void {
	
	if ( event.result.status != 'OK' ) {
		
		var s_ret:String = resultStatus(event.result.status, event.result.reason);  
		AlertMessageShow(s_ret);
		finishLogout();
		
		/*
		AlertMessageShow	(
				'AYT failed; logging out - ' + event.result.reason
				
				);
		finishLogout();
		*/
	}
	
	
	
}

private function runJobResultHandler(event:ResultEvent):void {

	if ( event.result.status != 'OK' ) {
		var s_ret:String = resultStatus(event.result.status, event.result.reason);  
		AlertMessageShow(s_ret);
	}
	
}

private function updateMyFavoriteSequenceResultHandler(event:ResultEvent):void {
	
	if ( event.result.status != 'OK' ) {
		var s_ret:String = resultStatus(event.result.status, event.result.reason);  
		AlertMessageShow(s_ret);
	}
	
}


private function updateMyShortcutSequenceResultHandler(event:ResultEvent):void {
	
	if ( event.result.status == 'OK' ) {
		reqParms = "REFRESH,RETRIEVE|MYSHORTCUTS|" +  username.text + "|" + g_changed_m_code + "|";  
		 
		retrieve_myshortcut_main.send();
		
	} else {
		var s_ret:String = resultStatus(event.result.status, event.result.reason);  
		AlertMessageShow(s_ret);
	}
	
}


[Bindable] public var ChainGroup:ArrayCollection = new ArrayCollection;
[Bindable] public var FormatChainGroup:ArrayCollection = new ArrayCollection;

private function chainCodeResultHandler(evt:ResultEvent):void {

	if ( evt.result.ezware_response.status == 'OK' ) {
	
	
				ChainGroup = new ArrayCollection;
			
				if (evt.result.ezware_response.refresh_data.chaingroup == null) {
			
					AlertMessageShow("You do not have the necessary access for " + g_changed_m_code +  ". Please contact your System Administrator.");
					FormatChainGroup = new ArrayCollection;
					my_pass_url = "REFRESH,RETRIEVE|SYSTEM|" + username.text+ "|" + g_changed_m_code + "|" + 'XX' + "|";
					httpp_kpi_srv.send();
				}
			
				if (evt.result.ezware_response.refresh_data.chaingroup != null) {
			
					if (evt.result.ezware_response.refresh_data.chaingroup.chain == null)
					{
						ChainGroup=new ArrayCollection()
					}
					else if (evt.result.ezware_response.refresh_data.chaingroup.chain is ArrayCollection)
					{
						ChainGroup=evt.result.ezware_response.refresh_data.chaingroup.chain;
					}
					else if (evt.result.ezware_response.refresh_data.chaingroup.chain is ObjectProxy)
					{
						ChainGroup = new ArrayCollection(ArrayUtil.toArray(evt.result.ezware_response.refresh_data.chaingroup.chain));
					}
			
					ChainGroup.refresh();
			
					var cg:Object = new Object();
					FormatChainGroup = new ArrayCollection;
					for (var i:int=0;i<ChainGroup.length;i++) {
						cg = new Object;
						var s_id:String = (ChainGroup[i]["id"]);
						var s_description:String = (ChainGroup[i]["description"]);
						cg.id = s_id;
						cg.description = s_description;
						FormatChainGroup.addItem(cg);
					}
			
					ChainCombo.selectedIndex = 0;
					  
					
					
					passChainGlobalVariable();
					
					/*  Set the accordion index */
					accordion_treeview.selectedIndex = int(g_tabset);
				
					// This is for the Menu Tree view
					for (var x:int=0;x<FormatChainGroup.length;x++) {
						treeviewoperations_xml = new XML;
						treeviewadministration_xml = new XML;
						if (FormatChainGroup[x]['id'] == '10'){
							reqParms_treeview = 'REFRESH,MENU_TREE,' + username.text +',' + g_changed_m_code + ',10';
							treeviewoperations.send(); 
						}
						if (FormatChainGroup[x]['id'] == '20'){
							reqParms_treeview = 'REFRESH,MENU_TREE,' + username.text +',' + g_changed_m_code + ',20';
							treeviewadministration.send();  
						}
 					}
					
					
					
					
					// My Favorites
					reqParms_treeview = "REFRESH,MYFAVORITES_TREE," + username.text + "," + g_changed_m_code;
					myfavoritestree.send();  
				
					
					
					
					// This is for the Shortcuts
					reqParms = "REFRESH,RETRIEVE|MYSHORTCUTS|" +  username.text + "|" + g_changed_m_code + "|";  
					retrieve_myshortcut_accordion.send();
					
					
					/*  because of time sync, MyFavorites should not be called since
						it is already calling changeAccordionheader(evt) at the end of its process.
						Just trying to minimize the http request as it slows down the process.
					*/
					if (accordion_treeview.selectedIndex != 2){
						changeAccordionheader(evt);  
					}   
				}
				
	}else {
		
		var s_ret:String = resultStatus(evt.result.ezware_response.status, evt.result.ezware_response.reason);  
		AlertMessageShow(s_ret);
		return;
		
	}		
				
}

[Bindable] public var my_c_code:String;
[Bindable] public var my_pass_url:String;
private var myAlert:Alert =  new Alert;
private function companyCodeResultHandler(evt:ResultEvent):void {

	
	if (evt.result.ezware_response.status == "OK"){
		if((evt.result.ezware_response.refresh_data.ae_profile.companies == null)||(evt.result.ezware_response.refresh_data.ae_profile.sysaccess == "N")){
			username.text = '';
			password.text = ''
			text1.visible=true;
			loginStatus = 'Access Denied. Please contact the System Administrator to gain access to Visible Logistics.';
			username.setFocus();
			username.drawFocus(true);
			pbar.visible=false;
			logoutstat = "Y";
			doLogout();
			return;
		}
   
	

	if (evt.result.ezware_response.refresh_data.ae_profile.companies.company_info == null)
	{
		tdcompany=new ArrayCollection()
	}
	else if (evt.result.ezware_response.refresh_data.ae_profile.companies.company_info is ArrayCollection)
	{
		tdcompany=evt.result.ezware_response.refresh_data.ae_profile.companies.company_info;
	}
	else if (evt.result.ezware_response.refresh_data.ae_profile.companies.company_info is ObjectProxy)
	{
		tdcompany = new ArrayCollection(ArrayUtil.toArray(evt.result.ezware_response.refresh_data.ae_profile.companies.company_info));
	} 
	
	tdcompany.refresh();
	//Alert.show(evt.message.body.toString());
	/*
	 * Go to second state.
	 *
	 * aprarn:  The currentState doesn't seem to change when I try to
	 * put this command at the end of this method.  I think it may
	 * have something to do with the second state object that should
	 * appear first before the current State.
	 */

	pbar.visible=false;
	//Alert.show("main view: " + evt.result.ezware_response.refresh_data.ae_profile.maint_view);
	//Alert.show("main rend: " + evt.result.ezware_response.refresh_data.ae_profile.maint_rend);

	
	
	
	g_username_description = (evt.result.ezware_response.refresh_data.ae_profile.name);
	g_tabset = (evt.result.ezware_response.refresh_data.ae_profile.default_tab);
	g_permanenttabset = int(g_tabset);
	
	my_c_code = evt.result.ezware_response.refresh_data.ae_profile.default_company;
	my_pass_url = "REFRESH,RETRIEVE|CHAINSYSTEM|" + username.text+ "|" + my_c_code + "|";
	
	
	httpAccessVariable.url = "rd_settings.php?sid=" + g_sid + "&ar=" + evt.result.ezware_response.refresh_data.ae_profile.maint_rend + "&av=" + evt.result.ezware_response.refresh_data.ae_profile.maint_view;
	//httpAccessVariable.url = "rd_settings.php?sid=" + g_sid + "&ar=" + "G" + "&av=" + "G";
	httpAccessVariable.send();
	
	// Go to the System Page
	login_flag = false;
	currentState	='main_dashhome';
	   
	 // set the tab default
	
	
	//settingstab.selectedIndex = int(g_tabset);
	
	//////////////////////////////////////
	/*  Fire Alert for Waiting Display */
	/*
	Alert.buttonWidth =141; 
	myAlert = Alert.show("","Retrieving Tree Views and Icons...",0,this,null,shazamIcon);  
	// modify the look of the Alert box
	myAlert.setStyle("backgroundColor", '#C3D9FA');
	myAlert.setStyle("borderColor", 0xffffff);
	myAlert.setStyle("borderAlpha", 0.75);
	myAlert.setStyle("fontSize", 14); 
	myAlert.setStyle("fontWeight", "bold");
	myAlert.setStyle("color", 0x000000); // text color
	*/
	///////////////////////////////////////
	
	
	//  Start Listener for Hover Help Timer 
	//nt = new Timer(TIMER_INTERVAL);
    //nt.addEventListener(TimerEvent.TIMER, nt_updateHoverTimer); 
	
	var notincc:int = 0;

	for (var i:int=0;i<tdcompany.length;i++)  {
		if (my_c_code == tdcompany[i].company){
			company_code.selectedIndex = i;
			changecode();
			notincc = notincc + 1;
		}
	}

	if (notincc == 0) {
		company_code.selectedIndex = 0
		changecode();
	}
	// set the tab default
	/*
	Alert.show(g_tabset);
	settingstab.selectedItem.data = int(g_tabset);
	Alert.show("done");    
	*/
	/*
	 * Since this is the 2nd state.  The detection and changing of
	 * resolution should be done here.
	 */
	//detectScreenResolutionSystemMenu(evt);
	//detectScreenResolutionforSystem();   
	}else {
		
		var s_ret:String = resultStatus(evt.result.ezware_response.status, evt.result.ezware_response.reason);  
		AlertMessageShow(s_ret);
		return;
		
	}
	
}




private function pre_pre_nt_mousehovering(event:Event):void{
	//Alert.show(accordion_treeview.selectedIndex.toString());
	   
	
	//click="{pre_pre_nt_mousehovering(event,'ViewPoint Logistics Options','ViewPoint Logistics Options','BUTTON')}"

	if (accordion_treeview.selectedIndex == 0){
		pre_nt_mousehovering(event,'Operations','Operations','BUTTON')  
	}
	if (accordion_treeview.selectedIndex == 1){
		pre_nt_mousehovering(event,'Administration','Administration','BUTTON')
	}
	if (accordion_treeview.selectedIndex == 2){
		pre_nt_mousehovering(event,'MyFavorites','MyFavorites','BUTTON')
	}
	if (accordion_treeview.selectedIndex == 3){
		pre_nt_mousehovering(event,'OneClicks','OneClicks','BUTTON') 
	}   
	if (accordion_treeview.selectedIndex == 4){
		pre_nt_mousehovering(event,'Menu Settings','Menu Settings','BUTTON')
	}
	
}
 

public function pre_nt_mousehovering(event:Event, object_title:String,object_id:String, object_type:String):void{
	
	if (hoverstatus == "OFF"){
		PopUpManager.removePopUp(pophoverinterface);
		mbdg_objecttitle = object_id;   
		mbdg_objecttitleheader =  object_type;
		mbdg_objecthelpfortitle = object_title;
		pre_nt_updateHoverTimer(event)
	}
	else {
		hoverstatus = 'OFF';
	}
}	

private function pre_nt_updateHoverTimer(evt:Event):void {
	
	//Alert.show(hoverstatus);
	pophoverinterface = MainMouseHoverMenu(
		PopUpManager.createPopUp(this, MainMouseHoverMenu,true));
	pophoverinterface.helpfortitleheader = mbdg_objecthelpfortitle;
	pophoverinterface.helpfortitle = mbdg_objecttitle;
	pophoverinterface.object_type = mbdg_objecttitleheader;
	pophoverinterface.item_code = mbdg_objecttitle;
	pophoverinterface.loc_sid = g_sid;
	pophoverinterface.loc_ccode = my_c_code;
	
}
public function nt_mousehovering(event:Event, object_title:String,object_id:String, object_type:String):void{		
				if (hoverstatus == "ON"){
		        	//baseTimer = getTimer();
                	mbdg_objecttitle = object_id;
					mbdg_objecttitleheader =  object_type;
					mbdg_objecthelpfortitle = object_title;
					//Alert.show(mbdg_objecttitle + ":" + mbdg_objecttitleheader+ ":" +mbdg_objecthelpfortitle);
                	nt = new Timer(TIMER_INTERVAL);
    				nt.addEventListener(TimerEvent.TIMER, nt_updateHoverTimer); 
                	nt.start(); 
                	 
        		}
}	
public var pophoverinterface:MainMouseHoverMenu;
public function nt_updateHoverTimer(evt:TimerEvent):void {
         		    
				//Alert.show(TimerEvent.TIMER.toString());
				nt.stop(); 
         		
             	pophoverinterface = MainMouseHoverMenu(
                PopUpManager.createPopUp(this, MainMouseHoverMenu,true));
               pophoverinterface.helpfortitleheader = mbdg_objecthelpfortitle;
                pophoverinterface.helpfortitle = mbdg_objecttitle;
                pophoverinterface.object_type = mbdg_objecttitleheader;
                pophoverinterface.loc_ccode = Application.application.company_code.selectedItem.company;
		 		pophoverinterface.item_code = mbdg_objecttitle;
				pophoverinterface.loc_sid = g_sid;
				nt.stop();    
         }




private function getSelectedChild(event:Event){
	passChainGlobalVariable();
  
	if (pu_menu == 'system'){
	
		getMenu(event);
	}
	if (pu_menu == 'subsystem'){
		
		RetrieveSubSystemMenu(g_syscode);
	}
	
	if (pu_menu == 'job'){
		
		//RetrieveJobMenu(g_syscode, g_subsyscode, "");
		RetrieveJobMenu(g_syscode, g_subsyscode);
	}
	
	
	accordion_treeview.selectedIndex = ChainCombo.selectedIndex;  
	tree_collapseChildrenOf(event);
	
	

}





private function getMenu(event:Event):void {

	passChainGlobalVariable();
	
	my_pass_url = "REFRESH,RETRIEVE|SYSTEM|" + username.text+ "|" + g_changed_m_code + "|" + ChainCombo.selectedItem.id + "|";
	
	httpp_kpi_srv.send();
}

private function getChain(event:Event):void {

	reqParms = "REFRESH,RETRIEVE|CHAINSYSTEM|" + username.text+ "|" + g_changed_m_code + "|";
	chainCode.send();
}

private function profileResultHandler(evt:ResultEvent):void {

	/*
	 * Expecting a single row for this XML.  Expecting the result as a
	 * string.
	 */
	passGlobalVariable();
}

private function globalvariableResultHandler(evt:ResultEvent):void {

	getChain(evt);
}

private function globalvariableChainResultHandler(evt:ResultEvent):void {

	/*
	 * Not expecting any result.  I'm not sure if this is a good
	 * practice of leaving this hanging but I will for now.
	 */
	if (evt.result.ezware_response.status != 'OK') {
		var s_ret:String = resultStatus(evt.result.ezware_response.status, evt.result.ezware_response.reason);  
		AlertMessageShow(s_ret);
		return;
	}
}
private function hoverhelpdomainHandler(evt:ResultEvent):void
		{
				hoverhelp_domain=evt.result.data.vldomain;
				company_logo=evt.result.data.logo; 
		}
private function faulthoverhelpdomainHandler(evt:FaultEvent):void
		{
			 	AlertMessageShow("Hover Help Domain does not exist");
		}		
private function ezlinkHandlerSystem(event:ResultEvent):void {
	if ( event.result.ezware_response.status == 'OK' ) {
		navigateToURL(new URLRequest(event.result.ezware_response.refresh_data.root.ezlink), 'quote')
	}else {
		
		var s_ret:String = resultStatus(event.result.ezware_response.status, event.result.ezware_response.reason);  
		AlertMessageShow(s_ret);
		return;
		
	}
}
private function sysjobrun(event:ResultEvent):void {
        		
        		if ( event.result.status != 'OK' ) {
					var s_ret:String = resultStatus(event.result.status, event.result.reason);  
					AlertMessageShow(s_ret);
					return;
        			
        		}
}
public function setHoverHelpOn(event:Event):void{
	PopUpManager.removePopUp(pophoverinterface); 
	hoverstatus = 'ON';
}
[Bindable]
public var resequence:Boolean = false; 
private function resetMyFavorites(event:Event):void{
	resequence = true;
reqParms_treeview = "REFRESH,MYFAVORITES_TREE," + username.text + "," + g_changed_m_code;
myfavoritestree.send();  


}


private function getmyshortcutHandler(evt:ResultEvent):void {
	if (evt.result.ezware_response.status != 'OK') {
		var s_ret:String = resultStatus(evt.result.ezware_response.status, evt.result.ezware_response.reason);  
		AlertMessageShow(s_ret);
		return;
	}
	if (evt.result.ezware_response.status == 'OK') {
		PopUpManager.removePopUp(popMyShortcutsCM); 
		clickMyShortcuts(evt);
	}     
	
	
}

private function ResultHandlerMyShortcut_Main_RetrieveAccordion(evt:ResultEvent):void{
	
	if (evt.result.ezware_response.status == 'OK' ) {
		
		MyShortcutCollectionMain = new ArrayCollection();
		
		if (evt.result.ezware_response.refresh_data.myshortcuts.myshortcut == null)
		{
			MyShortcutCollectionMain=new ArrayCollection()
		}
		else if (evt.result.ezware_response.refresh_data.myshortcuts.myshortcut is ArrayCollection)
		{
			MyShortcutCollectionMain=evt.result.ezware_response.refresh_data.myshortcuts.myshortcut;
		}
		else if (evt.result.ezware_response.refresh_data.myshortcuts.myshortcut is ObjectProxy)
		{
			MyShortcutCollectionMain = new ArrayCollection(ArrayUtil.toArray(evt.result.ezware_response.refresh_data.myshortcuts.myshortcut)); 
		}
		MyShortcutCollectionMain.refresh();
		
		
		//  Remove this for now.
		//changeAccordionheader(evt);
		  
		
	} else	{
		
		var s_ret:String = resultStatus(evt.result.ezware_response.status, evt.result.ezware_response.reason);  
		AlertMessageShow(s_ret);
		return;
	}				
	
	
	
}



private function ResultHandlerMyShortcut_Main_Retrieve(evt:ResultEvent):void{
	
	if (evt.result.ezware_response.status == 'OK' ) {
		
		MyShortcutCollectionMain = new ArrayCollection();
		
		if (evt.result.ezware_response.refresh_data.myshortcuts.myshortcut == null)
		{
			MyShortcutCollectionMain=new ArrayCollection()
		}
		else if (evt.result.ezware_response.refresh_data.myshortcuts.myshortcut is ArrayCollection)
		{
			MyShortcutCollectionMain=evt.result.ezware_response.refresh_data.myshortcuts.myshortcut;
		}
		else if (evt.result.ezware_response.refresh_data.myshortcuts.myshortcut is ObjectProxy)
		{
			MyShortcutCollectionMain = new ArrayCollection(ArrayUtil.toArray(evt.result.ezware_response.refresh_data.myshortcuts.myshortcut)); 
		}
		MyShortcutCollectionMain.refresh();
		
		//  Remove this for now.
		RetrieveMyShortcutPianokeys(evt);   
		  
	} else	{
		
		var s_ret:String = resultStatus(evt.result.ezware_response.status, evt.result.ezware_response.reason);  
		AlertMessageShow(s_ret);
		return;
	}				
	  
	
	
}



private function getshortcutpianokeysHandler(event:ResultEvent):void{
	if (event.result.ezware_response.refresh_data.jobs == null)
	{
		arr_shortcutmenu=new ArrayCollection();
		//	getjobHandler_designer(event);
	}
	if (event.result.ezware_response.refresh_data.jobs.group != null){
		if (event.result.ezware_response.refresh_data.jobs.group == null)
		{
			arr_shortcutmenu=new ArrayCollection()
			
		}  
		else if (event.result.ezware_response.refresh_data.jobs.group is ArrayCollection)
		{
			
			arr_shortcutmenu=event.result.ezware_response.refresh_data.jobs.group;
			
		}
		else if (event.result.ezware_response.refresh_data.jobs.group is ObjectProxy)
		{
			
			arr_shortcutmenu = new ArrayCollection(ArrayUtil.toArray(event.result.ezware_response.refresh_data.jobs.group));  
		}
		arr_shortcutmenu.refresh();
		AddtoShortcutMenu(event);
		//Alert.show(arr_shortcutmenu.length.toString());
	}		
}