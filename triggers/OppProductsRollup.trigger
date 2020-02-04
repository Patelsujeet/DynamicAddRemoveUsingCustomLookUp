trigger OppProductsRollup on OpportunityLineItem (after insert, after update, after delete) {
    OpportunityLineItem[] objects = new List<OpportunityLineItem>();

    // flag used to check if the roll up should be performed (can be set not to by the Opportunity.Override_Approved_Net_Price_Quantity__c field)
    Boolean performRollup = true;

    // Get initial state of Opportunity checkbox
    OpportunityLineItem[] newOrEditRecords = new List<OpportunityLineItem>();
    if (Trigger.isDelete) {
        newOrEditRecords = Trigger.old;
    }
    else {
        newOrEditRecords = Trigger.new;
    }
    Opportunity opp = [SELECT Override_Approved_Net_Price_Quantity__c FROM Opportunity WHERE Id = :newOrEditRecords[0].OpportunityId];
    Boolean isOverrideChecked = opp.Override_Approved_Net_Price_Quantity__c;

    // if override is checked, initially set performRollup to false (to skip summarization)
    if (isOverrideChecked) {
        performRollup = false;
    }

    if (Trigger.isDelete) {
        objects = Trigger.old;
    } else {
        // If we're still performing the rollup, loop over updated records to get the ones with value
        if (Trigger.isUpdate) {
            for(OpportunityLineItem oppProduct : Trigger.new)
            {
                //Only include for aggregation if one of the fields we care about changed (Primary, Quantity, and Total(?) Price)
                OpportunityLineItem oldOppProd = Trigger.oldMap.get(oppProduct.ID);
                OpportunityLineItem newOppProd = Trigger.newMap.get(oppProduct.ID);

                // If any new OpportunityLineItem is set as Primary__c, we should proceed with summarization (i.e. set performRollup to true)
                if (newOppProd.Primary__c) {
                    performRollup = true;
                }

                if(
                    (oldOppProd.Primary__c != newOppProd.Primary__c)    // Primary
                    || (oldOppProd.Quantity != newOppProd.Quantity)     // Quantity
                    || (oldOppProd.UnitPrice != newOppProd.UnitPrice) // Unit Price
                    || (oldOppProd.Net_Price__c != newOppProd.Net_Price__c) // Net Price
                    //|| (oldOppProd.TotalPrice != newOppProd.TotalPrice) // Total Price
                )
                {
                    // Add to objects array
                    objects.add(newOppProd);
                }
            }
        }
        else {
            //not Delete, not Update, must be Insert
            objects = Trigger.new;

            // Loop over records to check if any are marked as primary
            for(OpportunityLineItem oppProduct : Trigger.new) {
              if (oppProduct.Primary__c) {
                  performRollup = true;
              }
            }
        }
    }

    // Check if we should update the Opportunity.Override_Approved_Net_Price_Quantity__c field
    if (isOverrideChecked && performRollup) {
        opp.Override_Approved_Net_Price_Quantity__c = false;
        update opp;
    }

    // If still performing the roll up calculation, create rollup context and update records
    if (performRollup) {
        // Set up roll up context for Opportunity Products that have the Primary checkbox checked
        LREngine.Context ctx = new LREngine.Context(Opportunity.SobjectType,
                                                OpportunityLineItem.SobjectType,
                                                Schema.SObjectType.OpportunityLineItem.fields.OpportunityId,
                                                'Primary__c = true'
                                                );

        // Add aggregation for Quantity
        ctx.add(
                new LREngine.RollupSummaryField(
                                                Schema.SObjectType.Opportunity.fields.Quantity_Opportunity__c,
                                                Schema.SObjectType.OpportunityLineItem.fields.Quantity,
                                                LREngine.RollupOperation.Sum
                                                ));

        // Add aggregation for Gross Price
        ctx.add(
                new LREngine.RollupSummaryField(
                                                Schema.SObjectType.Opportunity.fields.Opportunity_Gross_Price__c,
                                                Schema.SObjectType.OpportunityLineItem.fields.Extended_Gross_Price__c,
                                                LREngine.RollupOperation.Sum
                                                ));
        // Add aggregation for Net Price
        ctx.add(
                new LREngine.RollupSummaryField(
                                                Schema.SObjectType.Opportunity.fields.Reviewed_Amount__c,
                                                Schema.SObjectType.OpportunityLineItem.fields.TotalPrice,
                                                LREngine.RollupOperation.Sum
                                                ));
        /*
          Calling rollup method returns in memory master objects with aggregated values in them.
          Please note these master records are not persisted back, so that client gets a chance
          to post process them after rollup
          */
        if (objects != null) {
            Sobject[] masters = LREngine.rollUp(ctx, objects);
            // Persiste the changes in master
            update masters;
        }
    }
}