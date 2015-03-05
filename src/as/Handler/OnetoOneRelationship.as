// ActionScript file


/*****************************************************************************
 Visible Logistics
 
 Actionscript for login page, change password page and systems menu.
 
 Copyright 2009,2010 Maves International Software
 ALL RIGHTS RESERVED
 ------------------------------------------------------------------------------
 $Id: OnetoOneRelationship.as,v 1.1.2.1 2012/10/16 18:56:34 aprarn Exp $
 *****************************************************************************/

import com.utilities.Utils;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.net.URLRequest;
import flash.utils.Timer;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.utils.Base64Encoder;


private function SystemSearchRel(loc_chain:String, loc_syscode:String):Boolean{
	var flag1:int = 0;
	var tcw_index:int = new int;
	var flag:Boolean = false;		
	if(loc_chain == '10'){
			for (var i:int = 0; i < treeviewoperations_arr.length; i ++){ 
				if (loc_syscode ==  treeviewoperations_arr[i]['syscode']){
					tcw_index = i;
					flag1 = flag1 + 1;
					
						if (flag1 > 1){
							break;
						}
				}
			} 
			
			if(flag1 == 1){
				
				flag = SubSystemSearchRel('10', treeviewoperations_arr[tcw_index]['subsyscode'], loc_syscode);
				
			}
			
	}		
	if(loc_chain == '20'){
		for (var i:int = 0; i < treeviewadministrations_arr.length; i ++){ 
			if (loc_syscode ==  treeviewadministrations_arr[i]['syscode']){
				tcw_index = i;
				flag1 = flag1 + 1;
				
				if (flag1 > 1){
					break;
				}
			}
		} 
		
		if(flag1 == 1){
			
			flag = SubSystemSearchRel('20',treeviewadministrations_arr[tcw_index]['subsyscode'], loc_syscode);
		}
		
	}		
	
	return flag;
	
}

private function SubSystemSearchRel(loc_chain2:String, loc_subsyscode:String, loc_syscode2:String):Boolean{
	
	var flag2:int = 0;
	var tcw2_index:int = new int;
	var flag:Boolean = false;
	if(loc_chain2 == '10'){
	
			for (var i:int = 0; i < treeviewoperations_arr.length; i ++){ 
		
				if ((loc_subsyscode ==  treeviewoperations_arr[i]['subsyscode']) && (loc_syscode2  ==  treeviewoperations_arr[i]['syscode']))  {
					tcw2_index = i;
					flag2 = flag2 + 1;
					
					
					if (flag2 > 1){
						break;
					}
				}
			} 	
			
			if(flag2 == 1){
				
				flag = runJobfromSearch(loc_syscode2,loc_subsyscode , treeviewoperations_arr[tcw2_index]['job_program'], treeviewoperations_arr[tcw2_index]['job_id'] );
				
			}
	}	

	if(loc_chain2 == '20'){
		for (var i:int = 0; i < treeviewadministrations_arr.length; i ++){ 
			if ((loc_subsyscode ==  treeviewadministrations_arr[i]['subsyscode'])&&(loc_syscode2  ==  treeviewadministrations_arr[i]['syscode'])){
				tcw2_index = i;
				flag2 = flag2 + 1;
				
				if (flag2 > 1){
					break;
				}    
			}
		} 	
		
		if(flag2 == 1){
			flag = runJobfromSearch(loc_syscode2,loc_subsyscode , treeviewadministrations_arr[tcw2_index]['job_program'], treeviewadministrations_arr[tcw2_index]['job_id'] );
		}
	}	
	
	return flag;	
}



private function runJobfromSearch(lsc:String, lsubsc:String, jobp:String, jobid:String):Boolean{
	
	
	var flag:Boolean = false;
	if (jobid.length == 1){
		
		
		if (jobp == 'NETVIEW'){
			runNetView.send();
			flag = true; 
		} else { 
			//navigateToURL(new URLRequest(event.result.ezware_response.refresh_data.jobs.group.job.job_program + 
			//	'&c='+ g_changed_m_code + '&cd='+ g_changed_m_codedescription),'_blank');
			
			//Alert.show("go here");
			navigateToURL(new URLRequest(jobp + '&c='+ g_changed_m_code + '&cd='+ g_changed_m_codedescription),'_blank');
			flag = true;
			//RunJob(event,l_jp);
			
			
		}
		
		
		
	}
	if (jobid.length > 1){ 
		flag = true;
		navigateJobProgram.send();
	}
	return flag
}

