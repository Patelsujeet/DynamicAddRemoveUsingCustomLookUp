trigger SendInstallationReportToOperationTeam on ContentVersion (after insert) {
for(ContentVersion CV : Trigger.new)
{
Injection_Moulding_Machine_Installation__c   ISR = [SELECT id, Name, Shop_Order_Number__c FROM Injection_Moulding_Machine_Installation__c WHERE Id = :CV.FirstPublishLocationId];
if(ISR.Installation_Report_Attached__c = True)
{
OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'service_support@milacron.com'];
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
EmailTemplate et = [select id, HtmlValue, Body, Subject from EmailTemplate where DeveloperName =:'Installation_Service_Report_for_Operation_Team'];
Contact cnt1 = [select id, Email from Contact where Name = 'Jaymin Patel'];
mail.setTemplateId(et.Id);
mail.setTargetObjectId(cnt1.id);
mail.setTreatTargetObjectAsRecipient(true);
mail.saveAsActivity = True;
mail.setOrgWideEmailAddressId(owea.get(0).Id);
mail.setToAddresses(new String[]{'Nikhil_B_Yagnik@milacron.com','Hemal_N_Bhavsar@milacron.com'}); 
mail.setCcAddresses(new String[]{'Jaymin_Patel@milacron.com','Bhargav_D_Patel@milacron.com'}); 
mail.setWhatId(ISR.Id);

List<Messaging.Emailfileattachment> Contentversion = new List<Messaging.Emailfileattachment>();
//for (ContentVersion a : [select Id, Title, VersionData, PathonClient from ContentVersion where FirstPublishLocationId = :ISR.Id])
//{
   // Add attachment in Mail 
   Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
   efa.setFileName(CV.Title+'.pdf');
   efa.setBody(CV.VersionData);
   Contentversion.add(efa);
//}
mail.setFileAttachments(Contentversion);
Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
}
}
}