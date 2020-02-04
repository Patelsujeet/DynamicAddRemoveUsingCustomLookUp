trigger CheckEmailOnCase on Case (after insert) {
    Boolean matchingCaseFound = false;
    List<Case> finalMatchingCases = new List<Case>();
    Case matchingCase;
    Case repCase;
    Boolean bQueueIncluded = false;
    Map<Id, Group> mapGrp = new Map<Id,Group>();
    
    for(Case c: Trigger.New)
    { 
      Id CSRecordId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Customer_Service').getRecordTypeId();
        try{       
            Group[] grpl = [SELECT Id, Name 
                    FROM Group 
                    WHERE Type = 'Queue' 
                    AND Name IN('Parts - International','Parts - General','Parts - Repair')];
            
           if(grpl!=null && grpl.size()>0){
                mapGrp.putAll(grpl); 
                bQueueIncluded = mapGrp.containsKey(c.First_Queue__c);
            }
            
            if(bQueueIncluded  && c.Subject != null){  
                if(c.Subject.containsIgnoreCase('RE:') || c.Subject.containsIgnoreCase('FWD:') || c.Subject.containsIgnoreCase('FW:')){                                                                                                        
                    Case[] matchingCases = new Case[0];
                    
                    // Split subject by space and trim to get the actual subject
                    String subject = c.Subject;
                    String[] subjectPhrases = subject.split ( ' ' );
                    String subjectActual = c.Subject;

                    string formattedExternal = '[';
                    formattedExternal = formattedExternal+'EXTERNAL';
                    formattedExternal = formattedExternal+']';
                    
                    string formattedExt = '[';
                    formattedExt = formattedExt+'EXT';
                    formattedExt = formattedExt+']';
                    
                    for(Integer i=0; i<subjectPhrases.size(); i++){
                        if(subjectPhrases[i] == 'RE:' || subjectPhrases[i] == 'Re:' || subjectPhrases[i] == formattedExternal || subjectPhrases[i] == formattedExt || subjectPhrases[i] == 'FWD:' || subjectPhrases[i] == 'Fwd:' || subjectPhrases[i] == 'FW:'){
                            subjectActual = subjectActual.replace(subjectPhrases[i],'');
                        }
                    }
                // continue furthur only if actual subject is not blank    
               if(!string.isBlank(subjectActual))
               {
                    subjectActual = subjectActual.trim();
                    subjectActual = '%'+subjectActual+'%';

                    matchingCases = [Select Id, CaseNumber, Subject, RecordTypeId, CreatedDate, OwnerId, Status, SuppliedEmail from Case where Subject LIKE :subjectActual  AND RecordTypeId = :CSRecordId AND First_Queue__c IN :mapGrp.keyset() AND Id != :Trigger.New LIMIT 1000];
                    System.debug('matching cases ' + matchingCases);
                    if(matchingCases != null && matchingCases.size() > 0){   
                        for(Case mc: matchingCases){
                            if(mc.RecordTypeId == CSRecordId &&  mc.Status != 'Closed - Issue Resolved' && mc.CreatedDate >= c.CreatedDate.AddDays(-7) && mc.SuppliedEmail == c.SuppliedEmail){
                                finalMatchingCases.add(mc);
                            }
                        }

                        // If more than one matching case found identify the first email by Created Date
                        DateTime oldestCreatedDate = DateTime.now();
                        if(finalMatchingCases != null && finalMatchingCases.size() > 1)
                        {
                            for(Case amc: finalMatchingCases){
                                if(amc.CreatedDate < oldestCreatedDate){
                                    oldestCreatedDate = amc.CreatedDate;
                                    matchingCase = amc;
                                    matchingCaseFound = true;
                                }
                            }
                        }
                        else if(finalMatchingCases != null && finalMatchingCases.size() == 1){
                            matchingCase = finalMatchingCases[0];
                            matchingCaseFound = true;
                        }
                        
                        if(matchingCaseFound){
                            // replicate existing Case
                            repCase = [Select Id, Subject from Case where id in :Trigger.New];
                            string casesubject = repCase.Subject;
                            repCase.Subject = 'Duplicate Case '+ casesubject;
                            
                            Contact[] contact = [SELECT ID, Name, AccountId, Account.Id, Account.Name, Account.Soldto__c
                                                 FROM CONTACT
                                                 WHERE Account.Name = 'Milacron LLC'
                                                 AND Account.Soldto__c = '359583'
                                                 AND Name = 'No Reply'];  
                            repCase.AccountId = contact[0].AccountId;
                            repCase.ContactId = contact[0].ID;
                            repCase.Contact_Category__c = 'Duplicate E-mail';
                            repCase.AssetId = null;
                            repCase.No_Asset_Reason__c = 'Customer Did Not Provide';
                            repCase.Is_Machine_Down__c = 'No';
                            repCase.PO_Received__c = 'No';
                            repCase.Quote_Number__c = '';                
                            repCase.Asset_Serial_Number__c='';
                            repCase.Status = 'Closed - Issue Resolved';                         
                            User uAssign = [SELECT Id, Name, username FROM User Where username LIKE 'csl_integration@milacron.com%' ORDER BY username LIMIT 1]; 
                            repCase.OwnerId = uAssign.Id;
                            repCase.ParentId = matchingCase.Id;                            
                            
                            update repcase;
                        }
                    }     
                }
            }
          }
        }
        catch(System.NullPointerException ex){
            System.debug(ex); 
        }
    }
}