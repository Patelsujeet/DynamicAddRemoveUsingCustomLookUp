trigger OppProductsBefore on OpportunityLineItem (before insert, before update) {
    for(OpportunityLineItem oppProduct : Trigger.new) {
        //Update Discount field to be related to net/gross prices (using trigger as to update standard Salesforce field)
        if ((oppProduct.UnitPrice > 0) && (oppProduct.Net_Price__c > 0)) {
            oppProduct.Discount = ((oppProduct.UnitPrice - oppProduct.Net_Price__c) / oppProduct.UnitPrice) * 100.0;
        }
        else {
            oppProduct.Discount = 0;
        }
    }
}