// ActionScript file
public function SystemMenuCheck():void{
		straightsystemcompanyCode.send();
}  
public function StartApplication():void{
	companyCode.send();
}
public function CheckSystemItems():void{
	//Alert.show("compcode: " + global_total_companycode + " chain: " + global_total_systemchain + " kpi: " + global_total_systemkpiitem);
	if ((global_total_companycode == 1)&&(global_total_systemchain==1)&&(global_total_systemkpiitem==1)){
			reqParms = "REFRESH,RETRIEVE|CHAINSUBSYSTEM|" + g_usercode+ "|" + g_changed_m_code + "|" + systemcode+ "|"
		//	Alert.show(reqParms);
				// Go search for SubSystem Chain
			straightsubsystemchainCode.send();
	} 
}

public function StartSubSystem():void{
	companyCode.send();
	 navigateToURL(new URLRequest('subsystemsmenu.php?sys=' + systemcode+ '&c='+ Application.application.company_code.selectedItem.company+ '&cd='+ Application.application.company_code.selectedItem.company_desc),'_blank');
}
 
public function CheckJobMenu():void{
	
				reqParms = "REFRESH,RETRIEVE|CHAINJOB|" + g_usercode + "|" + g_changed_m_code + "|" + systemcode + "|" + subsystemcode + "|";
				straightjobchainCode.send();
	
			//straightsubsystemchainCode.send();
}
public function StartJobMenu():void{
	companyCode.send();
	 //navigateToURL(new URLRequest('subsystemsmenu.php?sys=' + systemcode),'_blank');
	 
	 navigateToURL(new URLRequest('jobmenu.php?subsys=' + subsystemcode + '&subname=' + subsystemname+ '&c='+ Application.application.company_code.selectedItem.company+ '&cd='+ Application.application.company_code.selectedItem.company_desc),'_blank');
        	   
	 
	 
}
public function StartHighViewSecurity():void{
	companyCode.send();
    navigateToURL(new URLRequest(straightjobprogram+ '&c='+ Application.application.company_code.selectedItem.company+ '&cd='+ Application.application.company_code.selectedItem.company_desc),'_blank');
}
public function StartJobSecurity():void{
	
	//Alert.show(chainjobmenucode);
	straightnavigateJobProgram_job.send();
	//companyCode.send();

}

public function CheckSubSystem():void{
	//Alert.show(chainjobmenucode);
	//companyCode.send();
}  
