// ActionScript file

		import mx.rpc.events.FaultEvent;
		import mx.controls.Alert;
		
		/*
		 * A generic handler for faults that occur when sending
		 * requests out to the server via HTTPService objects.
		 *
		 * NDY some requests need much better handling than this
		 */
		private function contexit():void{
		
			username.text = '';
			password.text = ''
			text1.visible=true;
			username.setFocus();
			username.drawFocus(true)
			pbar.visible=false;
			logoutstat = "Y";
			doLogout();
			loginStatus	='';
			text1.visible=false;
			username.setFocus();
			username.drawFocus(true)
		
		
		}
		private function hsFaultHandler(event:FaultEvent):void {

			AlertMessageShow	(
				'HTTP request failed (AYT)' + event.message     
					);	
			login_flag = false;	
		}
		private function updateMyFavoriteSequenceFaultHandler(event:FaultEvent):void {
			
			var faultMessage:String = "Error updating My Favorties Sequence.  Please contact your System Administrator";
			AlertMessageShow(faultMessage);
		}
			private function updateMyShortcutSequenceFaultHandler(event:FaultEvent):void {
				
				var faultMessage:String = "Error updating MyShortcut Sequence.  Please contact your System Administrator";
				AlertMessageShow(faultMessage);
			}
		private function getjobFaultHandler(evt:FaultEvent):void
		{
			
			var faultMessage:String = "Error retrieving Job(s) modules.  Please contact your System Administrator";
			AlertMessageShow(faultMessage);
		}
		private function getshortcutpianokeysFaultHandler(evt:FaultEvent):void
		{
			
			var faultMessage:String = "Error retrieving Shortcut List.  Please contact your System Administrator";
			AlertMessageShow(faultMessage);
		}
		private function getsubsystemFaultHandler(evt:FaultEvent):void
		{
			
			var faultMessage:String = "Error retrieving Sub System modules.  Please contact your System Administrator";
			AlertMessageShow(faultMessage);
		}
		private function treeivewOperationsFaultHandler(evt:FaultEvent):void
		{
			
			var faultMessage:String = "Error retrieving available modules.  Please contact your System Administrator";
			AlertMessageShow(faultMessage);
		}
		private function treeivewMyFavoritesFaultHandler(evt:FaultEvent):void
		{
			
			var faultMessage:String = "Error retrieving MyFavorites Tree View.  Please contact your System Administrator";
			AlertMessageShow(faultMessage);
		}
		private function faultprofileResultHandler(evt:FaultEvent):void
		{
			
			var faultMessage:String = username.text + "not found.";
			AlertMessageShow(faultMessage);
		}
		private function faultglobalvariableResultHandler(evt:FaultEvent):void
		{
			var faultMessage:String = "Error connecting from Global Variables.  Please contact your System Administrator";
			AlertMessageShow(faultMessage);
		}
		private function faultglobalvariableChainResultHandler(evt:FaultEvent):void
		{
			var faultMessage:String = "Error connecting from Global Chain Variables.  Please contact your System Administrator";
			AlertMessageShow(faultMessage);
		}
		private function companyCodeFaultHandler(evt:FaultEvent):void
		{
			var faultMessage:String = "Error connecting to Profiles.  Please contact your System Administrator";
			AlertMessageShow(faultMessage);
			contexit();
		}
		private function chainCodeFaultHandler(evt:FaultEvent):void
		{
			var faultMessage:String = "Error connecting to Chain Codes.  Please contact your System Administrator";
			AlertMessageShow(faultMessage);
		}
		
		private function EZLinkFaultHandler(evt:FaultEvent):void
		{
			var faultMessage:String = "No definition of EZLearn Link on the Systems Menu.  Please contact your System Administrator";
			AlertMessageShow(faultMessage);
		}
		private function ALfaultHandler(event:FaultEvent):void{
				AlertMessageShow("Unable to connect to Arboretum"); 
		}
		private function getmyshortcutsFaultHandler(evt:FaultEvent):void
		{
			
			var faultMessage:String = "Error updating MyShortcuts.  Please contact your System Administrator";
			AlertMessageShow(faultMessage);
		}
		private function getmyshortcuts_mainFaultHandler(evt:FaultEvent):void
		{
			
			var faultMessage:String = "Error retrieving MyShortcuts.  Please contact your System Administrator";
			AlertMessageShow(faultMessage);
		}