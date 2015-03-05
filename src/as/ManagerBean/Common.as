// ActionScript file

[Bindable] public var ht_company:String = new String;
[Bindable] public var ht_jobcode:String = new String;
public var str_jobcode:String = new String;
private function jobCodeHandler():void{
	
	/* Make jobcode convert to uppercase */
	jobcode.text = jobcode.text.toUpperCase();
	
	/* Trim Input String */
	str_jobcode = c_utils.trim(jobcode.text);
	
	/* Validation for 6 and 4 characters */
	if ((str_jobcode.length != 6) && (str_jobcode.length != 4)){
		//Alert.show("This input only accepts 6 and 4 characters only");
			AlertMessageShow("This input only accepts 6 and 4 characters only");
		return;
	} 
	if ((str_jobcode.length == 6) || (str_jobcode.length == 4)){
	// Version 1 ///////////////////////////////////////////////////////
	//	if (str_jobcode.length == 6){
	//		ht_company = str_jobcode.substr(0,2);
	//		ht_jobcode = str_jobcode.substr(2,4);
	//	}
    //
	//	if (str_jobcode.length == 4){
	//		ht_company = Application.application.parameters.c;
	//		ht_jobcode = str_jobcode;
	//	}
	//////////////////////////////////////////////////////////////////////////
	// Version 2
		ht_jobcode = str_jobcode;
	///////////////////////////////////////////////////////////////////////////
		jobcode.text = "";
		
		navigateJobProgram.send();
	}
}