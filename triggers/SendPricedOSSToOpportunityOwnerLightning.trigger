trigger SendPricedOSSToOpportunityOwnerLightning on ContentDocumentLink (after insert) {
    
    List<String> listoftoAddress=new List<String>();
    List<String> userId= new List<String>();
    
    Map<Id,ContentDocumentLink> MapId = new Map<Id,ContentDocumentLink>();
    Map<Id,String> mapOppEmail = new Map<Id,String>();    
    for (ContentDocumentLink con : Trigger.New){
        MapId.put(con.Id,con);
    }
    Set <id> pids = new set <id>();
    Set <id> docids = new set <id>();
    for(ContentDocumentLink i : MapId.values()){
        String pid = i.LinkedEntityId;
        if(pid.startsWith('006'))
        {
            pids.add(pid);
            docids.add(i.ContentDocumentId);
        }
        system.debug(pids);
        system.debug(docids);
    }
    
    List<Opportunity> ls_op= [select Id,Owner.Name,Name,Owner.Email,StageName,Owner.UserRole.Name,Owner.Manager.Email from Opportunity where Id In :pids];
	List<ContentVersion> cv=[Select Title,VersionData,Owner.Name from ContentVersion Where ContentDocumentId In :docids];    
    /*
    String group_Name;
    String filename;
   
    for(ContentVersion cv_obj:cv){
        filename=cv_obj.Title;
        System.debug(filename);
    }
    String liketest='%' + StringUtil.getShopOrderNumber(filename)+ '%';
    List<ContentDocumentLink> dulicate_cv=[select id,ShareType,ContentDocument.Title from ContentDocumentLink Where ContentDocument.Title LIKE: liketest and LinkedEntityId in: pids];
    
    System.debug('++++++'+dulicate_cv);
    System.debug('++++++'+dulicate_cv.size());
    
    if(dulicate_cv.size()<=1)
    {
        for(Opportunity op:ls_op){
            String userRole=op.Owner.UserRole.Name;
                if(userRole.contains('India - Injection - Sales Eng')){
                    group_Name='India Domestic New Order Group';
                }
                else if(userRole.equals('India Injection - Export Sales Eng')){
                    group_Name='India Export New Order Group';
                }
        }
        if(group_Name!=null){
            Group gp = [SELECT (SELECT UserOrGroupId FROM GroupMembers) FROM Group WHERE Name =:group_Name ];
                for (GroupMember gm : gp.GroupMembers) {
                    userId.add(gm.UserOrGroupId);
                }
                List<User> userList = [SELECT Email FROM User WHERE Id IN :userId];
                for(User u : userList) {
                    listoftoAddress.add(u.email);
                } 
        
        }
     }
    */
     System.debug(listoftoAddress);
    
    
    for(Opportunity opp:ls_op){
        mapOppEmail.put(opp.Id,opp.Owner.Email);
        String Names = opp.Name;
        String Owners = opp.Owner.Name;
        String Ids = opp.Id;
        
            
            listoftoAddress.add(mapOppEmail.get(opp.Id));
            listoftoaddress.add(opp.Owner.Manager.Email);
            
            System.debug('++'+listoftoAddress);
        
        
        for(ContentVersion Doc : cv ){
            
            System.debug('Doc1:' + Doc.Title);
            if(Doc.Title.contains('OP') || Doc.Title.contains('CP')){
                System.debug('Doc2:' + Doc.Title);
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName(Doc.Title + '.pdf');
                efa.setBody(Doc.VersionData);
                
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.Subject = 'Priced OSS attached on opportunity ' + opp.Name;
                //email.toAddresses = new String[] { mapOppEmail.get(opp.Id),opp.Owner.Manager.Email };//mapOppEmail.get(opp.Id)}; 
                email.setToAddresses(listoftoaddress);   
                  
                String line1 = 'Dear '+opp.Owner.Name+',';
                String line2 =  'This is to inform you that your quote has been submitted in E1. Attached is the Priced OSS for your ready reference.';
                String line3 = 'To view the details of an Opportunity or Quote, please click on below link.';
                String line4 = URL.getSalesforceBaseUrl().toExternalForm()+'/'+opp.Id;
                string line5 = 'Regards,';
                String body = line1 + '\r\n'+'\r\n' + line2 +'\r\n'+ '\r\n' + line3+ '\n\n' + line4+ '\r\n'+ '\r\n'+line5; 
                
                email.plainTextBody = body;          
                email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
                system.debug('Email Send'+body);
                Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {email};
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                
                if(Doc.Title.contains('OP') && opp.StageName != 'Closed-Won' && Doc.Owner.Name == 'Big Machines XPI_API_user' && opp.Owner.UserRole.Name.contains('India'))
                {
                    opp.StageName = 'Closed-Won';
                    update opp;
                }
            }  
        }
    }
}