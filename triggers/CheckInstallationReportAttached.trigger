trigger CheckInstallationReportAttached on ContentVersion (after insert, before delete) {
if(trigger.isinsert){
List<Injection_Moulding_Machine_Installation__c> co = [select id from Injection_Moulding_Machine_Installation__c where id =:Trigger.New[0].FirstPublishLocationId];
If(co.size()>0)        
{            
co[0].Installation_Report_Attached__c = True;            
update co;        
}
}
}