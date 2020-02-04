trigger ERNApproverTriggerIndia on ERN_Approval__c (after insert,after update) {
 if(Trigger.isAfter){
        if(Trigger.isUpdate){
        try{
            ERNActions.CreateSalesERNApprovers(Trigger.oldMap,Trigger.newMap);
            ERNActions.ERNAppUpdatesOnERN(Trigger.oldMap, Trigger.newMap);
            ERNActions.CreateServiceERNApprovers(Trigger.oldMap,Trigger.newMap);
            }
            catch(Exception e){}
        }
    }
}