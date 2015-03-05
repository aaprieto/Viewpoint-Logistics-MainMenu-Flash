// ActionScript file
	
public function detectScreenResolutionforSubSystem():void{
 	if ((flash.system.Capabilities.screenResolutionX < 1680) && (flash.system.Capabilities.screenResolutionY < 1050)){
 		resolutionflagsubsystem = 'low';
 		ezlearn.styleName 			= "lowResolutionSystemMenu";
 		//ez.styleName 				= "lowResolutionSystemMenu";
 		sm.styleName 				= "lowResolutionSystemMenu";
 		jobcode.styleName 			= "lowResolutionSystemMenu";
 		jobcode.width 				= 80;
 	//	company_code.styleName 		= "lowResolutionSystemMenu";
 		//ChainCombo.styleName 		= "lowResolutionSystemMenu";
 		//ezlearn.styleName 			= "lowResolutionSystemMenu";
 										  //lowResolutionSystemMenujobButton10
 										  //lowResolutionSystemMenujobButton
 		SubSystemChainCombo.styleName =  "lowResolutionSystemMenujobButton" + SubSystemChainCombo.selectedItem.id 
 		
 		
 	} 
 	else{
 		//Alert.show("this is high resolution");
 		//Alert.show("highResolutionSystemMenujobButton" + ChainCombo.selectedItem.id.toString());
 		ezlearn.styleName 			= "highResolutionSystemMenu";
 		//ez.styleName 				= "highResolutionSystemMenu";
 		sm.styleName 				= "highResolutionSystemMenu";
 		jobcode.styleName 			= "highResolutionSystemMenu";
 		
 	//	company_code.styleName 		= "highResolutionSystemMenu";
 		//ChainCombo.styleName 		= "highResolutionSystemMenu";
 		//ezlearn.styleName 			= "highResolutionSystemMenu";
 										 // highResolutionSystemMenujobButton
 		SubSystemChainCombo.styleName =  "highResolutionSystemMenujobButton" + SubSystemChainCombo.selectedItem.id
 		         //ChainCombo.styleName =  "highResolutionSystemMenujobButton" + ChainCombo.selectedItem.id
 		//Alert.show("highResolutionSystemMenujobButton" + ChainCombo.selectedItem.id.toString());
 	}
} 