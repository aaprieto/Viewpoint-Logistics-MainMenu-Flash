		// ActionScript file
		
		import mx.collections.ArrayCollection;
		import mx.rpc.events.FaultEvent;
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
		       
		
		private function hoverhelpdomainHandler(evt:ResultEvent):void
		{
			hoverhelp_domain=evt.result.data.domain;
			company_logo=evt.result.data.logo;
			//for mylogistics
			myloghoverhelp_domain = evt.result.data.mldomain;
			//myloggettingstartedhoverhelp_domain = evt.result.data.myloggettingstarteddomain;
			myloggettingstartedhoverhelp_domain = evt.result.data.mldomain;
		}
		private function configcompanynameHandler(evt:ResultEvent):void
		{
			/* Do not touch the file, this is updated by Christine. */
			corporate_name = evt.result.data.corporate_name;
		}

		private function faulthoverhelpdomainHandler(evt:FaultEvent):void
		{
			AlertMessageShow("Hover Help Domain does not exist");
		}
		private function faultconfigcompanycodeHandler(evt:FaultEvent):void
		{
			AlertMessageShow("Configuration File for Company Name does not exist");
		}
		private function loginResultHandler(event:ResultEvent):void {
			
			/////////////////////////////////
			
			/*
			
			if ( event.result.status != 'OK' ) {
				cpwStatus.text = event.result.reason.toString();
				return;
			}
			
			
			cpwStatus.text		= "The password was changed.";
			cpwChangeButton.visible	= false;
			cpwCancelButton.visible = false;
			cpwOKButton.visible	= true;
			newPassword.enabled = false;
			newPasswordAgain.enabled = false;
			password.text = newPassword.text;
		
			g_sid		=event.result.sid;
			
			*/
			////////////////////////////////////
			text1.visible=true; 
			if ( event.result.ezware_response.status == 'OK' ) {
				
				 
				/*
				* Did we get messages (e.g., warnings about a password
				* that's about to expire) from the server?
				*/
				
				var str_msg:String = event.result.ezware_response.messages;
				if (str_msg == null){
					str_msg = '';
				}
			
			
				if	(
					str_msg.length > 0
					&&
					str_msg != ''
				) {
					
					if ((logintype == 'rl')||(logintype == 'conf_cp')){
						AlertMessageShow	(
							'Messages - ' + event.result.ezware_response.messages.toString()
							
						);
					}
				}
				
			
			
				if((event.result.ezware_response.refresh_data.ae_profile.companies == null)||(event.result.ezware_response.refresh_data.ae_profile.sysaccess == "N")){
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
			
				
				loginStatus = 'Starting session ...';
				
				text1.visible=true;
				if (cb_speedoptions.selectedItem.data == 'standard'){
					pbar.visible=true;
				} else{
					pbar.visible=false;
				}
				/* Get session information from result. */
				g_sid = event.result.ezware_response.sid;
				tdcompany=new ArrayCollection();
				if (event.result.ezware_response.refresh_data.ae_profile.companies.company_info == null)
				{
					
					tdcompany=new ArrayCollection();
				}
				else if (event.result.ezware_response.refresh_data.ae_profile.companies.company_info is ArrayCollection)
				{
					
					tdcompany=event.result.ezware_response.refresh_data.ae_profile.companies.company_info;
				}
				else if (event.result.ezware_response.refresh_data.ae_profile.companies.company_info is ObjectProxy)
				{
					
					tdcompany = new ArrayCollection(ArrayUtil.toArray(event.result.ezware_response.refresh_data.ae_profile.companies.company_info));
				}
				
				tdcompany.refresh();
				var str_crcc:String = new String(); 
					
				for (var a:int=0;a<tdcompany.length;a++) {
					if (tdcompany[a]["client_restrictions"] != null){
							str_crcc = tdcompany[a]["client_restrictions"]["client"]["code"];
							break;
					}
				}  
				
				
				//  Alert.show(str_crcc);
				
				/*
				* Go to second state.
				*
				* aprarn:  The currentState doesn't seem to change when I try to
				* put this command at the end of this method.  I think it may
				* have something to do with the second state object that should
				* appear first before the current State.
				*/
				if (logintype == 'conf_cp'){
					logintype = 'rl';
				}
				if (logintype == 'rl'){
				
				g_username_description = (event.result.ezware_response.refresh_data.ae_profile.name);
				my_c_code = event.result.ezware_response.refresh_data.ae_profile.default_company;
				for (var i:int=0;i<tdcompany.length;i++) {
					if (my_c_code == tdcompany[i]["company"]){
						g_changed_m_codedescription = tdcompany[i]["company_desc"];
						break;
					}
				} 
					httpAccessVariable.url = "rd_settings.php?sid=" + g_sid + 
											"&ar=" + event.result.ezware_response.refresh_data.ae_profile.maint_rend + 
											"&av=" + event.result.ezware_response.refresh_data.ae_profile.maint_view +
											"&so=" + cb_speedoptions.selectedItem.data+ 
											"&app=ml" + 
											"&u=" + g_usercode + 
											"&n=" + g_username_description + 
											"&c=" + my_c_code + 
											"&cd=" + g_changed_m_codedescription + 
											"&mh=NO" + 
											"&crcc=" + str_crcc;
		
				httpAccessVariable.send();
				
			
				
				// Go to the System Page
				login_flag = false;
				currentState	='main_dashhome';
				} else if (logintype == 'cp'){
					doLogout();
					btn_login.visible = false;
					currentState	= 'changePassword';
					newPassword.text = '';
					newPasswordAgain.text = '';
					cpwStatus.text = '';
				}
				
			} else {
				
				/*
				* Did the login fail because the user has to change their
				* password?
				*/     
				
				if (( event.result.ezware_response.status == 'CHANGEPW' )|| (logintype == 'conf_cp')) {
					login_flag = false;
					goToCPW( event.result.ezware_response.reason.toString() );
					
					
				} else if  ( event.result.ezware_response.status == 'EXPIRED' ) {
					AlertMessageShow("Session expired due to inactivity");
					login_flag = false;
					return;
				}  		else {
					
					loginStatus = event.result.ezware_response.reason;
					login_flag = false;
				}
			}	
		}
		private function hsFaultHandler(event:FaultEvent):void {
			
			AlertMessageShow	(
				'HTTP request failed'
			);	
			login_flag = false;
		}
		
		private function logoutResultHandler(event:ResultEvent):void {
			if ( event.result.status != 'OK' ) {
				
				AlertMessageShow	(
					'logout failed - ' + event.result.reason
				);
			}
			login_flag = false;
			finishLogout();
		}
		private function speciallogoutResultHandler(event:ResultEvent):void {
			if ( event.result.status != 'OK' ) {
				
				AlertMessageShow	(
					'logout failed - ' + event.result.reason
				);
			}
			specialfinishLogout();
		}
		private function KPIMenuResultHandler(event:ResultEvent):void {
			if (event.result.ezware_response.status == 'OK'){
					arr_kpimenu=new ArrayCollection();
					if (event.result.ezware_response.refresh_data.mljobs == null)
					{
						arr_kpimenu=new ArrayCollection()
					}
					
					if (event.result.ezware_response.refresh_data.mljobs.mljob != null) {
						
						if (event.result.ezware_response.refresh_data.mljobs.mljob == null)
						{
							arr_kpimenu=new ArrayCollection()
						}
						else if (event.result.ezware_response.refresh_data.mljobs.mljob is ArrayCollection)
						{
							arr_kpimenu=event.result.ezware_response.refresh_data.mljobs.mljob;
						}
						else if (event.result.ezware_response.refresh_data.mljobs.mljob is ObjectProxy)
						{
							arr_kpimenu = new ArrayCollection(ArrayUtil.toArray(event.result.ezware_response.refresh_data.mljobs.mljob));
						}
						arr_kpimenu.refresh();
					}
					
					
					
					
				//	detectScreenResolutionforSystem();   
					/* Time to refresh the KPI Menu records. */
					
					if (cb_speedoptions.selectedItem.data =='basic'){
						for (var i:int=0;i<arr_kpimenu.length;i++) {
							arr_kpimenu[i].image = '';
						} 
					}
					//currentState	='main_dashhome';
					kpi.pass_url = my_pass_url;
					kpi.pass_arr_kpimenu = arr_kpimenu;
					//Alert.show("go here");
					
					
			} else if (event.result.ezware_response.status == 'EXPIRED'){
				AlertMessageShow("Session EXPIRED due to inactivity.  Please log out and log back in again to create a new session.");
				return;
			}	else {
			
				AlertMessageShow(event.result.ezware_response.status);
				return; 
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

		public function setHoverHelpOn(event:Event):void{
			PopUpManager.removePopUp(pophoverinterface); 
			hoverstatus = 'ON';
		}
		private function nt_mousehovering(event:Event, object_title:String,object_id:String, object_type:String):void{		
			if (hoverstatus == "ON"){
				mbdg_objecttitle = object_id;
				mbdg_objecttitleheader =  object_type;
				mbdg_objecthelpfortitle = object_title;
				nt = new Timer(TIMER_INTERVAL);
				nt.addEventListener(TimerEvent.TIMER, nt_updateHoverTimer); 
				nt.start(); 
				
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
			{
				mousehoverpars = "NO";
				mousehoverparslabel = "OFF"
			}
			*/
			
			
			
			
			
			
		}	



		public var pophoverinterface:MainMouseHoverMenu;
		
		private function nt_updateHoverTimer(evt:TimerEvent):void {
			nt.stop(); 
			
			pophoverinterface = MainMouseHoverMenu(
				PopUpManager.createPopUp(this, MainMouseHoverMenu,true));
			pophoverinterface.helpfortitleheader = mbdg_objecthelpfortitle;
			pophoverinterface.helpfortitle = mbdg_objecttitle;
			pophoverinterface.object_type = mbdg_objecttitleheader;
			pophoverinterface.item_code = mbdg_objecttitle;
			pophoverinterface.loc_sid = g_sid;
			pophoverinterface.loc_ccode = my_c_code;
			
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