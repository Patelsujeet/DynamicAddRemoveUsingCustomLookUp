trigger OpportunityLineItemTrigger on OpportunityLineItem (before insert, before update, before delete, after insert, after update, after delete,  after undelete) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            // Before insert
        }
        
        if (Trigger.isUpdate) {
            // Before update
        }
        
        if (Trigger.isDelete) {
            // Before delete
        }
    }
    
    else if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            // After insert
        }
        
        if (Trigger.isUpdate) {
            // After update
            List<BigMachines__Quote_Product__c> updatedBMIQuotes = new List<BigMachines__Quote_Product__c>();
            
            // Loop over new values
            for (OpportunityLineItem oli : Trigger.new) {
                OpportunityLineItem oppProduct = [SELECT Id, Primary__c, BigMachines__Synchronization_Id__c FROM OpportunityLineItem WHERE Id = :oli.Id];
                
                // Get array of quote product(s) with matching sync id
                BigMachines__Quote_Product__c[] bmiQuoteProducts = [SELECT Id, Primary__c FROM BigMachines__Quote_Product__c WHERE BigMachines__Synchronization_Id__c = :oli.BigMachines__Synchronization_Id__c];

                if (bmiQuoteProducts.size() > 0)
                {
                    if (bmiQuoteProducts[0].Primary__c != oppProduct.Primary__c) {
                        bmiQuoteProducts[0].Primary__c = oppProduct.Primary__c;
                        
                        updatedBMIQuotes.add(bmiQuoteProducts[0]);
                    }
                }
            }
            
            if (updatedBMIQuotes.size() > 0)
                update updatedBMIQuotes;
        }
        
        if (Trigger.isDelete) {
            // After delete
        }
    }
    
}