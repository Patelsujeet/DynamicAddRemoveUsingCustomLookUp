trigger ERNTriggerIndia on ERN__c (before insert,after insert,before update,after update) {
    if(Trigger.isBefore){
        if (Trigger.isInsert) {
        ERNActions.ValidateSalesERN(Trigger.oldMap, Trigger.New);
        }
        else if(Trigger.isUpdate){
        ERNActions.ValidateSalesERN(Trigger.oldMap, Trigger.New);
        }
    }
    if(Trigger.isAfter){
        if (Trigger.isInsert) {
        //ERNActions.CreateERNApprover(Trigger.oldMap,Trigger.newMap);
        }
        else if(Trigger.isUpdate){
        ERNActions.CreateSPEERNApprover(Trigger.oldMap,Trigger.newMap);
        ERNActions.ERNUpdatesOnQuote(Trigger.oldMap, Trigger.newMap);
            
        ERNActions.CreateFirstServiceERNApprovers(Trigger.oldMap, Trigger.newMap);
        }
    }
}