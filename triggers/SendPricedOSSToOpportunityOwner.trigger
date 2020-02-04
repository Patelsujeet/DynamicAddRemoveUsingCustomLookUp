trigger SendPricedOSSToOpportunityOwner on Attachment (after insert) {
    
    System.debug('++');
    
    List<String> listoftoAddress=new List<String>();
    List<String> userId= new List<String>();
    
    
    Map<Id,Attachment> mapAttIdToAtt = new Map<Id,Attachment>();
    Map<Id,String> mapOppEmail = new Map<Id,String>();
    set<Id> setOppIds  =  new set<Id>();
    List<Messaging.EmailFileAttachment> mailsLst = new List<Messaging.EmailFileAttachment>();
    string whatid = '';
    string attachmentName='';
    for(Attachment att: [Select Id,Name,ParentId,Owner.Name,body From Attachment Where Id = : Trigger.newMap.keyset()]){
        whatid = string.valueof(att.ParentId);
        
        if((att.Name.contains('OP') || att.Name.contains('CP')) && whatid.startswith('006')){
           attachmentName=att.Name;
            mapAttIdToAtt.put(att.Id,att);
            setOppIds.add(att.ParentId);            
        }
    }        
    if(setOppIds.size()>0){
        //String Names = '';
        //String Owners = '';
        //string Ids = '';
         
         
            List<Opportunity> ls_op= [select Id,Owner.Name,Name,Owner.Email,StageName,Owner.UserRole.Name,Owner.Manager.Email from Opportunity where Id In :setOppIds];
        /*  
        String group_Name;   
            String liketest='%' + StringUtil.getShopOrderNumber(attachmentName)+ '%';
            List<Attachment> dulicate_attachment=[Select Id,ParentID,Name from Attachment Where ParentID=:whatid and Name LIKE : liketest];
            
            System.debug(dulicate_attachment);
            System.debug(dulicate_attachment.size());
            
            if(dulicate_attachment.size()<=1){
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
            }*/
        
            
       
       
        for(Opportunity opp:ls_op ){
            mapOppEmail.put(opp.Id,opp.Owner.Email);
            
            // Names = opp.Name;
            //Owners = opp.Owner.Name;
            //Ids = opp.Id;
            
            
            listoftoAddress.add(mapOppEmail.get(opp.Id));
            listoftoaddress.add(opp.Owner.Manager.Email);
            
            System.debug('++++++++++'+listoftoAddress);
            //for(Id k: mapAttIdToAtt.get(key){
            for(Attachment att: mapAttIdToAtt.values()){
                // Attachment att = mapAttIdToAtt.get(k);
                // Create the email attachment
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName(att.Name);
                efa.setBody(att.body);
                
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.Subject = 'Priced OSS attached on opportunity ' + opp.Name;
               // email.toAddresses = new String[] { mapOppEmail.get(whatid)};    //Changed By me 
               email.setToAddresses(listoftoaddress); 
               
                    String line1 = 'Dear '+opp.Owner.Name+',';
                String line2 =  'This is to inform you that your quote has been submitted in E1. Attached is the Priced OSS for your ready reference.';
                String line3 = 'To view the details of an Opportunity or Quote, please click on below link.';
                String line4 = URL.getSalesforceBaseUrl().toExternalForm()+'/'+opp.Id;
                string line5 = 'Regards,';
                String body = line1 + '\r\n'+'\r\n' + line2 +'\r\n'+ '\r\n' + line3+ '\n\n'  + line4+ '\r\n'+ '\r\n'+line5; 
                
                email.plainTextBody = body;          
                email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
                Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {email};
                   Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                if(att.Name.contains('OP') && opp.StageName != 'Closed-Won' && att.Owner.Name == 'Big Machines XPI_API_user' && opp.Owner.UserRole.Name.contains('India'))
                {
                    opp.StageName = 'Closed-Won';
                    update opp;
                }
                
            }
        }
        
        
    }
    
}