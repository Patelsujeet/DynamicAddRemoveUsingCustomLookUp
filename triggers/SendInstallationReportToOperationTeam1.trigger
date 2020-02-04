trigger SendInstallationReportToOperationTeam1 on Injection_Moulding_Machine_Installation__c (after update) {
    for(Injection_Moulding_Machine_Installation__c ISR : Trigger.new){
        Injection_Moulding_Machine_Installation__c oldISR = trigger.oldMap.get(ISR.Id);
        ISR = [SELECT Id, Name, Shop_Order_Number__c, Installation_Report_Attached__c, P_P_Status__c, Work_Orders__r.Id, Work_Orders__r.WorkOrderNumber FROM Injection_Moulding_Machine_Installation__c WHERE Id = :ISR.Id]; 
        if(ISR.Installation_Report_Attached__c == True && oldISR.Installation_Report_Attached__c == False)
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            EmailTemplate et = [select id, HtmlValue, Body, Subject from EmailTemplate where DeveloperName =:'Installation_Service_Report_for_Operation_Team'];
            User U = [select Id, Username,Email, Profile.Name, FSL_Approver__c FROM User Where Id=:userinfo.getuserId()];
            Contact cnt1 = [select id, Email from Contact where Name = 'Jaymin Patel'];
            mail.setTemplateId(et.Id);
            mail.setTargetObjectId(cnt1.id);
            mail.setTreatTargetObjectAsRecipient(False);
            mail.saveAsActivity = True;
            if(ISR.P_P_Status__c == 'Plug & Produce'){
                mail.setToAddresses(new String[] {'Shreyas_Raval@milacron.com','Niket_B_Bhavsar@milacron.com','Nikhil_B_Yagnik@milacron.com','Shailesh_K_Prajapati@milacron.com','Dhruvesh_K_Mistry@milacron.com','Debananda_Dash@milacron.com',
                    'Yogendra_B_Patel@milacron.com','Mehul_V_Mokani@milacron.com','Nikul_H_Bhatt@milacron.com','Hemant_D_Paliwal@milacron.com'});
            }
            else{
                mail.setToAddresses(new String[] {'Shreyas_Raval@milacron.com','Niket_B_Bhavsar@milacron.com','Nikhil_B_Yagnik@milacron.com','Hemal_N_Bhavsar@milacron.com','Shailesh_K_Prajapati@milacron.com','Dhruvesh_K_Mistry@milacron.com','Debananda_Dash@milacron.com',
                    'Yogendra_B_Patel@milacron.com','Mehul_V_Mokani@milacron.com','Nikul_H_Bhatt@milacron.com','Hemant_D_Paliwal@milacron.com'});
            }
            if(U.Profile.Name == 'FSL India Manager' || U.Profile.Name == 'System Administrator'){
                mail.setCcAddresses(new String[]{U.Email,'Sachin_Shah@milacron.com','Bhargav_D_Patel@milacron.com'}); 
            }
            else{
                mail.setCcAddresses(new String[]{U.FSL_Approver__c,U.Email,'Sachin_Shah@milacron.com','Bhargav_D_Patel@milacron.com'});
            }
            mail.setWhatId(ISR.Id); //Id of object that should do field merge in email template
            List<Messaging.Emailfileattachment> Contentversion = new List<Messaging.Emailfileattachment>();
            ContentVersion CV = [Select Id,title, Pathonclient, LastModifiedDate, VersionData From ContentVersion Where Title = :ISR.Shop_Order_Number__c+'-Machine Installation Report' Order by LastModifiedDate DESC limit 1];
            // Add attachment in Mail    
            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
            efa.setFileName(CV.Title+'.pdf');
            efa.setBody(CV.VersionData);
            Contentversion.add(efa);
            list<ContentDocumentLink> cdl = [Select ContentDocumentId, ContentDocument.title, ContentDocument.FileType, ContentDocument.FileExtension From ContentDocumentLink Where 
                                             ((LinkedEntityId = :ISR.Work_Orders__r.Id OR LinkedEntityId = :ISR.Id) AND (NOT(ContentDocument.title like :ISR.Work_Orders__r.WorkOrderNumber+'%' AND ContentDocument.FileType like 'PDF')) AND 
                                              (NOT(ContentDocument.title like :ISR.Shop_Order_Number__c+'%' AND ContentDocument.FileType like 'PDF')) AND (NOT(ContentDocument.title like 'SA%' AND ContentDocument.FileType like 'PDF')))];
            for(integer i=0;i<cdl.size();i++){
                list<ContentVersion> CV1 = [Select Id, title, Pathonclient, FileType, FileExtension, VersionData From ContentVersion Where ContentDocumentId =:cdl[i].ContentDocumentId];   
                for(ContentVersion cd : CV1){ 
                    Messaging.Emailfileattachment efa1 = new Messaging.Emailfileattachment();
                    efa1.setFileName(cd.title+'.'+cd.FileExtension);
                    efa1.setBody(cd.VersionData);
                    Contentversion.add(efa1);         
                }
            }
            mail.setFileAttachments(Contentversion);
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
        }
    }
}