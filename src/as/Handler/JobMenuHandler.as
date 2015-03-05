// ActionScript file

import mx.controls.Alert;
import com.utilities.Utils;

 	/* Initialize class Utils from com.utilities.  
	aaprieto - just in case there are trailing spaces in the username.
	*/
	 public var c_utils:Utils = new Utils();
	[Bindable] private var j_reqSJ:String = new String;
	[Bindable] private var j_reqParms:String = new String;
[Bindable] public var j_comp_code:String = new String; 
	[Bindable] private var j_comp_description:String = new String;
	[Bindable] private var j_sid:String = new String;
	[Bindable] private var j_chain:String = new String;
 	[Bindable] public var j_my_pass_url:String = new String;
 	[Bindable] public var j_usercode:String = new String;
 	[Bindable] public var j_syscode:String = new String;
 	[Bindable] public var j_subsyscode:String = new String;
 	[Bindable] public var j_filler:String = new String;
 	 [Bindable] private var resolutionflagjob:String = new String;
 	 [Bindable] public var jobhoverstatus:String = 'OFF';
	[Bindable] public var s_connection:String = new String;
public var app_mylog = 'vl';
	private function jminit():void {
		j_usercode 			= Application.application.parameters.u;   			// User code
		j_comp_code 		= Application.application.parameters.c;				// Company Code
		j_comp_description	= Application.application.parameters.cd;			// Company Description
		j_sid 				= Application.application.parameters.sid;			// Session ID
		j_chain 			= Application.application.parameters.ch;			// Chain
		j_syscode 			= Application.application.parameters.sc;			// System Code
		j_subsyscode 		= Application.application.parameters.subsys			// Sub System Code
		j_reqParms = "REFRESH,RETRIEVE|CHAINJOB|" + Application.application.parameters.u + "|" + Application.application.parameters.c + "|" + Application.application.parameters.sc + "|" + Application.application.parameters.subsys + "|";
		
		//Alert.show(Application.application.parameters.so);
		s_connection = Application.application.parameters.so
		if (Application.application.parameters.so =='basic'){
			this.setStyle("backgroundImage","");
		} else {
			this.setStyle("backgroundImage","image/Blue3.png")
		}
		
		
		subsystemchainCode.send();
		/*
		if (ez.width > sm.width){
			sm.width = ez.width;
		} else{
			ez.width = sm.width;
		}
		*/
		initFocus();			
		//detectScreenResolutionJobMenu();
		//detectScreenResolutionforJob();
	}
	public function detectScreenResolutionJobMenu():void{
					//if ((flash.system.Capabilities.screenResolutionX < 1280) && (flash.system.Capabilities.screenResolutionY < 1024)){
					//if ((flash.system.Capabilities.screenResolutionX < 1400) && (flash.system.Capabilities.screenResolutionY < 1050)){
					if ((flash.system.Capabilities.screenResolutionX < 1680) && (flash.system.Capabilities.screenResolutionY < 1050)){
						// Application Control Bar
						second.height = 45; 
						// E-Z Learn Button
						ezlearn.setStyle("fontSize", 10);
						ezlearn.height = 22;
						// Name Label
			//			title_lbl.setStyle("fontSize", 10);		
						// Header 1
						//ez.setStyle("fontSize", 10);
						// Header 2 
						sm.setStyle("fontSize", 10);			
						//  Enter Action Command
						jobcode.setStyle("fontSize", 10);
						jobcode.width = 40;
						jobcode.height = 22;
						// Company Label
				//		lbl_company.setStyle("fontSize", 10);
						// Chain Drop Down
						JobMenuChainCombo.setStyle("fontSize", 10);
						JobMenuChainCombo.height = 22;
						// Close Button
						Close.height = 22;
						//Column(s) Horizontal Gaps
						columnone.setStyle("verticalGap", 5);
						columntwo.setStyle("verticalGap", 5);
						columnthree.setStyle("verticalGap", 5);
					}
			
		}

		private function initFocus():void{
						jobcode.setFocus();
					   if (ExternalInterface.available) {
       						 ExternalInterface.call('setFocus');
    						} else {
        					AlertMessageShow("Browser not available");
    						}
    					focusManager.setFocus(jobcode);
						return;
		}   
		
	
		private function getJobMenu():void{
					passChainGlobalVariable();
					j_my_pass_url = "REFRESH,RETRIEVE|JOB|" + j_usercode+ "|" + j_comp_code + "|" + JobMenuChainCombo.selectedItem.id + "|" + j_syscode + "|" + j_subsyscode + "|";
					//j_my_pass_url = "REFRESH,RETRIEVE|JOB|" + j_usercode+ "|" + comp_code + "|" + JobMenuChainCombo.selectedItem.id + "|" + j_syscode + "|" + j_subsyscode + "|";
					Alert.show(j_my_pass_url);
					jm_httpp_kpi_srv.send();
		}
		
		public function passChainGlobalVariable():void{
				httpChainGlobalVariable.url = "rd_settings.php?sid=" + j_sid + "&ch=" + JobMenuChainCombo.selectedItem.id;	 
				httpChainGlobalVariable.send();
		}
	
	    private function closeApp():void
   		{
		       var urlString:String = "javascript:self.close()";
		       var request:URLRequest = new URLRequest(urlString);
		       navigateToURL(request, "_self");
  		 }
  		 
  		private function ezlinkHandlerJob(event:ResultEvent):void {
			
			if ( event.result.ezware_response.status == 'OK' ) {
			
			
				navigateToURL(new URLRequest(event.result.ezware_response.refresh_data.root.ezlink), 'quote')
		
			}else {
				
				var s_ret:String = resultStatus(event.result.ezware_response.status, event.result.ezware_response.reason);  
				AlertMessageShow(s_ret);
				return;
				
			}
			
		}
	
	
	
