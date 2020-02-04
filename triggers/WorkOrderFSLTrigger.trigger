trigger WorkOrderFSLTrigger on WorkOrder (before insert, before update, before delete, after insert, after update, after delete) {
    
    System.debug('Work Order Trigger');
    if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                //Before Insert
                blogicWorkOrder.setPricebookAndTerritoryAndEntitlement(Trigger.new);
                
            } else if (Trigger.isUpdate) {
                //Before Update
                blogicWorkOrder.setFSLApprover(Trigger.new, Trigger.oldMap);
                //blogicWorkOrder.updateWorkTypefields(Trigger.oldMap, Trigger.newMap);
                
            } else if (Trigger.isDelete) {
                //Before Delete
                
            }
        }
        
        if (Trigger.isAfter) {
            if (Trigger.isInsert) {
                //After Insert
                blogicWorkOrder.updateAccountRollup(Trigger.oldMap, Trigger.newMap);
                blogicWorkOrder.updateServiceContractHours(Trigger.oldMap, Trigger.newMap);               
                
            } else if (Trigger.isUpdate) {
                //After Update
                blogicWorkOrder.updateAccountRollup(Trigger.oldMap, Trigger.newMap);
                blogicWorkOrder.updateCaseTotals(Trigger.oldMap, Trigger.newMap);
                blogicWorkOrder.updateServiceContractHours(Trigger.oldMap, Trigger.newMap);
                blogicWorkOrder.updateWTOnSA(Trigger.oldMap, Trigger.newMap);
                //blogicWorkOrder.updateServiceAppointments(Trigger.oldMap, Trigger.newMap);
                
            } else if (Trigger.isDelete) {
                //After Delete
                blogicWorkOrder.updateServiceContractHours(null, Trigger.oldMap);
                
            }
        }
    
}