// ActionScript file
import mx.collections.ArrayCollection;
import mx.rpc.events.ResultEvent;
import mx.utils.ArrayUtil;
import mx.utils.ObjectProxy;
[Bindable]
private var local_chain:String;
[Bindable]
public var local_systemcode:String;
[Bindable]
public var local_jobmenucode:String;
[Bindable]
public var local_subsystemcode:String;
[Bindable]
public var local_subsystemname:String 
[Bindable]
public var local_chainjobmenucode:String
[Bindable]
public var local_groupcode:String
[Bindable]
public var local_reqSJ:String;
public function CheckSubSystemChain():void{
	/* 		
		Alert.show(Application.application.company_code.selectedItem.company);

		Alert.show(Application.application.username.text);
		Alert.show(item.code);
		*/	
			reqParms = "REFRESH,RETRIEVE|CHAINSUBSYSTEM|" + Application.application.username.text+ "|" + Application.application.company_code.selectedItem.company + "|" + item.code+ "|"
			
			loc_straightsubsystemchainCode.send();
			
}


private function loc_straightsubsystemchainCodeResultHandler(evt:ResultEvent):void {
			
	if ( evt.result.ezware_response.status == 'OK' ) {
	
					var ChainGroup:ArrayCollection = new ArrayCollection;
					
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
							var tot:int = 2
							
							if (ChainGroup.length > 1){
							 /* Run Subsystem */
							// Alert.show(my_c_code);
							 navigateToURL(new URLRequest('subsystemsmenu.php?sys=' + item.code + '&c='+ Application.application.company_code.selectedItem.company+ '&cd='+ Application.application.company_code.selectedItem.company_desc),'_blank');
		 					}
						if (ChainGroup.length == 1){
				 			local_chain = evt.result.ezware_response.refresh_data.chaingroup.chain.id;
		 					reqParms = "REFRESH,RETRIEVE|SUBSYSTEM|" + Application.application.username.text + 
		 								"|" + Application.application.company_code.selectedItem.company + "|" + 
		 								evt.result.ezware_response.refresh_data.chaingroup.chain.id + 
		 								"|" + item.code + "|";
							loc_straightss_httpp_kpi_srv.send();
		  				}
		  				 //	result="straightSubSystemKPIMenuResultHandler(event)"
					}	
					
	}else {
		
		var s_ret:String = resultStatus(evt.result.ezware_response.status, evt.result.ezware_response.reason);  
		AlertMessageShow(s_ret);
		return;
		
	}				
}

