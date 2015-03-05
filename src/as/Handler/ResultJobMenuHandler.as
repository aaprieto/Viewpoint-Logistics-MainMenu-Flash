// ActionScript file

		import flash.events.Event;
		
		import mx.collections.ArrayCollection;
		import mx.rpc.events.ResultEvent;
		import mx.utils.ArrayUtil;
		import mx.utils.ObjectProxy;
		
		[Bindable]	private var arr_kpimenu:ArrayCollection;
		[Bindable]  public var ChainGroup:ArrayCollection = new ArrayCollection;  	
 		[Bindable]  public var FormatChainGroup:ArrayCollection = new ArrayCollection;
 	 	[Bindable]
        public var ir_sid:String;

		/* Bindable Variable for 1 item user entry */
		[Bindable]					
		private var oneitem_custombtn_company:String = new String;
   		[Bindable]
   		private var oneitem_reqSJ:String;
   		[Bindable]
   		private var oneitem_custombtn_chain:String;
   		[Bindable]
   		private var oneitem_group_code:String;
   		[Bindable]
   		private var oneitem_custombtn_code:String;
   		[Bindable]
   		private var oneitem_jobcodestyle:String;
   		[Bindable]
   		private var oneitem_systemcode:String;
        [Bindable]
   		private var oneitem_subsystemcode:String;
   		

	private function jobchainCodeResultHandler(evt:ResultEvent):void{
		if ( evt.result.ezware_response.status == 'OK' ) {

					ChainGroup = new ArrayCollection;
					
					if (evt.result.ezware_response.refresh_data.chaingroup == null){
						AlertMessageShow("You do not have the necessary access for " +  j_comp_code +  ". Please contact your System Administrator.");
						return
					} 
					
					if (evt.result.ezware_response.refresh_data.chaingroup != null){
						if (evt.result.ezware_response.refresh_data.chaingroup.chain == null)
		            		{
		                		ChainGroup=new ArrayCollection()
		            		}
		            	else if (evt.result.ezware_response.refresh_data.chaingroup.chain is ArrayCollection)
		            		{
		              			ChainGroup=evt.result.ezware_response.refresh_data.chaingroup.chain;
		            		}
		            	else if (evt.result.ezware_response.refresh_data.chaingroup.chain is ObjectProxy)
		            		{
		               			ChainGroup = new ArrayCollection(ArrayUtil.toArray(evt.result.ezware_response.refresh_data.chaingroup.chain)); 
		            		}
					
							ChainGroup.refresh();
							
						//  Populate the combo box.
							var cg:Object = new Object();
								FormatChainGroup = new ArrayCollection;
								for (var i:int=0;i<ChainGroup.length;i++)  { 
									var cgo:Object = new Object;
						  			var s_id:String = (ChainGroup[i]["id"]);
					      			var s_description:String = (ChainGroup[i]["description"]);
									cgo.id = s_id;
									cgo.description = s_description;	
									FormatChainGroup.addItem(cgo);
								}
								FormatChainGroup.refresh();
						//  Identify and select the last Chain selected from the systems menu.
							
								for (var ia:int=0;ia<FormatChainGroup.length;ia++)  { 
									if (j_chain == FormatChainGroup[ia]["id"]){
										JobMenuChainCombo.selectedIndex = ia;
									}
								}
							getJobMenu();
							
							
					}   
		}else {
			
			var s_ret:String = resultStatus(evt.result.ezware_response.status, evt.result.ezware_response.reason);  
			AlertMessageShow(s_ret);
			return;
			
		}
	}
	
		private function JobMenuglobalvariableChainResultHandler(evt:ResultEvent):void 
		{
			/*  Not expecting any result.  I'm not sure if this is a good practice of leaving this hanging but I will for now.
			*/
			//Alert.show("Success");
		}	

		
		
	private function JobFunctionMenuResultHandler(event:ResultEvent):void {
			 
		if ( event.result.ezware_response.status == 'OK' ) {
						
							if (event.result.ezware_response.refresh_data.jobs == null)
				            {
				                arr_kpimenu=new ArrayCollection()
				            }
				            
							if (event.result.ezware_response.refresh_data.jobs.group != null){
								
								if (event.result.ezware_response.refresh_data.jobs.group == null)
				            	{
				                	arr_kpimenu=new ArrayCollection()
				            	}
				             
				            	else if (event.result.ezware_response.refresh_data.jobs.group is ArrayCollection)
				            	{
				              		arr_kpimenu=event.result.ezware_response.refresh_data.jobs.group;
				            	}
				            	else if (event.result.ezware_response.refresh_data.jobs.group is ObjectProxy)
				            
				            	{
				            	arr_kpimenu = new ArrayCollection(ArrayUtil.toArray(event.result.ezware_response.refresh_data.jobs.group));  
				            	}
				    			arr_kpimenu.refresh();
								
							}
							
							
							
							
							detectScreenResolutionforJob();
							AddtoJobMenu(event);
							
			}else {
				
				var s_ret:String = resultStatus(event.result.ezware_response.status, event.result.ezware_response.reason);  
				AlertMessageShow(s_ret);
				return;
				
			}
		}
		
		 public function resultGetSID(evt:ResultEvent):void{
        	var ret_sid:String = evt.result.toString();
        	
        	if (ret_sid.substr(0,2) == 'OK'){
        	
        	
        	
        		var int_ret_sid:int = ret_sid.length;
        		ir_sid = ret_sid.substr(3,int_ret_sid);
 		
        		
        	}
        }
		public var newObject:CustomHead;
		public var newObjectBtn:CustomButton;
		private function addObjectToArray(formField:DisplayObject):void{
        		this.aFormFields.push(formField);
        }
        private function DisplayToColumnObject(rc:int):void{
        	
        	if ((rc >= 0) && (rc < 21)){
        		
        			// check for last Column Header
        			addObjectToArray(newObject);
					
        			if (rc == 20){
        					columntwo.addChild(newObject);
        					row_ctr = row_ctr + 1;
        			} else{
        					
					columnone.addChild(newObject);
        			}
 			
 			} else if ((rc >= 21 ) && (rc < 41)){
        					addObjectToArray(newObject);
							
							
					if (rc == 40){
        					columnthree.addChild(newObject);
        					row_ctr = row_ctr + 1;
        			} else{
        					
							columntwo.addChild(newObject);
        			}
        	/*
        	}else if ((rc >=41) && (rc < 61)){
        					addObjectToArray(newObject);
        					row_ctr = row_ctr + 1;	
        			if (rc == 60){
        					columnfour.addChild(newObject);
        			} else{
        					columnthree.addChild(newObject);
        			}		
        	*/
        	} else if (rc >= 41){
        					addObjectToArray(newObject);
							columnthree.addChild(newObject);
        				}
        	return
        }
        
        private var obj_gen_id:int = new int;
        private var obj_gen_name:String = new String;
        private var obj_gen_label:String = new String;
        private function swapObject(obj_gen:Object, col:int):void{
        	
        	obj_gen_id = obj_gen.customacb_id;
        	obj_gen_name = obj_gen.customacb_name;
        	obj_gen_label = obj_gen.label;
        
        							newObject = new CustomHead();
		
									newObject.customacb_id = obj_gen_id;   
									newObject.customacb_name = obj_gen_name + " (Continued)";
									newObject.label = obj_gen_label + " (Continued)";
        
        
        	if (col == 20){
        		columntwo.addChild(newObject);
        	}
        	if (col == 40){
        		columnthree.addChild(newObject);
        	}
        
        	return;
        
        }
        
        
        private function DisplayToColumnObjectButton(rc:int, rowno:int, len:int):void{
        //	Alert.show("len: " + len);
        	if ((rc >= 0) && (rc < 21)){
					addObjectToArray(newObjectBtn);
					columnone.addChild(newObjectBtn);
					if  ((rc== 20) && (rowno != (len - 1))) {
								
									swapObject(newObject,20);
										
 					}
        			
 			} else if ((rc >= 21 ) && (rc < 41)){
 				
        					addObjectToArray(newObjectBtn);
							columntwo.addChild(newObjectBtn);
							
							
					if ((rc == 40) && (rowno != (len - 1))) { 
							//Alert.show(rc + " : " + len);
						swapObject(newObject,40);
					}
	    	} else if (rc >= 41){
        					addObjectToArray(newObjectBtn);
							columnthree.addChild(newObjectBtn); 
        				}
        	return
        }
        public var row_ctr:int = 0;
		private function AddtoJobMenu(event:Event):void{
		
					columnone.removeAllChildren();
					columntwo.removeAllChildren();
					columnthree.removeAllChildren();
					
			 row_ctr = 0;
		
			for (var i:int=0;i<arr_kpimenu.length;i++)  {
				
				newObject = new CustomHead();
				
				newObject.customacb_id = arr_kpimenu[i]["id"];   
				newObject.customacb_name = arr_kpimenu[i]["name"];
				newObject.label = arr_kpimenu[i]["name"];
				
				DisplayToColumnObject(row_ctr);
				row_ctr = row_ctr + 1;
			// Add the 'job' for each group.
 			 if (arr_kpimenu[i].job is ObjectProxy){
 					arr_kpimenu[i].job = new ArrayCollection(ArrayUtil.toArray(arr_kpimenu[i].job)); 
 			 }
 			 		for (var ib:int=0;ib<(arr_kpimenu[i].job).length;ib++){
							newObjectBtn = new CustomButton();
							newObjectBtn.group_code = arr_kpimenu[i]["id"];   
							newObjectBtn.custombtn_code = arr_kpimenu[i].job[ib].code;
							newObjectBtn.custombtn_name = arr_kpimenu[i].job[ib].name;
							newObjectBtn.custombtn_image = arr_kpimenu[i].job[ib].image;
							newObjectBtn.custombtn_jobid = arr_kpimenu[i].job[ib].job_id;
							newObjectBtn.custombtn_jobprogram = arr_kpimenu[i].job[ib].job_program;
							newObjectBtn.custombtn_company = Application.application.parameters.c;
							newObjectBtn.custombtn_company_description = Application.application.parameters.cd;
							newObjectBtn.custombtn_chain = JobMenuChainCombo.selectedItem.id;
							newObjectBtn.system_code = j_syscode ;   
            				newObjectBtn.subsystem_code = j_subsyscode;
							
							newObjectBtn.styleName="jobButton" + JobMenuChainCombo.selectedItem.id;
							//newObjectBtn.l_connection = s_connection; 
							DisplayToColumnObjectButton(row_ctr, ib, (arr_kpimenu[i].job).length);
							row_ctr = row_ctr + 1;
					}
 			}
 		}
		private var aFormFields:Array = new Array();
		
		private function job_jobrun(event:ResultEvent):void {
        		    
        		if ( event.result.status != 'OK' ) {
        	
					var s_ret:String = resultStatus(event.result.status, event.result.reason);  
					AlertMessageShow(s_ret);
					return;
        		}
		}