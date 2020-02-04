trigger AssignOwnerToVisit on Visit__c (after insert, after update) {
for(Visit__c Vst : Trigger.new){
Vst = [SELECT Id, Milacron_Ahmedabad_Participants_Email__c, Status__c, Reminder_for_India__c, Visitors_Titles__c, Estimated_Time_of_Arrival__c, Training_Team__c, SPE_Team__c,
       Application_Head__c, Design_Team__c, Managing_Director__c, Sales_VP__c, Finance_VP__c, Manufacturing_Team__c, Supply_Chain_Team__c, Extrusion_Team__c, Blow_Molding_Team__c FROM Visit__c WHERE Id = :Vst.Id];
List<User> U = [select Id, Username,Email, Profile.Name, FSL_Approver__c, Address_Source_Company__c FROM User Where (Id=:userinfo.getuserId() AND Address_Source_Company__c ='300 - Ferromatik India')];
if(U.size() > 0)
{
if(trigger.isinsert){
//Group queue = [SELECT Id FROM Group WHERE Name = 'Customer Visit to Ahmedabad' and Type='Queue']; //Assign owner to India Visit
//Vst.OwnerId = queue.Id;
Vst.Status__c = 'Open';
Update Vst;
//initiallize messaging method
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
EmailTemplate et = [select id, HtmlValue, Body, Subject from EmailTemplate where DeveloperName =:'Assign_Owner_to_India_Visit_VF'];
Contact cnt1 = [select id, Email from Contact where Name = 'Jaymin Patel'];
mail.setTemplateId(et.Id);
mail.setTargetObjectId(cnt1.id);
mail.setTreatTargetObjectAsRecipient(False);
mail.saveAsActivity = True;
String mailadd = Vst.Milacron_Ahmedabad_Participants_Email__c;
//    if(mailadd.startsWith(',')){ //Remove , if startswith ,
//      String SelValue = ',';
//      mailadd = mailadd.replaceFirst(SelValue, '');
//     }
String[] toAddresses = mailadd.trim().split(',');
mail.setToAddresses(toAddresses);
//mail.setCcAddresses(new String[]{'Jaymin_patel@milacron.com','Nishant_Gandhi@Milacron.com'});
mail.setWhatId(Vst.Id);    
Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
}
if(trigger.isupdate){
Visit__c oldVst = Trigger.oldMap.get(Vst.Id);    
if(Vst.Status__c == 'Canceled' && oldVst.Status__c != 'Canceled'){
//initiallize messaging method
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
EmailTemplate et = [select id, HtmlValue, Body, Subject from EmailTemplate where DeveloperName =:'Canceled_Visit_India_VF'];
Contact cnt1 = [select id, Email from Contact where Name = 'Jaymin Patel'];
mail.setTemplateId(et.Id);
mail.setTargetObjectId(cnt1.id);
mail.setTreatTargetObjectAsRecipient(False);
mail.saveAsActivity = True;
String mailadd = Vst.Milacron_Ahmedabad_Participants_Email__c;
//    if(mailadd.startsWith(',')){ //Remove , if startswith ,
//      String SelValue = ',';
//      mailadd = mailadd.replaceFirst(SelValue, '');
//      }
String[] toAddresses = mailadd.trim().split(',');
mail.setToAddresses(toAddresses);
//mail.setCcAddresses(new String[]{'Jaymin_patel@milacron.com','Nishant_Gandhi@Milacron.com'});
mail.setWhatId(Vst.Id);    
Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
}
}
if(trigger.isupdate){
Visit__c oldVst = Trigger.oldMap.get(Vst.Id);    
if(Vst.Status__c == 'Open' && ((Vst.Visitors_Titles__c != oldVst.Visitors_Titles__c) || (Vst.Estimated_Time_of_Arrival__c != oldVst.Estimated_Time_of_Arrival__c) || (Vst.Training_Team__c == True && oldVst.Training_Team__c == False) ||
  (Vst.SPE_Team__c == True && oldVst.SPE_Team__c == False) || (Vst.Application_Head__c == True && oldVst.Application_Head__c == False) || (Vst.Design_Team__c == True && oldVst.Design_Team__c == False) || (Vst.Managing_Director__c == True && oldVst.Managing_Director__c == False) ||
  (Vst.Sales_VP__c == True && oldVst.Sales_VP__c == False) || (Vst.Finance_VP__c == True && oldVst.Finance_VP__c == False) || (Vst.Manufacturing_Team__c == True && oldVst.Manufacturing_Team__c == False) || (Vst.Supply_Chain_Team__c == True && oldVst.Supply_Chain_Team__c == False) ||
  (Vst.Extrusion_Team__c == True && oldVst.Extrusion_Team__c == False) || (Vst.Blow_Molding_Team__c == True && oldVst.Blow_Molding_Team__c == False))){
//initiallize messaging method
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
EmailTemplate et = [select id, HtmlValue, Body, Subject from EmailTemplate where DeveloperName =:'Notification_to_India_Visit_Owner_VF'];
Contact cnt1 = [select id, Email from Contact where Name = 'Jaymin Patel'];
mail.setTemplateId(et.Id);
mail.setTargetObjectId(cnt1.id);
mail.setTreatTargetObjectAsRecipient(False);
mail.saveAsActivity = True;
String mailadd = Vst.Milacron_Ahmedabad_Participants_Email__c;
//    if(mailadd.startsWith(',')){ //Remove , if startswith ,
//      String SelValue = ',';
//      mailadd = mailadd.replaceFirst(SelValue, '');
//      }
String[] toAddresses = mailadd.trim().split(',');
mail.setToAddresses(toAddresses);
//mail.setCcAddresses(new String[]{'Jaymin_patel@milacron.com','Nishant_Gandhi@Milacron.com'});
mail.setWhatId(Vst.Id);    
Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
}
}
if(trigger.isupdate){
Visit__c oldVst = Trigger.oldMap.get(Vst.Id);    
if(Vst.Reminder_for_India__c == True && oldVst.Reminder_for_India__c == False){
//initiallize messaging method
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
EmailTemplate et = [select id, HtmlValue, Body, Subject from EmailTemplate where DeveloperName =:'Reminder_for_India_Visit_VF'];
Contact cnt1 = [select id, Email from Contact where Name = 'Jaymin Patel'];
mail.setTemplateId(et.Id);
mail.setTargetObjectId(cnt1.id);
mail.setTreatTargetObjectAsRecipient(False);
mail.saveAsActivity = True;
String mailadd = Vst.Milacron_Ahmedabad_Participants_Email__c;
//    if(mailadd.startsWith(',')){ //Remove , if startswith ,
//      String SelValue = ',';
//      mailadd = mailadd.replaceFirst(SelValue, '');
//      }
String[] toAddresses = mailadd.trim().split(',');
mail.setToAddresses(toAddresses);
//mail.setCcAddresses(new String[]{'Jaymin_patel@milacron.com','Nishant_Gandhi@Milacron.com'});
mail.setWhatId(Vst.Id);    
Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
Vst.Reminder_for_India__c = False;
Update Vst;
}
}    
}
}
}