private function loc_straightSubSystemKPIMenuResultHandler(event:ResultEvent):void {
	if ( event.result.ezware_response.status == 'OK' ) {
	
							var arr_kpimenu:ArrayCollection = new ArrayCollection;
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
								
								var tot:int = 2;
								
								if (arr_kpimenu.length > 1){
								
				 					navigateToURL(new URLRequest('subsystemsmenu.php?sys=' + item.code+ '&c='+ Application.application.company_code.selectedItem.company+ '&cd='+ Application.application.company_code.selectedItem.company_desc),'_blank');;
				 				}
						 		if (arr_kpimenu.length == 1){
						 			// Update rd_settings session variables 
						 			
						 			loc_httpChainGlobalVariable.url = "rd_settings.php?sid=" + ir_sid + "&ch=" + local_chain;	 
									loc_httpChainGlobalVariable.send();
								
									local_subsystemcode = event.result.ezware_response.refresh_data.subsystems.subsystem.code;
									local_subsystemname = event.result.ezware_response.refresh_data.subsystems.subsystem.name;
				  					// No need to check for the validation.  Go straight to Job Menu function. 
				  					//CheckJobMenu();
				  					reqParms = "REFRESH,RETRIEVE|CHAINJOB|" + Application.application.username.text + "|" + 
				  								Application.application.company_code.selectedItem.company + 
				  								"|" + item.code + 
				  								"|" + local_subsystemcode + "|";
									loc_straightjobchainCode.send();
				  				}
				  	}	
							
							
	}else {
		
		var s_ret:String = resultStatus(event.result.ezware_response.status, event.result.ezware_response.reason);  
		AlertMessageShow(s_ret);
		return;
		
	}					
}
		private function loc_straightjobchainCodeResultHandler(evt:ResultEvent):void {
			if ( evt.result.ezware_response.status == 'OK' ) {
		 			var ChainGroup:ArrayCollection = new ArrayCollection;
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
							httpChainGlobalVariable.url = "rd_settings.php?sid=" + ir_sid + "&sc=" + item.code;	 
							httpChainGlobalVariable.send();
							if (ChainGroup.length > 1){
		 						 navigateToURL(new URLRequest('jobmenu.php?subsys=' + local_subsystemcode + '&subname=' + local_subsystemname+ '&c='+ Application.application.company_code.selectedItem.company+ '&cd='+ Application.application.company_code.selectedItem.company_desc),'_blank');
		 					}
		 					if (ChainGroup.length == 1){
		 						local_chainjobmenucode = evt.result.ezware_response.refresh_data.chaingroup.chain.id;
		 						httpChainGlobalVariable.url = "rd_settings.php?sid=" + ir_sid + "&ch=" + local_chainjobmenucode;	 
								httpChainGlobalVariable.send();
		 						reqParms = "REFRESH,RETRIEVE|JOB|" + Application.application.username.text + 
		 							"|" + Application.application.company_code.selectedItem.company + 
		 							"|" + local_chainjobmenucode+ "|" + item.code + "|" + local_subsystemcode + "|";
								loc_straightjm_httpp_kpi_srv.send();
		 					}
		 					
					}
			}else {
				
				var s_ret:String = resultStatus(evt.result.ezware_response.status, evt.result.ezware_response.reason);  
				AlertMessageShow(s_ret);
				return;
				
			}	
 		}
 		
 		
 		
 private function loc_straightJobFunctionMenuResultHandler(event:ResultEvent):void {
	 
	 if ( event.result.ezware_response.status == 'OK' ) {
						 var arr_kpimenu:ArrayCollection = new ArrayCollection;
						var arr_groupjob:ArrayCollection = new ArrayCollection;
					//Alert.show( "Checkpoint 1: " + Application.application.company_code.selectedItem.company);
					//Alert.show( "Checkpoint 2: " + Application.application.company_code.selectedItem.company_desc);
					//Alert.show( "Checkpoint 2: " + Application.application.parameters.cd);
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
									 navigateToURL(new URLRequest('jobmenu.php?subsys=' + local_subsystemcode + '&subname=' + local_subsystemname+ '&c='+ Application.application.company_code.selectedItem.company + '&cd='+ Application.application.company_code.selectedItem.company_desc),'_blank');
									
							}
							if (arr_kpimenu.length == 1){
									local_groupcode = event.result.ezware_response.refresh_data.jobs.group.id;
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
											 navigateToURL(new URLRequest('jobmenu.php?subsys=' + local_subsystemcode + '&subname=' + local_subsystemname+ '&c='+ Application.application.company_code.selectedItem.company+ '&cd='+ Application.application.company_code.selectedItem.company_desc),'_blank');
											  
										}
										
										if (arr_groupjob.length == 1){
											//global_total_jobmenukpiitem = arr_groupjob.length; 
											// testing purposes //
											//global_total_jobmenukpiitem = 1;
											
												if ((event.result.ezware_response.refresh_data.jobs.group.job.job_id).length == 1){
			    		        				  	//companyCode.send();
			    		        				   //navigateToURL(new URLRequest(event.result.ezware_response.refresh_data.jobs.group.job.job_program),'_blank');
			        								//straightjobprogram = event.result.ezware_response.refresh_data.jobs.group.job.job_program.toString();
			        							//	StartHighViewSecurity();
													/*Alert.show(Application.application.parameters.c);*/
													/* Not passing the Application.application.parameters.c    WHY???? */
			        								 //navigateToURL(new URLRequest(event.result.ezware_response.refresh_data.jobs.group.job.job_program.toString()+ '&c='+ Application.application.parameters.c+ '&cd='+ Application.application.parameters.cd),'_blank');
													   navigateToURL(new URLRequest(event.result.ezware_response.refresh_data.jobs.group.job.job_program.toString()+ '&c='+ Application.application.company_code.selectedItem.company+ '&cd='+  Application.application.company_code.selectedItem.company_desc),'_blank');
			        							}
			        							if ((event.result.ezware_response.refresh_data.jobs.group.job.job_id).length > 1){ 
			   										//straightgetSessionID.send(); 
			   										local_reqSJ = event.result.ezware_response.refresh_data.jobs.group.job.job_id
			   										local_systemcode = item.code;
			   										local_systemcode = local_chainjobmenucode + local_systemcode.substr(2,local_systemcode.length);
			        								local_subsystemcode = local_chainjobmenucode + local_subsystemcode.substr(2,local_subsystemcode.length);
			        								local_jobmenucode = event.result.ezware_response.refresh_data.jobs.group.job.code
			        								/*
			        								Alert.show("chainjobmenucode: " + local_chainjobmenucode +
																	" systemcode: " +  local_systemcode +
																	" subsystemcode: " +  local_subsystemcode +
																	" groupcode: " +  local_groupcode  +
																	" jobmenucode: " +  local_jobmenucode);
			        								*/
			        								//StartJobSecurity();
			        								loc_straightnavigateJobProgram_job.send();
														
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