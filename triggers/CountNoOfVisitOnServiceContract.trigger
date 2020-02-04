trigger CountNoOfVisitOnServiceContract on WorkOrder (Before Update) {
    if(Tigger_Controller__c.getInstance().CountNoOfVisitOnServiceContract__c){
    Set <Id> scIds = New Set <Id>();//List of Selected ServcieContractId on Work Order
    list<Id> AccIDs = new list<Id>();//List of AccountId of Work Orders
    for(WorkOrder wo : Trigger.New){
        AccIDs.add(wo.AccountId);
    }
    Map <Id,ServiceContract> AccScs = new Map<Id,ServiceContract>([Select AccountId,Name From ServiceContract Where AccountId =: AccIDs AND Status = 'Active'and Remaining_AMC_Visits__c>0]);
    for(WorkOrder wo : Trigger.New){
        WorkOrder OldMap = Trigger.OldMap.get(WO.Id);
        
        //for redirect user to select No Charge Reason or Service Contract
        if (wo.Account_Business_Unit_Code__c == '300' && wo.No_Charge_Amount_India__c > 0 && wo.Visit_Type__c == 'Visit' && wo.Charge_type_Actual__c == 'Chargeable' && 
            (wo.Charge_Type__c == 'Non-Chargeable' || wo.Charge_Type__c == 'Discounted Charges')&& wo.Status == 'Work Complete' && OldMap.Status != 'Work Complete' && 
            wo.ServiceContractId==Null && wo.No_Charge_Reason_India__c==Null ){
           
            /*    if(SC!= Null)
            AccScs.add(SC);*/
            //system.debug(AccIDs);          
            //system.debug(AccScs);
            //Check Service Contract is available on Account of WorkOrder
            if(AccScs.size()>0){
                for(ServiceContract sc : AccScs.values()){
                    if(wo.AccountId == sc.AccountId)
                    wo.ServiceContractId.addError('Please Select Service Contract for AMC Visit.');
                }
                
            }
            else{
                wo.No_Charge_Reason_India__c.addError('Enter No Charge Reason when Charge type is "Discounted Charges" or "Non-Chargeable".');
            }
        }
    //After Service Contract Selected by User on Work Order, Count Number of Labour line Items and populate it on Selected Service Contract 
    if (wo.Account_Business_Unit_Code__c == '300' && wo.ServiceContractId != NULL){
    //ServiceContract SCC = [Select id,Name From ServiceContract Where id =: wo.ServiceContractId];
    scIds.add(wo.ServiceContractId);
        }
    }
    List<ServiceContract> scs = [Select Id,Name From ServiceContract Where Id =: scIds]; //List of Service Contract Selected on WorkOrders
    //List of WorkOrder & WorkOrderLine on which above Sercive Contract Selected
    list <WorkOrder> wos = [select id, WorkOrderNumber,ServiceContractId,(Select Id,PricebookEntry.Name from WorkOrderLineItems ) from WorkOrder where ServiceContractId =: scIds];
    List<ServiceContract> SCUpdate = new List<ServiceContract>();
    integer NOWOLI = 0;
    for(ServiceContract sc : scs){
        
        for (WorkOrder wo : wos){
            //list <WorkOrderLineItem> wolis = [select Id,PricebookEntry.Name from WorkOrderLineItem where WorkOrderId = :wo.Id];
            for (WorkOrderLineItem li : wo.WorkOrderLineItems){
                if (wo.ServiceContractId == sc.Id && (li.PricebookEntry.Name == 'Service Charges_Export' || li.PricebookEntry.Name == 'Service Charges_Domestic')){
                    NOWOLI++;
                }
            }
        }
        sc.No_of_AMC_Performed__c = NOWOLI;
        SCUpdate.add(sc);
    }
    
   Update SCUpdate;
}
}