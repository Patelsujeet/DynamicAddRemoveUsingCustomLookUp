trigger CountCCVWorkOrdersOnasset on WorkOrder (after insert, after update) {
    
    Set<Id> AssetIds = new Set<Id>();
    if(Trigger.isInsert){
    for(WorkOrder con : trigger.new){
        if(con.AssetId != null && con.Work_Type__c == 'CCV'){
            AssetIds.add(con.AssetId);
        }
    }
    
    Map<Id,Asset> accMap = new Map<Id,Asset>([Select Number_Of_CCV_Case__c  from Asset where id in :AssetIds]);
    
    for(WorkOrder con : trigger.new){
        if(accMap.containsKey(con.AssetId)){
            if(accMap.get(con.AssetId).Number_Of_CCV_Case__c == null && con.Work_Type__c == 'CCV'){
                accMap.get(con.AssetId).Number_Of_CCV_Case__c   = 1;
            }
           else{
            accMap.get(con.AssetId).Number_Of_CCV_Case__c   = accMap.get(con.AssetId).Number_Of_CCV_Case__c + 1;
           }        
        }
    }
    update accMap.values();
    }
  if(Trigger.isUpdate){
      Set<Id> OldAssetIds_Set = new Set<Id>();
      for(WorkOrder con : trigger.new){
    //For new workorder
            if(con.AssetId != Trigger.oldMap.get(con.id).AssetId && con.Work_Type__c == 'CCV')
            {
                AssetIds.add(con.AssetId);
            }
            //For old workorders with updated type
            if(con.AssetId == Trigger.oldMap.get(con.id).AssetId && con.Work_Type__c != Trigger.oldMap.get(con.id).Work_Type__c && con.Work_Type__c == 'CCV')
            {
                AssetIds.add(con.AssetId);
            }
            OldAssetIds_Set.add(Trigger.oldMap.get(con.id).AssetId);
      }
    Map<Id,Asset> accMap = new Map<Id,Asset>([Select Number_Of_CCV_Case__c  from Asset where id in :AssetIds]);
    
    for(WorkOrder con : trigger.new){
        if(accMap.containsKey(con.AssetId)){
            if(accMap.get(con.AssetId).Number_Of_CCV_Case__c == null && con.Work_Type__c == 'CCV'){
                accMap.get(con.AssetId).Number_Of_CCV_Case__c   = 1;
            }
           else{
            accMap.get(con.AssetId).Number_Of_CCV_Case__c   = accMap.get(con.AssetId).Number_Of_CCV_Case__c + 1;
           }        
        }
    }
    update accMap.values();
    }  
}