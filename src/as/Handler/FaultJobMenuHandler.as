// ActionScript file
	import mx.rpc.events.FaultEvent;
	import mx.controls.Alert;

	private function jobfaultglobalvariableResultHandler(evt:FaultEvent):void
		{
			var faultMessage:String = "Error connecting from Job Menu Chain Variables.  Please contact your System Administrator";
			AlertMessageShow(faultMessage)
		}	
	private function JobMenufaultglobalvariableChainResultHandler(evt:FaultEvent):void
		{
			var faultMessage:String = "Error connecting from Job Menu Global Variable.  Please contact your System Administrator";
			AlertMessageShow(faultMessage)
		}
	private function JobFunctionFaultJobFunctionMenuResultHandler(evt:FaultEvent):void
		{
			var faultMessage:String = "Error connecting from Job Function Menu.  Please contact your System Administrator";
			AlertMessageShow(faultMessage)
		} 		
		
	private function EZLinkFaultHandler(evt:FaultEvent):void
		{
			var faultMessage:String = "No definition of EZLearn Link on the Jobs Menu.  Please contact your System Administrator";
			AlertMessageShow(faultMessage)
		}		