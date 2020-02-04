trigger SendEmailOnRFQAttachmentOnCase on ContentVersion (After insert) {
     Set <id> CsIds = new set <id>();
    for (ContentVersion con : Trigger.New){
        
        String Pid = con.FirstPublishLocationId;
        if(Pid != null && Pid.startsWith('500') ){
            CsIds.add(con.FirstPublishLocationId);
        }
    }
    for(Case CS: [select Id,Owner.Name,CaseNumber,Owner.Email,Request_Type__c,Status from Case where Id In :CsIds]){
        System.debug('Email:'+CS.Owner.Email);
        for(ContentVersion Doc : [Select Title,VersionData,OwnerId,CreatedBy.Name,FirstPublishLocationId,PathOnClient from ContentVersion Where FirstPublishLocationId In :CsIds Order By  CreatedDate DESC Limit 1]){
            if(CS.id == Doc.FirstPublishLocationId){
                if(CS.Request_Type__c == 'RFQ' && CS.Status != 'Closed'){
                System.debug('Doc2:' + Doc.Title);
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName(Doc.PathOnClient);
                efa.setBody(Doc.VersionData);
                
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.Subject = 'RFQ on CaseNumber '+CS.CaseNumber + ' has been attached';
                email.toAddresses = new String[] { CS.Owner.Email };
                    String line1 = 'Dear '+CS.Owner.Name+',';
                String line2 =  'The RFQ has been attached on Case Number '+CS.CaseNumber + ' by ' + Doc.CreatedBy.Name+'.';
                String line3 = 'To review the RFQ Case details, please click on following link. ';
                String line4 = URL.getSalesforceBaseUrl().toExternalForm()+'/'+CS.Id;
                string line5 = 'Regards,';
                String body = line1 + '\r\n'+'\r\n' + line2 +'\r\n'+ '\r\n' + line3+'\r\n'+ '\r\n' + line4+ '\r\n'+ '\r\n'+line5; 
                
                email.plainTextBody = body;          
                email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
                system.debug('Email Send'+body);
                Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {email};
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                
                
            	}  
            }
        }
    }
}