trigger UpdateOpportunityAFMQuoteAmount on Aftermarket_Quote__c (after update) {
          
    for(Aftermarket_Quote__c AFMQuote: Trigger.New){

         List<Opportunity> RelatedAFMQuoteOpp = new List<Opportunity>();
         Aftermarket_Quote__c oldAFMQuote= Trigger.oldMap.get(AFMQuote.ID);
         Aftermarket_Quote__c newAFMQuote = Trigger.newMap.get(AFMQuote.ID);

      if(oldAFMQuote.Opportunity__c != newAFMQuote.Opportunity__c){ 
        if(newAFMQuote.Opportunity__c != null)
        {
        Opportunity currentAssignedOpp = [SELECT Id, Amount FROM Opportunity WHERE Id = :newAFMQuote.Opportunity__c];

            // Update new assigned Opportunity Amount
            Decimal currentOppAmountTotal = 0;
               for(Aftermarket_Quote__c quote: [Select Id, Opportunity__c, Quote_Amount__c from Aftermarket_Quote__c  where Opportunity__c =: currentAssignedOpp.Id]){
                   currentOppAmountTotal = currentOppAmountTotal + quote.Quote_Amount__c;
                   system.debug(quote);
                }
           currentAssignedOpp.Amount = currentOppAmountTotal;
           RelatedAFMQuoteOpp.add(currentAssignedOpp);
       }
            
        if(oldAFMQuote.Opportunity__c != null)
        {         
             Opportunity previousAssignedOpp = [SELECT Id, Amount FROM Opportunity WHERE Id = :oldAFMQuote.Opportunity__c];                                           
            // Update previous Opportunity Amount
            Decimal previousOppAmountTotal = 0;
               for(Aftermarket_Quote__c quote: [Select Id, Opportunity__c, Quote_Amount__c from Aftermarket_Quote__c  where Opportunity__c =: previousAssignedOpp.Id]){
                   previousOppAmountTotal = previousOppAmountTotal + quote.Quote_Amount__c;
                   system.debug(quote);
                }
           previousAssignedOpp.Amount = previousOppAmountTotal;
           RelatedAFMQuoteOpp.add(previousAssignedOpp);
        }  
      }
       update RelatedAFMQuoteOpp; 
    }               
}