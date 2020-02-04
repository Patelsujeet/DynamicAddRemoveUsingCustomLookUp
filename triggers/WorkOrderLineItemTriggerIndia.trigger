trigger WorkOrderLineItemTriggerIndia on WorkOrderLineItem (before insert, before update, before delete, after insert, after update, after delete) {
if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            //After Insert
            blogicWorkOrderLineItemIndia.SetApprovalAmountOnWoAndVisitsonSC(Trigger.oldMap, Trigger.newMap);
            blogicWorkOrderLineItemIndia.SetTimeSheetAndInvoiceAmountonWoLi(Trigger.oldMap, Trigger.newMap);

        } else if (Trigger.isUpdate) {
            //After Update
            blogicWorkOrderLineItemIndia.SetApprovalAmountOnWoAndVisitsonSC(Trigger.oldMap, Trigger.newMap);
            blogicWorkOrderLineItemIndia.SetTimeSheetAndInvoiceAmountonWoLi(Trigger.oldMap, Trigger.newMap);

        } else if (Trigger.isDelete) {
            //After Delete
            blogicWorkOrderLineItemIndia.SetApprovalAmountOnWoAndVisitsonSC(null, Trigger.oldMap);
        }
    }
}