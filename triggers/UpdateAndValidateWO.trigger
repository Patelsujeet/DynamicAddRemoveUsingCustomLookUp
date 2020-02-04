trigger UpdateAndValidateWO on WorkOrder (before update,after update) {
    //To validate India Users to Close or Work Complete Work Orders Without Problem Summary and Work Line Entry
    if(Tigger_Controller__c.getInstance().UpdateAndValidateWO__c){
    integer openWOs = 0;
    String Reg = '';
        
    If(Trigger.isBefore){
        List<id> WOs = new List<id>();
        for(WorkOrder WO : Trigger.New){
            WorkOrder OldMap = Trigger.OldMap.get(WO.Id);
            WOs.add(WO.id);
            // Update Work type on Work Order when Wo is updated
            // Define Regions based on Account Business Unit Code of WO
            if(WO.Account_Business_Unit_Code__c == '300') {
                Reg = 'India';
            }
            else
            {
                Reg = 'USA';
            }
            //Account Acc = [select Id,Name From Account Where Name = 'FMI OFFICE WORK'];
            if(WO.Work_Type__c != Null && (Wo.WorkTypeId == Null || Wo.Work_Type__c != OldMap.Work_Type__c)){
                WorkType WT = [Select ID,Name,EstimatedDuration From WorkType Where (Name =: WO.Work_Type__c And Region__c =: Reg)];
                WO.Duration = WT.EstimatedDuration;
                WO.WorkTypeId = WT.Id; //WT.Id;
            }
            //Validate that Users have entered Work lines and Problem Description for WO. 
            if(WO.Account_Business_Unit_Code__c == '300' && ((WO.Status == 'Closed' && OldMap.Status != 'Closed') || (WO.Status == 'Work Complete' && OldMap.Status != 'Work Complete'))){
                list<WorkOrderLineItem> Woli = [Select Id,Is_Discounted__c From WorkOrderLineItem Where WorkOrderId = : WO.Id  ];
                list<Problem_Summary_and_Quality_Analysis__c> PSQA = [Select Name,Id From Problem_Summary_and_Quality_Analysis__c Where Work_Order__c = : WO.Id ];
                
                if(WO.Work_Type__c != 'CCV' && WO.Case_Type__c != 'Other' && (Woli.size()==0) && (PSQA.size()==0)){
                    WO.addError('Add "Labor,Travel and Problem Summary" before Changing Status to "close" or "Work Complete".');
                }
                else if(Woli.size()==0 ){
                    WO.addError('Add "Labor and Travel" before Changing Status to "close" or "Work Complete".');
                }
                if(WO.Work_Type__c != 'CCV' && WO.Case_Type__c != 'Other' && PSQA.size()==0){
                WO.addError('Add "Problem Summary" before Changing Status to "close" or "Work Complete".');
                }
                //If WO can only closed by ServiceAppointment Owners of that Work Order
                list<ServiceAppointment> SAs = [Select OwnerId, ParentRecordId FROM ServiceAppointment WHERE ParentRecordId =: WOs];
                Set<String> SAOID = new Set<String>();
                String RuId = UserInfo.getUserId();
                
                
                if(WO.Account_Business_Unit_Code__c == '300' && SAs.size()>0 && (WO.Status == 'Work Complete' && OldMap.Status != 'Work Complete')){
                    For(ServiceAppointment SA : SAs){
                        SAOID.add(SA.OwnerId);
                    }
                    system.debug(SAOID.Contains(RuId));
                    system.debug(SAOID);
                    if(!(SAOID.Contains(RuId))){
                        WO.addError('Please Contact Service Appointment Owner to "Work Complete" this Work Order.');
                    }
                }
        }
            
            
            //If Owner is Changed then Change the Service Territory of WO accordingly.
            if(WO.Account_Business_Unit_Code__c == '300' && WO.OwnerId != OldMap.OwnerId){
                User UserTerr = [Select id,Territory__c From User Where id = : WO.OwnerId];
                ServiceTerritory St = [Select id,Name From ServiceTerritory Where Name = : UserTerr.Territory__c];
                Wo.ServiceTerritoryId = St.Id;
            }
        }   
    }
    
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            for(WorkOrder WO : Trigger.New){
                WorkOrder OldMap = Trigger.OldMap.get(WO.Id);
                
                //Logic to validate Case don't have open Work Orders
                if((WO.Status == 'Closed' && OldMap.Status != 'Closed') || (WO.Status == 'Work Complete' && OldMap.Status != 'Work Complete')){
                    Case Cases = [Select Id,Status,CaseNumber,OwnerId From Case Where Id = : Wo.CaseId];
                    list<WorkOrder> OpenWO = [Select Id,Status,WorkOrderNumber From WorkOrder Where CaseId =: Cases.Id And Id !=: WO.Id];
                    for(WorkOrder WOs : OpenWO){
                        if(WOs.Status == 'New' || WOs.Status == 'Scheduled' || WOs.Status == 'In Progress' || WOs.Status == 'On Hold' || WOs.Status == 'Work Complete' || WOs.Status == 'Awaiting Approval' || WOs.Status == 'Rejected')
                            openWOs++;
                    }
                    if (WO.Do_You_Want_to_Close_the_Case__c == 'Yes' && openWOs > 0){
                        WO.addError('You can not close the case because there are open Work Orders related to case.' + Cases.CaseNumber + '\r\n' + 'Please select "NO" on field "Do You Want to Close this Case?".'+'\r\n'+' Also, Close all the open Work Orders then Close the case.' );
                    }
                    
                }            
                //Logic to Change Owner of SA and Add  Another Assigned Resource only for WO have One SA
                else if(WO.OwnerId != OldMap.OwnerId && WO.Account_Business_Unit_Code__c == '300'){
                    Case Cs = [Select Id,Status,CaseNumber,OwnerId From Case Where Id = : Wo.CaseId];
                    if(Cs.OwnerId == WO.OwnerId){
                        //List of SAs of Work Order
                        list<ServiceAppointment> SA = [Select OwnerId, SchedStartTime, SchedEndTime, ParentRecordId FROM ServiceAppointment WHERE ParentRecordId =: WO.Id];
                        //If WO has only One SA
                        if(SA.size() == 1){
                            //Update SA Owner as WO owner
                            SA[0].OwnerId = WO.OwnerId;
                            update SA;
                            /* //Remove AR of old Owner
list<AssignedResource> ASR = [Select Id From AssignedResource Where ServiceResource.RelatedRecordId =: OldMap.OwnerId AND ServiceAppointmentId = :SA[0].Id];
if(ASR.size() == 1){
Delete ASR;
}
ServiceResource sr = [SELECT Id,Name FROM ServiceResource WHERE RelatedRecordId =: WO.OwnerId];
list<AssignedResource> NewASR = [Select Id From AssignedResource Where ServiceResource.RelatedRecordId =: WO.OwnerId AND ServiceAppointmentId = :SA[0].Id];
if(sr != null && NewASR.size() == 0){
AssignedResource ar = new AssignedResource();
ar.ServiceResourceId = sr.Id;
ar.ServiceAppointmentId = SA[0].Id;
ar.Scheduled_Start_Date__c = SA[0].SchedStartTime;
ar.Scheduled_End_Date__c = SA[0].SchedEndTime;
ar.Work_Order__c = SA[0].ParentRecordId;
Insert ar;
}*/
                        }
                    }
                    
                }
                
            }
        }
    }
    }
}