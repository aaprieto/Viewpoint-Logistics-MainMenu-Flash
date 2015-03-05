// ActionScript file
import mx.collections.ArrayCollection;
import mx.rpc.events.ResultEvent;
import mx.utils.ArrayUtil;
import mx.utils.ObjectProxy;


[Bindable]
public var local_chainjobmenucode:String;
[Bindable]
public var local_groupcode:String;
[Bindable]
public var local_reqSJ:String;


[Bindable]
public var local_systemcode:String;
[Bindable]
public var local_jobmenucode:String;
[Bindable]
public var local_subsystemcode:String;
[Bindable]
public var local_subsystemname:String 



public function CheckJobMenuChain():void{ 
			reqParms = "REFRESH,RETRIEVE|CHAINJOB|" + Application.application.usercode + "|" + 
  								Application.application.comp_code + 
  								"|" + Application.application.syscode + 
  								"|" + item.code + "|";
  		
		loc_straightjobchainCode.send(); 
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
			
			
				//	Alert.show('&c='+ Application.application.parameters.c);
			
					ChainGroup.refresh();
					httpChainGlobalVariable.url = "rd_settings.php?sid=" + ir_sid + "&sc=" + Application.application.syscode;	 
					httpChainGlobalVariable.send();
					var t:int = 2;
					if (ChainGroup.length > 1){
 						 navigateToURL(new URLRequest('jobmenu.php?subsys=' + item.code + '&subname=' + item.name + '&c='+ Application.application.parameters.c + '&cd='+ Application.application.parameters.cd ),'_blank');
 					}
 					if (ChainGroup.length == 1){
 						local_chainjobmenucode = evt.result.ezware_response.refresh_data.chaingroup.chain.id;
 						httpChainGlobalVariable.url = "rd_settings.php?sid=" + ir_sid + "&ch=" + local_chainjobmenucode;	 
						httpChainGlobalVariable.send();
 						reqParms = "REFRESH,RETRIEVE|JOB|" + Application.application.usercode + 
 							"|" + Application.application.comp_code + 
 							"|" + local_chainjobmenucode+ "|" + Application.application.syscode + "|" + item.code + "|";
						loc_straightjm_httpp_kpi_srv.send();
 					}
 					
			}
			
	}else if (evt.result.ezware_response.status == "EXPIRED"){
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////
		/*  Fire Alert for Waiting Display */
		
		Alert.buttonWidth =141; 
		myAlert = Alert.show("Session EXPIRED due to inactivity.  Please log out and log back in again to create a new session.");  
		// modify the look of the Alert box
		myAlert.setStyle("backgroundColor", '#C3D9FA');
		myAlert.setStyle("borderColor", 0xffffff);
		myAlert.setStyle("borderAlpha", 0.75);
		myAlert.setStyle("fontSize", 14); 
		myAlert.setStyle("fontWeight", "bold");
		myAlert.setStyle("color", 0x000000); // text color
		///////////////////////////////////////////////////////////////////////////////////////////////////////
		
		//parentApplication.AlertMessageShow("Session EXPIRED due to inactivity.  Please log out and log back in again to create a new session.");
			return;
	}else if (evt.result.ezware_response.status == "FAIL"){
		//////////////////////////////////////////////////////////////////////////////////////////////////////
		
		//parentApplication.application.AlertMessageShow("Session EXPIRED due to inactivity.  Please log out and log back in again to create a new session.");
	  
		
		/*  Fire Alert for Waiting Display */
		
		Alert.buttonWidth =141;
		
		myAlert = Alert.show(evt.result.ezware_response.reason + ". Please log out and log back in again to create a new session.");  
		// modify the look of the Alert box
		myAlert.setStyle("backgroundColor", '#C3D9FA');    
		myAlert.setStyle("borderColor", 0xffffff);
		myAlert.setStyle("borderAlpha", 0.75);
		myAlert.setStyle("fontSize", 14); 
		myAlert.setStyle("fontWeight", "bold");
		myAlert.setStyle("color", 0x000000); // text color
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////
		
		//parentApplication.AlertMessageShow(evt.result.ezware_response.reason);
		return;
	}
			
			
}
 
private var myAlert:Alert =  new Alert;
  private function loc_straightJobFunctionMenuResultHandler(event:ResultEvent):void {
		
	  if  (event.result.ezware_response.status == 'OK' ) {

	  
	  		var arr_kpimenu:ArrayCollection = new ArrayCollection;
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
						 navigateToURL(new URLRequest('jobmenu.php?subsys=' + item.code + '&subname=' + item.name + '&c='+ Application.application.parameters.c+ '&cd='+ Application.application.parameters.cd ),'_blank');
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
 							//	Alert.show(arr_groupjob.length.toString());
						
							if (arr_groupjob.length > 1){
								 navigateToURL(new URLRequest('jobmenu.php?subsys=' + item.code + '&subname=' + item.name + '&c='+ Application.application.parameters.c+ '&cd='+ Application.application.parameters.cd ),'_blank');
							}
							
							if (arr_groupjob.length == 1){
								//global_total_jobmenukpiitem = arr_groupjob.length; 
								// testing purposes //
								//global_total_jobmenukpiitem = 1;
								//Alert.show((event.result.ezware_response.refresh_data.jobs.group.job.job_id).length + " : " + event.result.ezware_response.refresh_data.jobs.group.job.job_program.toString() );
									if ((event.result.ezware_response.refresh_data.jobs.group.job.job_id).length == 1){
    		        				  	//companyCode.send();
    		        				   //navigateToURL(new URLRequest(event.result.ezware_response.refresh_data.jobs.group.job.job_program),'_blank');
        								//straightjobprogram = event.result.ezware_response.refresh_data.jobs.group.job.job_program.toString();
        							//	StartHighViewSecurity();
        								 navigateToURL(new URLRequest(event.result.ezware_response.refresh_data.jobs.group.job.job_program.toString() + '&c='+ Application.application.parameters.c+ '&cd='+ Application.application.parameters.cd ),'_blank');
        							}
        							if ((event.result.ezware_response.refresh_data.jobs.group.job.job_id).length > 1){ 
   										//straightgetSessionID.send(); 
   										local_reqSJ = event.result.ezware_response.refresh_data.jobs.group.job.job_id
   										local_systemcode = Application.application.syscode;
   										local_systemcode = local_chainjobmenucode + local_systemcode.substr(2,local_systemcode.length);
        								local_subsystemcode = item.code
        								local_subsystemcode = local_chainjobmenucode + local_subsystemcode.substr(2,local_subsystemcode.length);
        								local_jobmenucode = event.result.ezware_response.refresh_data.jobs.group.job.code
        								
        								//Alert.show("chainjobmenucode: " + local_chainjobmenucode +
										//				" systemcode: " +  local_systemcode +
										//				" subsystemcode: " +  local_subsystemcode +
										//				" groupcode: " +  local_groupcode  +
										//				" jobmenucode: " +  local_jobmenucode);
        								
        								//StartJobSecurity();
        								loc_straightnavigateJobProgram_job.send();  
											
        							}
 						
							}
						
				}		
				
			}
			
			// time to refresh the KPI Menu records
	  }else if (event.result.ezware_response.status == "EXPIRED"){
		  Alert.show("Session EXPIRED due to inactivity.  Please log out and log back in again to create a new session.");
		  return;
	  }else if (event.result.ezware_response.status == "FAIL"){
		  Alert.show("Session FAILED");
		  return;
	  }	
			
} 
 		