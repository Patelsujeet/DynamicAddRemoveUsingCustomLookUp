trigger UpdateDiscountedWoLineOnWorkOrder on WorkOrderLineItem (after update,after Insert,after Delete) {
    if(Tigger_Controller__c.getInstance().UpdateDiscountedWoLineOnWorkOrder__c){
        
        List<Id> WorkOrdersId = new List<Id>();
        
        if (Trigger.isUpdate){
            for(WorkOrderLineItem Woli : Trigger.New){
                WorkOrdersId.add(Woli.WorkOrderId); 
            }
        }
        else if(Trigger.isInsert){
            for(WorkOrderLineItem Woli : Trigger.New){
                WorkOrdersId.add(Woli.WorkOrderId); 
            }
        }
        else if(Trigger.isDelete){
            for(WorkOrderLineItem Woli : Trigger.old){
                WorkOrdersId.add(Woli.WorkOrderId); 
            }
        }
        system.debug(WorkOrdersId);
        List<WorkOrder> WorkOrders = [Select Id,Charge_type_Actual__c,Account_Business_Unit_Code__c,No_Charge_Reason_India__c From WorkOrder where Id = :  WorkOrdersId];
        system.debug(WorkOrders);
        /*integer Discount = 0;
integer NonBillable = 0;
integer DiscLine = 0;
integer Billable = 0;*/
        Decimal BillablePrice = 0;
        Decimal OfferedPrice = 0;
        String Technician = '';
        for(WorkOrder WO : WorkOrders){
            if(WO.Account_Business_Unit_Code__c == '300'){
                list<WorkOrderLineItem> Woli = [Select Id,PricebookEntry.Name,RecordType_Name__c,Product2Id,Is_Discounted__c,Is_Billable__c,RecordTypeId,List_Price_as_per_Pricebook__c,UnitPrice,Shop_Tech_Type__c,Technician__r.Name From WorkOrderLineItem Where WorkOrderId = : WO.Id ];
                
                for(WorkOrderLineItem li : Woli){
                    //String ActivityType = ;
                    String RecordType = li.RecordType_Name__c;
                    system.debug(li.RecordType_Name__c);
                    String PE = li.PricebookEntry.Name;
                    system.debug(PE);
                    //PricebookEntry PE = [SELECT Id,Name FROM PricebookEntry WHERE Product2Id == li.Product2Id];
                    // Include Unit and List Price Of "Labor Record Type" in Approval Price
                    if(RecordType == 'Labor' ){
                        if(PE == 'Service Charges_Export' || PE == 'Service Charges_Domestic'){
                            BillablePrice = BillablePrice + li.List_Price_as_per_Pricebook__c;
                            OfferedPrice = OfferedPrice + li.UnitPrice;
                        }
                        //Include Unit and List Price Of "Labor Record Type" in Approval Price for "specific special job assebmer" Activity Type
                        else if(PE == 'Special job Assembler'){
                            if(li.Shop_Tech_Type__c != 'Runoff Engineer-Operation' &&  li.Shop_Tech_Type__c != 'Design Engineer' &&  li.Shop_Tech_Type__c != 'Quality Engineer' &&  li.Shop_Tech_Type__c != 'Supplier (Vendor)'){
                                BillablePrice = BillablePrice + li.List_Price_as_per_Pricebook__c;
                                OfferedPrice = OfferedPrice + li.UnitPrice;
                            }
                        }
                    }
                    //Include Unit and List Price Of "Tool Record Type" in Approval Price 
                    else if(RecordType == 'Tool'){
                        //Include Unit and List Price Of "Registration Charges" Activity Type in Approval Price
                        if(PE == 'Registration Charges' || PE == 'Registration Charges'){
                            BillablePrice = BillablePrice + li.List_Price_as_per_Pricebook__c;
                            OfferedPrice = OfferedPrice + li.UnitPrice;
                        }
                        //Logic to Add Service Engineer on Work Order
                    }
                    if(Technician == ''){
                        Technician = li.Technician__r.Name;
                    }
                    else if(Technician != '' && !Technician.Contains(li.Technician__r.Name)){
                        Technician = Technician +','+ li.Technician__r.Name;
                        
                    }
                }
                
                WO.Billable_Price_India_Approval__c = BillablePrice;
                WO.Offered_Price_India_Approval__c = OfferedPrice;
                WO.Service_Engineer__c = Technician;
                Update Wo;
                
            }   
        }
    }
}                

/*if(li.Is_Discounted__c && (RecordType.contains('012V00000004j0P') || RecordType.contains('012V00000000iI7')) && !ActivityType.contains('01tV00000040Cj4IAE') && !ActivityType.contains('01tV00000040Ciz') && !ActivityType.contains('01tV00000040Cj9') && !ActivityType.contains('01tV00000040CjE') && !ActivityType.contains('01tV0000003zKZy')){
DiscLine++; 
}
if((RecordType.contains('012V00000004j0P') || RecordType.contains('012V00000000iI7')) && !ActivityType.contains('01tV00000040Cj4IAE') && !ActivityType.contains('01tV00000040Ciz') && !ActivityType.contains('01tV00000040Cj9') && !ActivityType.contains('01tV00000040CjE') && !ActivityType.contains('01tV0000003zKZy')){
//Billable++;
BillablePrice = BillablePrice + li.List_Price_as_per_Pricebook__c;
OfferedPrice = OfferedPrice + li.UnitPrice;
}
if(!li.Is_Billable__c && (RecordType.contains('012V00000004j0P') || RecordType.contains('012V00000000iI7')) && !ActivityType.contains('01tV00000040Cj4IAE') && !ActivityType.contains('01tV00000040Ciz') && !ActivityType.contains('01tV00000040Cj9') && !ActivityType.contains('01tV00000040CjE') && !ActivityType.contains('01tV0000003zKZy')){
NonBillable++;
}
}
WO.Number_of_Discounted_WO_Line__c = DiscLine;
WO.Number_of_Actual_Billable_line_India__c = Billable;
WO.Number_of_Entered_Non_Billable_WL_India__c = NonBillable;
WO.Billable_Price_India_Approval__c = BillablePrice;
WO.Offered_Price_India_Approval__c = OfferedPrice;
Update Wo;

//Update Charge Type for Work Order India
if(Wo.Charge_type_Actual__c == 'Chargeable'){
for(WorkOrderLineItem li : Woli){
if(li.Is_Discounted__c){
Discount++; 
}

else if((!li.Is_Billable__c) && (li.RecordTypeId == '012V00000004j0P')){
NonBillable++;
}


system.debug(Discount);
system.debug(NonBillable);
if(Discount == 0 && NonBillable == 0){
WO.Charge_Type__c = '';
Wo.No_Charge_Reason_India__c = '';
} 
else if(WO.Number_of_Actual_Billable_line__c == NonBillable ){
WO.Charge_Type__c = 'Non-Chargeable';

}
else if(Discount > 0 || (NonBillable > 0 && WO.Number_of_Actual_Billable_line__c != NonBillable) ){
WO.Charge_Type__c = 'Discounted Charges';
}
}
}*/