// ActionScript file
	import mx.rpc.events.FaultEvent;
	import mx.controls.Alert;
	
	private function subsystemfaultglobalvariableResultHandler(evt:FaultEvent):void
		{
			var faultMessage:String = "Error connecting from Global Variables.  Pls contact your System Administrator";
			AlertMessageShow(faultMessage)
		} 
		
		
	private function SubSystemFaultKPIMenuResultHandler(evt:FaultEvent):void
		{
			var faultMessage:String = "Error connecting from Sub System Variables.  Pls contact your System Administrator";
			AlertMessageShow(faultMessage)
		} 	
	private function SubSystemfaultglobalvariableChainResultHandler(evt:FaultEvent):void
		{
			var faultMessage:String = "Error connecting from Sub System Global Variable.  Pls contact your System Administrator";
			AlertMessageShow(faultMessage)
		}
	private function faultglobalvariableSystemCodeResultHandler(evt:FaultEvent):void
		{
			var faultMessage:String = "Error connecting from Global System Code Variables.  Please contact your System Administrator";
			AlertMessageShow(faultMessage)
		}		
	private function EZLinkFaultHandler(evt:FaultEvent):void
		{
			var faultMessage:String = "No definition of EZLearn Link on the Sub Systems Menu.  Please contact your System Administrator";
			AlertMessageShow(faultMessage)
		}	