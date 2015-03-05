// ActionScript file
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	public var globalcompanycode:ArrayCollection;
	public var global_total_companycode:int;
	public var global_total_systemchain:int;
	public var global_total_subsystemchain:int;
	public var global_total_jobmenuchain:int;
	public var global_total_systemkpiitem:int;
	public var global_total_subsystemkpiitem:int;
	public var global_total_jobmenukpiitem:int;
	[Bindable] public var systemcode:String;
	[Bindable] public var subsystemcode:String;
	public var subsystemname:String;
	[Bindable] public var jobmenucode:String;
	[Bindable] public var groupcode:String;
	[Bindable] public var straightjobprogram:String;
	public var chainsystemcode:String;
	public var chainsubsystemcode:String;
	[Bindable] public var chainjobmenucode:String;
	
	import mx.rpc.events.ResultEvent;
	import mx.rpc.events.FaultEvent;
	public function retglobalcompanycode():int{
			return global_total_companycode;
	}
	public function retglobalchain():int{
			return global_total_systemchain;
	}
	public function retglobalsystemkpidetail():int{
			return global_total_systemkpiitem;
	}
	
	private function straightsystemCompanyCodeResult(event:ResultEvent):void {
 		//  This is important.  Please take note of the default company.
 		//	Alert.show(event.result.ezware_response.refresh_data.ae_profile.default_company);
 		if (event.result.ezware_response.status == "OK"){
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
 			
 			// Checks for number of accessible company codes:
 			
 			if (event.result.ezware_response.refresh_data.ae_profile.companies.company_info == null)
				{
					globalcompanycode=new ArrayCollection()
			}
			else if (event.result.ezware_response.refresh_data.ae_profile.companies.company_info is ArrayCollection)
			{
					globalcompanycode=event.result.ezware_response.refresh_data.ae_profile.companies.company_info;
			}
			else if (event.result.ezware_response.refresh_data.ae_profile.companies.company_info is ObjectProxy)
			{
					globalcompanycode = new ArrayCollection(ArrayUtil.toArray(event.result.ezware_response.refresh_data.ae_profile.companies.company_info));
			}
				globalcompanycode.refresh();
 				global_total_companycode = globalcompanycode.length; 
 				//
				
 				if (global_total_companycode > 1){
 					StartApplication();
 						
 				}
 				if (global_total_companycode == 1){
 
 		        // if global_total_companycode //
 				//  Check for Chain //
 				
 				g_username_description = event.result.ezware_response.refresh_data.ae_profile.name;
 				g_changed_m_code = event.result.ezware_response.refresh_data.ae_profile.companies.company_info.company;
 				g_changed_m_codedescription = event.result.ezware_response.refresh_data.ae_profile.companies.company_info.company_desc; 
 				
				g_tabset = event.result.ezware_response.refresh_data.ae_profile.settab;
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////
 					
 					httpGlobalVariableSo.url = "rd_settings.php?sid=" + g_sid + "&u=" + g_usercode + "&n=" + g_username_description + "&c=" + g_changed_m_code + "&cd=" + g_changed_m_codedescription + "&mh=NO";
					httpGlobalVariableSo.send();
 					  
 					reqParms = "REFRESH,RETRIEVE|CHAINSYSTEM|" + username.text+ "|" + event.result.ezware_response.refresh_data.ae_profile.companies.company_info.company + "|";
					straightchainCode.send();
 		
 				///////////////////////////////////////////////////////////////////////////////////////////////////
 	
 
 				}	
 		
 		
		}else {
			
			var s_ret:String = resultStatus(event.result.ezware_response.status, event.result.ezware_response.reason);  
			AlertMessageShow(s_ret);
			return;
			
		}		
 			
 	}
 		private function straightsystemCompanyCodeFault(event:FaultEvent):void {
 			AlertMessageShow("Fault Event: " + event.message.body.toString());
 		}
 		
 		
 	///////////////////////////////  SYSTEM CHAIN ////////////////////////////////////////////////////
 	
 	private function straightchainCodeResultHandler(evt:ResultEvent):void {
		 		
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
					
						global_total_systemchain = ChainGroup.length; 
					
						if (global_total_systemchain > 1){
		 					StartApplication();
		 						
		 				}
				 		if (global_total_systemchain == 1){
		 				
		 					chainsystemcode = evt.result.ezware_response.refresh_data.chaingroup.chain.id
		 					httpChainGlobalVariable.url = "rd_settings.php?sid=" + g_sid + "&ch=" + evt.result.ezware_response.refresh_data.chaingroup.chain.id;	 
							httpChainGlobalVariable.send();
		 					my_pass_url = "REFRESH,RETRIEVE|SYSTEM|" + username.text+ "|" + g_changed_m_code + "|" + evt.result.ezware_response.refresh_data.chaingroup.chain.id + "|";
							straighthttpp_kpi_srv.send();
		 				
		 				
		 				}	
		 			
				}
		}else {
			
			var s_ret:String = resultStatus(evt.result.ezware_response.status, evt.result.ezware_response.reason);  
			AlertMessageShow(s_ret);
			return;
			
		}
 	}
 	
 		private function straightchainCodeFaultHandler(event:FaultEvent):void {
 			AlertMessageShow("Fault Event: " + event.message.body.toString());
 		}
 	
 	///////////////////////////  End SYSTEM CHAIN  /////////////////////////////////////////////////// 	
 		
 		
 		//////////////////////////////  START KPI DETAIL ITEMS ////////////////////////////////////////////
 		
 		private function straightKPIMenuResultHandler(event:ResultEvent):void {
			 	
			if ( event.result.ezware_response.status == 'OK' ) {
			
			
			
						arr_kpimenu=new ArrayCollection();
					if (event.result.ezware_response.refresh_data.systems == null)
					{
						arr_kpimenu=new ArrayCollection()
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
						global_total_systemkpiitem = arr_kpimenu.length; 
						
						if (global_total_systemkpiitem > 1){
			 					StartApplication();
			 			}
						if (global_total_systemkpiitem == 1){
							systemcode = event.result.ezware_response.refresh_data.systems.system.code;
							CheckSystemItems();
						}
		
			
			}else {
				
				var s_ret:String = resultStatus(event.result.ezware_response.status, event.result.ezware_response.reason);  
				AlertMessageShow(s_ret);
				return;
				
			}	
		}

 		
 		///////////////////////////////////////////////////////////////////////////////////////////////////////
 		
 		
 		
 		////////////////  Start Sub System Chain //////////////////////////////
 		
 		private function straightsubsystemchainCodeResultHandler(evt:ResultEvent):void {
			if ( evt.result.ezware_response.status == 'OK' ) {
					ChainGroup = new ArrayCollection;
					if (evt.result.ezware_response.refresh_data.chaingroup == null){
						AlertMessageShow("You do not have the necessary access for " +  g_changed_m_code +  ". Please contact your System Administrator.");
					} 
					if (evt.result.ezware_response.refresh_data.chaingroup != null){
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
						global_total_subsystemchain = ChainGroup.length; 
						
						if (global_total_subsystemchain > 1){
		 					StartSubSystem();
		 				}
				 		if (global_total_subsystemchain == 1){
				 			chainsubsystemcode = evt.result.ezware_response.refresh_data.chaingroup.chain.id
		 					reqParms = "REFRESH,RETRIEVE|SUBSYSTEM|" + username.text+ "|" + g_changed_m_code + "|" + chainsubsystemcode + "|" + systemcode + "|";
							straightss_httpp_kpi_srv.send();
		  				}
					}		
			}else {
				
				var s_ret:String = resultStatus(evt.result.ezware_response.status, evt.result.ezware_response.reason);  
				AlertMessageShow(s_ret);
				return;
				
			}	
		}
 		////////////////  End Sub System Chain //////////////////////////////
		
		
 		//////////////////////////////  START KPI SUB SYSTEM DETAIL ITEMS ////////////////////////////////////////////
 		
		private function straightSubSystemKPIMenuResultHandler(event:ResultEvent):void {
					
			if ( event.result.ezware_response.status == 'OK' ) {
			
					if (event.result.ezware_response.refresh_data.subsystems == null)
		            {
		                arr_kpimenu=new ArrayCollection()
		            }
					if (event.result.ezware_response.refresh_data.subsystems.subsystem != null){
						
						if (event.result.ezware_response.refresh_data.subsystems.subsystem == null)
		            	{
		                	arr_kpimenu=new ArrayCollection()
		            	}
		            	else if (event.result.ezware_response.refresh_data.subsystems.subsystem is ArrayCollection)
		            	{
		              		arr_kpimenu=event.result.ezware_response.refresh_data.subsystems.subsystem;
		            	}
		            	else if (event.result.ezware_response.refresh_data.subsystems.subsystem is ObjectProxy)
		            	{
		            	arr_kpimenu = new ArrayCollection(ArrayUtil.toArray(event.result.ezware_response.refresh_data.subsystems.subsystem));  
		            	}
						arr_kpimenu.refresh();
						
						global_total_subsystemkpiitem = arr_kpimenu.length
						if (global_total_subsystemkpiitem > 1){
		 					StartSubSystem();
		 				}
				 		if (global_total_subsystemkpiitem == 1){
				 			/* Update rd_settings session variables */
				 			
				 			httpChainGlobalVariable.url = "rd_settings.php?sid=" + g_sid + "&ch=" + chainsubsystemcode;	 
							httpChainGlobalVariable.send();
							subsystemcode = event.result.ezware_response.refresh_data.subsystems.subsystem.code;
							subsystemname = event.result.ezware_response.refresh_data.subsystems.subsystem.name;
		  					/* No need to check for the validation.  Go straight to Job Menu function. */
		  					CheckJobMenu();
		  				}
						
					}
			
			}else {
				
				var s_ret:String = resultStatus(event.result.ezware_response.status, event.result.ezware_response.reason);  
				AlertMessageShow(s_ret);
				return;
				
			}
			
		} 		
 		//////////////////////////////  END KPI SUB SYSTEM DETAIL ITEMS ////////////////////////////////////////////
 		////////////////////////////  Start Job Menu Chain ////////////////////////////////////////////////
 			private function straightjobchainCodeResultHandler(evt:ResultEvent):void {
				
				if ( evt.result.ezware_response.status == 'OK' ) {
			 			ChainGroup = new ArrayCollection;
						if (evt.result.ezware_response.refresh_data.chaingroup == null){
							AlertMessageShow("You do not have the necessary access for " +  g_changed_m_code +  ". Please contact your System Administrator.");
							return
						} 
						
						if (evt.result.ezware_response.refresh_data.chaingroup != null){
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
								global_total_jobmenuchain = ChainGroup.length; 
								httpChainGlobalVariable.url = "rd_settings.php?sid=" + g_sid + "&sc=" + systemcode;	 
								httpChainGlobalVariable.send();
								if (global_total_jobmenuchain != 1){
			 						StartJobMenu();
			 					}
			 					if (global_total_jobmenuchain == 1){
			 						chainjobmenucode = evt.result.ezware_response.refresh_data.chaingroup.chain.id;
			 						httpChainGlobalVariable.url = "rd_settings.php?sid=" + g_sid + "&ch=" + chainjobmenucode;	 
									httpChainGlobalVariable.send();
			 						reqParms = "REFRESH,RETRIEVE|JOB|" + username.text+ "|" + g_changed_m_code + "|" + chainjobmenucode+ "|" + systemcode + "|" + subsystemcode + "|";
									straightjm_httpp_kpi_srv.send();
			 					}
						}
 		
				
				}else {
					
					var s_ret:String = resultStatus(evt.result.ezware_response.status, evt.result.ezware_response.reason);  
					AlertMessageShow(s_ret);
					return;
					
				}	
			}
 		
 		
 		private function straightJobFunctionMenuResultHandler(event:ResultEvent):void {
			if ( event.result.ezware_response.status == 'OK' ) {			 
						var arr_groupjob:ArrayCollection = new ArrayCollection;
					
						if (event.result.ezware_response.refresh_data.jobs == null)
			            {
			                arr_kpimenu=new ArrayCollection()
			            }
			            
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
							
							if (arr_kpimenu.length > 1){
									StartJobMenu();
			 				}
							if (arr_kpimenu.length == 1){
									groupcode = event.result.ezware_response.refresh_data.jobs.group.id;
									arr_groupjob = new ArrayCollection;
										if (event.result.ezware_response.refresh_data.jobs.group.job == null)
			            				{
			                					arr_groupjob=new ArrayCollection()
			            				}
			             				else if (event.result.ezware_response.refresh_data.jobs.group.job is ArrayCollection)
			            				{
			              						arr_groupjob=event.result.ezware_response.refresh_data.jobs.group.job;
			            				}
			            				else if (event.result.ezware_response.refresh_data.jobs.group.job is ObjectProxy)
			            				{
			            					arr_groupjob = new ArrayCollection(ArrayUtil.toArray(event.result.ezware_response.refresh_data.jobs.group.job));  
			            				}
			    							arr_groupjob.refresh();
			 							
									
										if (arr_groupjob.length > 1){
											StartJobMenu();
										}
										if (arr_groupjob.length == 1){
											global_total_jobmenukpiitem = arr_groupjob.length; 
											// testing purposes //
											//global_total_jobmenukpiitem = 1;
											
												if ((event.result.ezware_response.refresh_data.jobs.group.job.job_id).length == 1){
			    		        				  	//companyCode.send();
			    		        				   //navigateToURL(new URLRequest(event.result.ezware_response.refresh_data.jobs.group.job.job_program),'_blank');
			        								//straightjobprogram = event.result.ezware_response.refresh_data.jobs.group.job.job_program.toString();
			        								 navigateToURL(new URLRequest(event.result.ezware_response.refresh_data.jobs.group.job.job_program.toString()),'_blank');
			        								StartHighViewSecurity();
			        							}
			        							if ((event.result.ezware_response.refresh_data.jobs.group.job.job_id).length > 1){ 
			   										//straightgetSessionID.send(); 
			   										reqSJ = event.result.ezware_response.refresh_data.jobs.group.job.job_id
			   										systemcode = chainjobmenucode + systemcode.substr(2,systemcode.length);
			        								subsystemcode = chainjobmenucode + subsystemcode.substr(2,subsystemcode.length);
			        								jobmenucode = event.result.ezware_response.refresh_data.jobs.group.job.code
			        								/*
			        								Alert.show("chainjobmenucode: " + chainjobmenucode +
																	" systemcode: " +  systemcode +
																	" subsystemcode: " +  subsystemcode +
																	" groupcode: " +  groupcode +
																	" jobmenucode: " +  jobmenucode);
			        								*/
			        								StartJobSecurity();
			        								
														
			        							}
			 						
										}
							}		
							
						}
						
						// time to refresh the KPI Menu records
						
						
			}else {
				
				var s_ret:String = resultStatus(event.result.ezware_response.status, event.result.ezware_response.reason);  
				AlertMessageShow(s_ret);
				return;
				
			}		
		}
	public function straightJobFunctionMenuFaultHandler(event:FaultEvent):void {
		AlertMessageShow("Unknown Format of Job Detail XML");
	}
	
	private function straightJobRun(event:ResultEvent):void {
        		
        		
        		if ( event.result.status == 'OK' ) {
					doLogout();
        			
        		}else {
		
						var s_ret:String = resultStatus(event.result.status, event.result.reason);  
						AlertMessageShow(s_ret);
						return;
						
				}
        		
        	}


	private function ALListHandler(event:ResultEvent):void{
				//Alert.show(event.message.toString()); 
				//txta_code.text = event.result.result.code;
				//txta_area.text = event.result.result.message;
				if (event.result.result.code == 1){
					//loginStatus = "Arboretum " +  event.result.result.message;
					
					loginStatus = event.result.result.message;
					//Alert.show(loginStatus);
					return;
				}
				
		}



	
 		//////////////////////////////////////////////////////////////////////////////////////////////