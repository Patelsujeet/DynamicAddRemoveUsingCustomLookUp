trigger CaseAssetTrigger on Case_Asset__c (before insert, before update, before delete, after insert, after update, after delete) {

    System.debug('Case Asset Trigger');

    /*
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            //Before Insert

        } else if (Trigger.isUpdate) {
            //Before Update

        } else if (Trigger.isDelete) {
            //Before Delete

        }
    }
    */

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            //After Insert
            blogicCaseAsset.createWorkOrders(Trigger.newMap);
            
            //Change After Sujeet
            /*List<ID> ls=new List<Id>();
            for(Case_Asset__c c:trigger.new){
                    ls.add(c.Id);
            }
            if(ls!=null){
             blogicCaseAsset.createWorkOrders(ls);   
            }*/
             
          
        }
     
    }

}