trigger UpdateOpportunityTerritory on Opportunity (after update) {

    for(Opportunity opp: Trigger.New){
        Opportunity oldOppo = Trigger.OldMap.get(opp.Id);
             // update territory assignment if Business Type changes on Opportunity
            if(opp.Business_Type__c != oldOppo.Business_Type__c){   
                List<Id> opplist = new List<Id>();
                opplist.add(opp.Id);
                
                // opportunity territory assignment filter          
                OppTerrAssignDefaultLogicFilter obj  = new OppTerrAssignDefaultLogicFilter();
                obj.getOpportunityTerritory2Assignments(opplist);
            }
    }
}