trigger PrimaryQuoteTrigger on BigMachines__Quote__c (before insert, before update, before delete, after insert, after update, after delete) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            PrimaryQuoteActions.SetOpportunityidOnQuotePrduct(Trigger.oldMap, Trigger.newMap);
            PrimaryQuoteActions.SetPriceAndQuantityOnOpportunity(Trigger.oldMap, Trigger.newMap);
        } else if(Trigger.isUpdate){
            PrimaryQuoteActions.SetOpportunityidOnQuotePrduct(Trigger.oldMap, Trigger.newMap);
            PrimaryQuoteActions.SetPriceAndQuantityOnOpportunity(Trigger.oldMap, Trigger.newMap);
        } else if(Trigger.isDelete){
            PrimaryQuoteActions.SetOpportunityidOnQuotePrduct(null, Trigger.oldMap);
            PrimaryQuoteActions.SetPriceAndQuantityOnOpportunity(null, Trigger.oldMap);
        }
    }
}