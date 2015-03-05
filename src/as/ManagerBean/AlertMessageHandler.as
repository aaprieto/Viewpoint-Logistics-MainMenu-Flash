// ActionScript file
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.ui.Keyboard;

import mx.collections.*;
import mx.containers.HBox;
import mx.controls.*;
import mx.events.AdvancedDataGridEvent;
import mx.events.ListEvent;
import mx.managers.ToolTipManager;
import mx.managers.PopUpManager;

			public var popalertmessage:AlertMessage;	
 			private function AlertMessageShow(string_message:String):void {
            	//popwait = Ergo(PopUpManager.createPopUp(this, Ergo, true));
               	popalertmessage = AlertMessage(PopUpManager.createPopUp(this, AlertMessage, false));
                popalertmessage.str_message = string_message;
               
   		    } 