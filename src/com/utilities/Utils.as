package com.utilities
{
	public class Utils
	{
		import mx.controls.Alert;
		public function Utils()
		{
			
		}
		public function trim(txt_str:String):String {
				while (txt_str.charAt(0) == " ") {
					txt_str = txt_str.substring(1, txt_str.length);
				}
				while (txt_str.charAt(txt_str.length-1) == " ") {
						txt_str = txt_str.substring(0, txt_str.length-1);
				}
				return txt_str;
		}
		public function formatyymmdd(ret_str:String):String{
			var loc_year:String = new String;
			var loc_month:String = new String;
			var loc_day:String = new String;
			
			loc_year = ret_str.substr(0,4);
			loc_month = ret_str.substr(4,2);
			loc_day = ret_str.substr(6,2);
			
			ret_str = loc_year + '-' + loc_month + '-' + loc_day;
			return ret_str;
			
		}
		public function formathhmmss(ret_str1:String):String{
			var loc_hour:String = new String;
			var loc_minute:String = new String;
			var loc_second:String = new String;
			
			loc_hour = ret_str1.substr(0,2);
			loc_minute = ret_str1.substr(2,2);
			loc_second = ret_str1.substr(4,2);
			
			ret_str1 = loc_hour + ':' + loc_minute + ':' + loc_second;
			return ret_str1;
			
		}

		
	}
}