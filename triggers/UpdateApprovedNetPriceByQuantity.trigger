trigger UpdateApprovedNetPriceByQuantity on Opportunity (before update) {
    for(Opportunity opp: Trigger.New){
        Opportunity oldOpp = Trigger.OldMap.get(opp.Id);
        
        if((oldOpp.Quantity_Opportunity__c == 0.00 || oldOpp.Quantity_Opportunity__c == null) && (opp.Quantity_Opportunity__c != oldOpp.Quantity_Opportunity__c)) {
            if(opp.Quantity_Opportunity__c > 1){
                opp.Reviewed_Amount__c = opp.Reviewed_Amount__c * opp.Quantity_Opportunity__c;
            }
            else {
                opp.Reviewed_Amount__c = opp.Reviewed_Amount__c * 1;
            }
        }
    }
}