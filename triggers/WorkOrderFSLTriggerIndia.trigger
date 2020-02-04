trigger WorkOrderFSLTriggerIndia on WorkOrder (before insert, before update, after insert, after update,after delete) {
System.debug('Work Order Trigger India');
    if (Trigger.isBefore) {
            if (Trigger.isInsert) {
            blogicWorkOrderIndia.SetAccountCurrencyAndPricebook(null, Trigger.new);
            } else if (Trigger.isUpdate) {
            blogicWorkOrderIndia.SetAccountCurrencyAndPricebook(Trigger.oldMap, Trigger.new);
            blogicWorkOrderIndia.ValidationsOnWo(Trigger.oldMap, Trigger.newMap);
            
            }
    }
    if(Trigger.isAfter) {
        if (Trigger.isInsert) {
			blogicWorkOrderIndia.UpdateOwnerActions(null, Trigger.newMap);
			blogicWorkOrderIndia.CountCCVWOonAsset(null, Trigger.newMap);            
            } 
        else if (Trigger.isUpdate) {
            blogicWorkOrderIndia.SetNoOfVisitOnSCAndUpdateSTonWO(Trigger.oldMap, Trigger.newMap);
            blogicWorkOrderIndia.UpdateOwnerActions(Trigger.oldMap, Trigger.newMap);
            blogicWorkOrderIndia.CountCCVWOonAsset(Trigger.oldMap, Trigger.newMap);
            blogicWorkOrderIndia.SetWorkTypeIdAndChargeTypeonWO(Trigger.oldMap, Trigger.newMap);
           	blogicWorkOrderIndia.SetActualApproverEmailOnWO(Trigger.oldMap, Trigger.newMap);
            }
        else if (Trigger.isDelete) {
            blogicWorkOrderIndia.CountCCVWOonAsset(null,Trigger.oldMap);
        }
    }
}