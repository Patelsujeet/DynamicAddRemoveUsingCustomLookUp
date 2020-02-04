trigger WorkOrderLineItemTrigger on WorkOrderLineItem (before insert, before update, before delete, after insert, after update, after delete) {

    System.debug('Work Order Line Item Trigger');

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
            blogicWorkOrderLineItem.updateServiceContractHours(Trigger.oldMap, Trigger.newMap);

        } else if (Trigger.isUpdate) {
            //After Update
            blogicWorkOrderLineItem.updateServiceContractHours(Trigger.oldMap, Trigger.newMap);

        } else if (Trigger.isDelete) {
            //After Delete
            blogicWorkOrderLineItem.updateServiceContractHours(null, Trigger.oldMap);
        }
    }

}