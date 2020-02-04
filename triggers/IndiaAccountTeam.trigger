trigger IndiaAccountTeam on Account (after update){
    
    List<Account> Accounts = [select Id, Business_Unit_Code__c, Service_Region__c from Account where Business_Unit_Code__c = '300' and Service_Region__c != Null and Service_Region__c != 'CSD-Export' Order by LastModifiedDate DESC Limit 1];
    if(Accounts.size()>0){
        ServiceTerritory ST = [Select Id,Name,FSL_Approver__r.Id, Service_Region__c, IsActive From ServiceTerritory Where IsActive = True and Service_Region__c != Null and Service_Region__c != 'CSD-Export' and Service_Region__c = :Accounts.get(0).Service_Region__c];
        List<AccountTeamMember> accountTeamList = new List<AccountTeamMember>(); // list of AccountTeamMembers to insert
        List<AccountTeamMember> accountTeamList1 = new List<AccountTeamMember>(); // list of AccountTeamMembers to delete
        List<AccountShare> acctShareList = new List<AccountShare>();  
        for(Account acct : Accounts){
            Account oldAcc = trigger.oldMap.get(acct.Id);
            if(acct.Business_Unit_Code__c == '300' && acct.Service_Region__c != null){     
                AccountTeamMember acctTM = new AccountTeamMember();
                AccountShare acctShare = new AccountShare(); 
                
                acctTM.AccountId = acct.Id; 
                acctTM.UserId = ST.FSL_Approver__r.Id ; 
                acctTM.TeamMemberRole = 'Service Manager';
                accountTeamList.add(acctTM);
                
                acctShare.AccountId = acct.Id;
                acctShare.UserOrGroupId = ST.FSL_Approver__r.Id; 
                acctShare.ContactAccessLevel = 'Read';
                acctShare.OpportunityAccessLevel = 'Read';
                acctShare.AccountAccessLevel = 'Read';
                acctShare.CaseAccessLevel = 'Read';               
                acctShareList.add(acctShare);
                
            }
            if(!accountTeamList.isEmpty()){
                insert acctShareList;
                insert accountTeamList;
            }
            if(oldAcc != Null && oldAcc.Service_Region__c != 'CSD-Export'){
                ServiceTerritory ST1 = [Select Id,Name,FSL_Approver__r.Id, Service_Region__c, IsActive From ServiceTerritory Where Service_Region__c = :oldAcc.Service_Region__c Limit 1]; 
                if(acct.Business_Unit_Code__c == '300' && (oldAcc.Service_Region__c != acct.Service_Region__c)){
                    for(AccountTeamMember Ratm : [SELECT Id, UserId, AccountId FROM AccountTeamMember WHERE TeamMemberRole='Service Manager' AND AccountId =:acct.id AND UserId =:ST1.FSL_Approver__r.Id]){
                        accountTeamList1.add(Ratm);
                    } 
                    delete accountTeamList1;
                    
                }                              
            }
        }
    }
}