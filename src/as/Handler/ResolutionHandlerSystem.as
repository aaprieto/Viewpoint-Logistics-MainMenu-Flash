// ActionScript file
	
public function detectScreenResolutionforSystem():void{
 	if ((flash.system.Capabilities.screenResolutionX < 1680) && (flash.system.Capabilities.screenResolutionY < 1050)){
 		
 		resolutionflag = 'low';
 		ezlearn.styleName 			= "lowResolutionSystemMenu";
 		//ez.styleName 				= "lowResolutionSystemMenu";
 		//sm.styleName 				= "lowResolutionSystemMenu";
 		jobcode.styleName 			= "lowResolutionSystemMenu";
 		jobcode.width 				= 80;
 		company_code.styleName 		= "lowResolutionSystemMenu";
 		//ChainCombo.styleName 		= "lowResolutionSystemMenu";
 		ezlearn.styleName 			= "lowResolutionSystemMenu";
 		
 		ChainCombo.styleName =  "lowResolutionSystemMenujobButton" + ChainCombo.selectedItem.id 
 		
 		
 	}  
 	else{
 		//Alert.show("this is high resolution");
 		 
 		//Alert.show("highResolutionSystemMenujobButton" + ChainCombo.selectedItem.id.toString());
 		ezlearn.styleName 			= "highResolutionSystemMenu";
 		//ez.styleName 				= "highResolutionSystemMenu";
 		//sm.styleName 				= "highResolutionSystemMenu";
 		jobcode.styleName 			= "highResolutionSystemMenu";
 		
 		company_code.styleName 		= "highResolutionSystemMenu";
 		//ChainCombo.styleName 		= "highResolutionSystemMenu";
 		ezlearn.styleName 			= "highResolutionSystemMenu";
 		ChainCombo.styleName =  "highResolutionSystemMenujobButton" + ChainCombo.selectedItem.id
 	}
} 