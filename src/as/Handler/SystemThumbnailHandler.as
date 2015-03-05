// ActionScript file
public function oneItemSystemDetails(ses_id:String,str_system_code:String, str_system_name:String, str_system_job_id:String, str_system_job_program:String):void{
	
if (str_system_job_program == "SUBSYSTEMS"){
				httpChainGlobalVariable.url = "rd_settings.php?sid=" + ses_id + "&ch=" + Application.application.SubSystemChainCombo.selectedItem.id;	 
}

if (str_system_job_program == "SYSTEMS"){
        		httpChainGlobalVariable.url = "rd_settings.php?sid=" + ses_id + "&ch=" + Application.application.ChainCombo.selectedItem.id;	 
}
				httpChainGlobalVariable.send();



        	if ((str_system_job_id).length == 1){
        	   if (str_system_job_program == "SYSTEMS"){
        	   	 passChainGlobalVariable();
        	     navigateToURL(new URLRequest('subsystemsmenu.php?sys=' + str_system_code),'_blank');
        	   }
        	   if (str_system_job_program == "SUBSYSTEMS"){
        		 passChainGlobalVariable();
        	     navigateToURL(new URLRequest('jobmenu.php?subsys=' + str_system_code  + '&subname=' + str_system_name),'_blank');
        	   } 
       
        	   if (str_system_job_program == "NETVIEW"){
		        	 runNetView.send();
        	   }
        	    if ((str_system_job_program != "SYSTEMS") && (str_system_job_program != "SUBSYSTEMS") && (str_system_job_program != "NETVIEW") ){
        	   		navigateToURL(new URLRequest(str_system_job_program),'_blank');
        	   }
        	}
       	
}        	