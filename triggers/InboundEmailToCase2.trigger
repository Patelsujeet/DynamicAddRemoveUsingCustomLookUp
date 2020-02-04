trigger InboundEmailToCase2 on EmailMessage (before insert) {  
    Case[] existingCases = new Case[0];
    Case matchingCase;
    Boolean isExistingCase = false;
    Boolean isGroupAvailable = true;
    List<Case> allMatchingCases = new List<Case>();
    Map<Id, Group> mapGrp = new Map<Id,Group>();
  
    for(EmailMessage em: Trigger.New){ 
                // get the queue groups
                 Group[] grpl = [SELECT Id, Name 
                        FROM Group 
                        WHERE Type = 'Queue' 
                        AND Name IN('Parts - International')];
                
               if(grpl!=null && grpl.size()>0){
                    mapGrp.putall(grpl); 
                   isGroupAvailable = true;
                }

                //Split recipient email ids
                List<String> emailids = new List<String>(); 
                String toAddr = em.ToAddress;
                String ccAddr = em.CcAddress;
                String BccAddr = em.BccAddress;
        
                if(toAddr != null){
                    emailids = toAddr.split(';');
                }
                if(ccAddr != null){
                    emailids.addAll(ccAddr.split(';'));
                }
                if(BccAddr != null){
                    emailids.addAll(BccAddr.split(';'));
                }
        
      if(emailids.contains('generalpartstest@gmail.com') && em.Subject != null && isGroupAvailable)
      {
            if(em.Subject.containsIgnoreCase('RE:') || em.Subject.containsIgnoreCase('FWD:') || em.Subject.containsIgnoreCase('FW:')){
                system.debug('made it here');
                // Split subject by space and trim to get the actual subject
                String emailSubject = em.Subject;
                String[] subjectPhrases = emailSubject.split ( ' ' );
                String subjectActual = em.Subject ;
                
                string formattedExternal = '[';
                formattedExternal = formattedExternal+'EXTERNAL';
                formattedExternal = formattedExternal+']';
                
                for(Integer i=0; i<subjectPhrases.size(); i++){
                    if(subjectPhrases[i] == 'RE:' || subjectPhrases[i] == 'Re:' || subjectPhrases[i] == formattedExternal || subjectPhrases[i] == 'FWD:' || subjectPhrases[i] == 'Fwd:' || subjectPhrases[i] == 'FW:'){
                        subjectActual = subjectActual.replace(subjectPhrases[i],'');
                    }
                }
                subjectActual = subjectActual.trim();
                subjectActual = '%'+subjectActual+'%';
                
                String fromAddr = em.FromAddress;
                if(fromAddr != null){
                    emailids.add(fromAddr);
                }                
                
                try{
                    string RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Customer_Service').getRecordTypeId();                    
                    existingCases = [Select Id, CaseNumber, Subject, Owner_Profile_Name__c, CreatedDate, SuppliedEmail, Status, Description
                                     FROM Case 
                                     WHERE RecordTypeId = :RecordTypeId AND Subject LIKE :subjectActual];                    
                    System.debug(existingCases);
                    if(existingCases != null && existingCases.size() > 1){
                        for(Case ec: existingCases){
                            if(ec != null){
                                // Check if web email matches the recipients
                                if (ec.SuppliedEmail != null){
                                    for(String e: emailids){
                                        if(e == ec.SuppliedEmail){
                                            isExistingCase = true;
                                        }
                                    }
                                }
                                
                                // Check if Owner name matches the email sender
                                if(em.FromName != null){
                                    if(ec.Owner_Profile_Name__c == em.FromName && isExistingCase){
                                        isExistingCase = true;
                                    }
                                }
                                
                                if(em.MessageDate != null){
                                    if(ec.CreatedDate >= em.MessageDate.AddDays(-7) && isExistingCase ){
                                        isExistingCase = true;
                                    }
                                }
                                
                                if(em.TextBody != null){    
                                    if(em.TextBody.Contains('internationalparts@servtek.com') && isExistingCase){
                                        isExistingCase = true;
                                    }
                                    if(em.TextBody.Contains(ec.Description) && isExistingCase){
                                        isExistingCase = true;
                                    }
                                }
                                                                                      
                                if(ec.Subject.containsIgnoreCase('Duplicate Case') && isExistingCase){
                                     isExistingCase = false;
                                }
                                
                                if(ec.Status == 'Closed - Issue Resolved' && !isExistingCase){
                                    isExistingCase = true;
                                }
                                
                                if(isExistingCase){
                                    allMatchingCases.add(ec);
                                }  
                            }
                        }
                        System.debug(allMatchingCases);
                        // If more than one matching case found identify the first email by Created Date
                        DateTime oldestCreatedDate = DateTime.now();
                        if(allMatchingCases != null && allMatchingCases.size() > 0)
                        {
                            for(Case mc: allMatchingCases){
                                if(mc.CreatedDate < oldestCreatedDate){
                                    oldestCreatedDate = mc.CreatedDate;
                                    matchingCase = mc;
                                }
                            }
                        }
                    }
                    else if(existingCases != null && existingCases.size() == 1)
                    {           
                        // Check if web email matches the recipients/sender
                        if (existingCases[0].SuppliedEmail != null){
                            for(String e: emailids){
                                if(e == existingCases[0].SuppliedEmail){
                                    isExistingCase = true;
                                    update existingCases[0];
                                }
                            }
                        }
                        
                        if(em.TextBody.Contains(existingCases[0].Description)){
                            isExistingCase = false;
                        }
                        
                        if(existingCases[0].Subject.containsIgnoreCase('Duplicate Case') && isExistingCase){
                             isExistingCase = false;
                        }
                        
                        if(isExistingCase){
                            matchingCase = existingCases[0];
                        }
                    }
                }
                catch(System.NullPointerException ex){
                    System.debug(ex); 
                }
                // Update email parentId to the existing case
                if(matchingCase != null){
                    
                    // To avoid recursive insert check Boolean variable in the Apex class (apex class to clone the received email and it to existing Case)
                    if(CloneEmailMessage.isInsert){
                        CloneEmailMessage.isInsert = false;
                        List<EmailMessage> existingemail = Trigger.New;
                        CloneEmailMessage.CopyEmailMessage(existingemail, matchingCase.Id);
                    }
                } 
                
            }
        }
    }
}