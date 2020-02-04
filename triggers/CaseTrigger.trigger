trigger CaseTrigger on Case (before insert, before update, before delete, after insert, after update, after delete) {

    System.debug('Case Trigger');

    if (Trigger.isBefore) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            //Before Insert/Update
            blogicCase.UpdateCaseWorkOrder(Trigger.new);
        } else if (Trigger.isDelete) {
            //Before Delete
        }
    }

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            //After Insert            
            blogicCase.createCaseAssetsOnInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            //After Update
            blogicCase.createWorkOrdersOnTransfer(Trigger.oldMap, Trigger.newMap);
        } else if (Trigger.isDelete) {
            //After Delete

        }
    }

}