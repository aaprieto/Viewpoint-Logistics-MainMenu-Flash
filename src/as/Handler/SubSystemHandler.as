// ActionScript file

import com.utilities.Utils;

import mx.controls.Alert;
	[Bindable] private var reqSJ:String = new String;
	[Bindable] public var reqParms:String = new String;
	[Bindable] public var comp_code:String = new String;
	[Bindable] public var sid:String = new String;
	[Bindable] private var chain:String = new String;
 	[Bindable] public var my_pass_url:String = new String;
 	[Bindable] public var usercode:String = new String;
 	[Bindable] public var syscode:String = new String;
 	[Bindable] private var s_filler:String = new String;
 	[Bindable] private var resolutionflagsubsystem:String = new String;
 	[Bindable] public var subhoverstatus:String = 'OFF';
	[Bindable] private var s_connection:String = new String;
 	/* Initialize class Utils from com.utilities.  
	aaprieto - just in case there are trailing spaces in the username.
	*/
	public var c_utils:Utils = new Utils();
public var app_mylog = 'vl';
	private function ssminit():void {
		usercode 	= Application.application.parameters.u;
		comp_code 	= Application.application.parameters.c;
		sid 		= Application.application.parameters.sid;
		chain 		= Application.application.parameters.ch;
		syscode 	= Application.application.parameters.sys;
		
		s_connection = Application.application.parameters.so;
		if (Application.application.parameters.so =='basic'){
			this.setStyle("backgroundImage","");
		} else {
			this.setStyle("backgroundImage","image/Blue3.png")
		}
		
		/* Get Chain Codes from System Menu. */
		
		passSystemCodeGlobalVariable();
		reqParms = "REFRESH,RETRIEVE|CHAINSUBSYSTEM|" + Application.application.parameters.u+ "|" + Application.application.parameters.c + "|" + Application.application.parameters.sys+ "|";
		subsystemchainCode.send();
		/*
		if (ez.text.length > sm.text.length){
			sm.width = ez.width;
		} else{
			ez.width = sm.width;
		}
		*/
		//detectScreenResolutionSubSystemMenu();
	}
	public function detectScreenResolutionSubSystemMenu():void{
					//if ((flash.system.Capabilities.screenResolutionX < 1280) && (flash.system.Capabilities.screenResolutionY < 1024)){
					  //if ((flash.system.Capabilities.screenResolutionX < 1400) && (flash.system.Capabilities.screenResolutionY < 1050)){
					  if ((flash.system.Capabilities.screenResolutionX < 1680) && (flash.system.Capabilities.screenResolutionY < 1050)){
						// Application Control Bar
						second.height = 65;
						// E-Z Larn Button
						ezlearn.setStyle("fontSize", 10);
						ezlearn.height = 22;
						// Name Label
					//	title_lbl.setStyle("fontSize", 10);		
						// Header 1
						//ez.setStyle("fontSize", 10);
						// Header 2
						sm.setStyle("fontSize", 10);			
						//  Enter Action Command
						jobcode.setStyle("fontSize", 10);
						jobcode.width = 40;
						jobcode.height = 22;
						// Company Label
					//	lbl_company.setStyle("fontSize", 10);
						// Chain Drop Down
						SubSystemChainCombo.setStyle("fontSize", 10);
						SubSystemChainCombo.height = 22;
						// Close Button
						Close.height = 22;
					}
		}
	public function passSystemCodeGlobalVariable():void{
				httpSystemCodeGlobalVariable.url = "rd_settings.php?sid=" + sid + "&sc=" + syscode;	 
				httpSystemCodeGlobalVariable.send();
	}  
	
	private function getSubMenu():void{
				passChainGlobalVariable();
				my_pass_url = "REFRESH,RETRIEVE|SUBSYSTEM|" + usercode+ "|" + comp_code + "|" + SubSystemChainCombo.selectedItem.id + "|" + syscode + "|";
				ss_httpp_kpi_srv.send(); 
	}
	
	
	public function passChainGlobalVariable():void{
				httpChainGlobalVariable.url = "rd_settings.php?sid=" + sid + "&ch=" + SubSystemChainCombo.selectedItem.id;	 
				httpChainGlobalVariable.send();
	}
		

    private function closeApp():void
   		{
		       var urlString:String = "javascript:self.close()";
		       var request:URLRequest = new URLRequest(urlString);
		       navigateToURL(request, "_self");
  		 }
  		 
  	private function ezlinkHandlerSubSystem(event:ResultEvent):void {
		
		if ( event.result.ezware_response.status == 'OK' ) {
		
			navigateToURL(new URLRequest(event.result.ezware_response.refresh_data.root.ezlink), 'quote')
	
		}else {
			
			var s_ret:String = resultStatus(event.result.ezware_response.status, event.result.ezware_response.reason);  
			AlertMessageShow(s_ret);
			return;
			
		}
		
		
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
	private function hoverHelpSwitch():void{
	if (subhoverstatus == 'OFF'){
		subhoverstatus = 'ON';
	} else {
			subhoverstatus = 'OFF';
	}
	
	
}


private const TIMER_INTERVAL:int = 1500;
private var baseTimer:int;
public var nt:Timer;	
public var mbdg_objecttitle:String;
public var mbdg_objecttitleheader:String;
public var mbdg_objecthelpfortitle:String;



public function pre_nt_mousehovering(event:Event, object_title:String,object_id:String, object_type:String):void{
	
	if (subhoverstatus == "OFF"){
		PopUpManager.removePopUp(pophoverinterface);
		mbdg_objecttitle = object_id;   
		mbdg_objecttitleheader =  object_type;
		mbdg_objecthelpfortitle = object_title;
		pre_nt_updateHoverTimer(event)
	}
	else {
		subhoverstatus = 'OFF';
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
	pophoverinterface.loc_sid = sid;
	pophoverinterface.loc_ccode = comp_code;
	
}
public function setHoverHelpOn(event:Event):void{
	PopUpManager.removePopUp(pophoverinterface); 
	subhoverstatus = 'ON';
}

private function nt_mousehovering(event:Event, object_title:String,object_id:String, object_type:String):void{		
				if (subhoverstatus == "ON"){
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
				pophoverinterface.loc_sid = sid;
				pophoverinterface.loc_ccode = comp_code;
         }