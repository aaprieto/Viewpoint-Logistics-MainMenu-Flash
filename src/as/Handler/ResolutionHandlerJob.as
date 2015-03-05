// ActionScript file
public function detectScreenResolutionforJob():void{
	if ((flash.system.Capabilities.screenResolutionX < 1680) && (flash.system.Capabilities.screenResolutionY < 1050)){
						// Application Control Bar
						//second.height = 45; 
						// E-Z Learn Button
	//					ezlearn.setStyle("fontSize", 10);
						//ezlearn.height = 22;
						// Name Label
			//			title_lbl.setStyle("fontSize", 10);		
						// Header 1
	//					ez.setStyle("fontSize", 10);
						// Header 2 
//						sm.setStyle("fontSize", 10);			
						//  Enter Action Command
//						jobcode.setStyle("fontSize", 10);
//						jobcode.width = 80;
						//jobcode.height = 22;
						// Company Label
				//		lbl_company.setStyle("fontSize", 10);
						// Chain Drop Down
	//					JobMenuChainCombo.setStyle("fontSize", 10);
						//JobMenuChainCombo.height = 22;
						// Close Button
						//Close.height = 22;
						//Column(s) Horizontal Gaps
						columnone.setStyle("verticalGap", 2);
						columntwo.setStyle("verticalGap", 2);
						columnthree.setStyle("verticalGap", 2); 
				resolutionflagjob = 'low';
 		ezlearn.styleName 			= "lowResolutionSystemMenu";
 		//ez.styleName 				= "lowResolutionSystemMenu";
 		sm.styleName 				= "lowResolutionSystemMenu";
 		jobcode.styleName 			= "lowResolutionSystemMenu";
 		jobcode.width 				= 80;
 	//	company_code.styleName 		= "lowResolutionSystemMenu";
 		//ChainCombo.styleName 		= "lowResolutionSystemMenu";
 		//ezlearn.styleName 			= "lowResolutionSystemMenu";
 		
 		JobMenuChainCombo.styleName =  "lowResolutionSystemMenujobButton" + JobMenuChainCombo.selectedItem.id 
 		
 		
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
 		ezlearn.styleName 			= "highResolutionSystemMenu";
 		JobMenuChainCombo.styleName =  "highResolutionSystemMenujobButton" + JobMenuChainCombo.selectedItem.id
 		//Alert.show("highResolutionSystemMenujobButton" + ChainCombo.selectedItem.id.toString());
 	}
}		