private const TIMER_INTERVAL:int = 1500;
private var baseTimer:int;
public var nt:Timer;	
public var mbdg_objecttitle:String;
public var mbdg_objecttitleheader:String;
public var mbdg_objecthelpfortitle:String;


public function pre_nt_mousehovering(event:Event, object_title:String,object_id:String, object_type:String):void{
	
	if (jobhoverstatus == "OFF"){
		PopUpManager.removePopUp(pophoverinterface);
		mbdg_objecttitle = object_id;   
		mbdg_objecttitleheader =  object_type;
		mbdg_objecthelpfortitle = object_title;
		pre_nt_updateHoverTimer(event)
	}
	else {
		jobhoverstatus = 'OFF';
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
	pophoverinterface.loc_sid = j_sid;
	pophoverinterface.loc_ccode = j_comp_code; 
	
}
public function setHoverHelpOn(event:Event):void{
	PopUpManager.removePopUp(pophoverinterface); 
	jobhoverstatus = 'ON';
}


private function nt_mousehovering(event:Event, object_title:String,object_id:String, object_type:String):void{		
				if (jobhoverstatus == "ON"){
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
private function nt_updateHoverTimer(evt:TimerEvent):void {
         		nt.stop(); 
         		
             	
             	pophoverinterface = MainMouseHoverMenu(
                PopUpManager.createPopUp(this, MainMouseHoverMenu,true));
               pophoverinterface.helpfortitleheader = mbdg_objecthelpfortitle;
                pophoverinterface.helpfortitle = mbdg_objecttitle;
                pophoverinterface.object_type = mbdg_objecttitleheader;
                pophoverinterface.item_code = mbdg_objecttitle;
				pophoverinterface.loc_sid = j_sid;
				pophoverinterface.loc_ccode = j_comp_code;
         }
private function hoverHelpSwitch():void{
	if (jobhoverstatus == 'OFF'){
		jobhoverstatus = 'ON';
	} else {
			jobhoverstatus = 'OFF';
	}         
}	