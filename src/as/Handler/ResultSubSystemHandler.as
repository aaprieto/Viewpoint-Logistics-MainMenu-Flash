// ActionScript file
		import mx.collections.ArrayCollection;
		import mx.rpc.events.ResultEvent;
		import mx.utils.ArrayUtil;
		import mx.utils.ObjectProxy;

		[Bindable]	private var arr_kpimenu:ArrayCollection;
		[Bindable]  public var ChainGroup:ArrayCollection = new ArrayCollection;  	
 		[Bindable]  public var FormatChainGroup:ArrayCollection = new ArrayCollection;
 		

		private function subsystemchainCodeResultHandler(evt:ResultEvent):void{
			if ( evt.result.ezware_response.status == 'OK' ) {
						
						ChainGroup = new ArrayCollection;
						
						if (evt.result.ezware_response.refresh_data.chaingroup == null){
							//Alert.show(comp_code + " does not have the necessary Chain Codes for Sub System.  Please contact your System Administrator.");
							AlertMessageShow("You do not have the necessary access for " +  comp_code +  ". Please contact your System Administrator.");
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
										if (chain == FormatChainGroup[ia]["id"]){
											SubSystemChainCombo.selectedIndex = ia;
										}
									}
								getSubMenu();
						}
		
			
			}else {
				
				var s_ret:String = resultStatus(evt.result.ezware_response.status, evt.result.ezware_response.reason);  
				AlertMessageShow(s_ret);
				return;
				
			}	
		} 
		
		
		
		private function SubSystemKPIMenuResultHandler(event:ResultEvent):void {
			 
			if ( event.result.ezware_response.status == 'OK' ) {
					
						if (event.result.ezware_response.refresh_data.subsystems == null)
			            {
			                arr_kpimenu=new ArrayCollection()
			            }
			            
						if (event.result.ezware_response.refresh_data.subsystems.subsystem != null){
							
							if (event.result.ezware_response.refresh_data.subsystems.subsystem == null)
			            	{
			                	arr_kpimenu=new ArrayCollection()
			            	}
			             
			            	else if (event.result.ezware_response.refresh_data.subsystems.subsystem is ArrayCollection)
			            	{
			              		arr_kpimenu=event.result.ezware_response.refresh_data.subsystems.subsystem;
			            	}
			            	else if (event.result.ezware_response.refresh_data.subsystems.subsystem is ObjectProxy)
			            
			            	{
			            	arr_kpimenu = new ArrayCollection(ArrayUtil.toArray(event.result.ezware_response.refresh_data.subsystems.subsystem));  
			            	}
			         // Alert.show(arr_kpimenu.length.toString());
							arr_kpimenu.refresh();
							
							//Alert.show(arr_kpimenu.length.toString());
							
						}
						/* call the resolution changer.  */
						detectScreenResolutionforSubSystem();
						// time to refresh the KPI Menu records
						
						
						
						if (Application.application.parameters.so =='basic'){
							this.setStyle("backgroundImage","");
							for (var i:int=0;i<arr_kpimenu.length;i++) {
								arr_kpimenu[i].image = '';
							}
						} else {
							//this.setStyle("backgroundImage","@Embed(source='image/Blue3.png')")
							this.setStyle("backgroundImage","image/Blue3.png")
						}
						
						kpi.pass_companycode = comp_code;
						kpi.pass_url = my_pass_url;
						kpi.pass_arr_kpimenu = arr_kpimenu; 
			
			}else {
				
				var s_ret:String = resultStatus(event.result.ezware_response.status, event.result.ezware_response.reason);  
				AlertMessageShow(s_ret);
				return;
				
			}			
			
		}
		
		private function SubSystemglobalvariableChainResultHandler(evt:ResultEvent):void 
		{
			/*  Not expecting any result.  I'm not sure if this is a good practice of leaving this hanging but I will for now.
			*/
			//Alert.show("Success");
		}	
		private function globalvariableSystemCodeResultHandler(evt:ResultEvent):void
		{
			/*  Not expecting any result.  I'm not sure if this is a good practice of leaving this hanging but I will for now.
			*/
			//Alert.show("Success");
		}	
		private function subsysjobrun(event:ResultEvent):void {
        		
        		if ( event.result.status != 'OK' ) {
        	
					var s_ret:String = resultStatus(event.result.status, event.result.reason);  
					AlertMessageShow(s_ret);
					return;
        		}
		}