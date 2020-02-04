trigger AccountClassification on Account (before update,after update) {
List<Account> acNew=trigger.new;
List<Account> acOld=trigger.old;
AccountTrigger ac=new AccountTrigger();
List<Account> ls=new List<Account>();

if(trigger.isbefore){
    System.debug('BEFORE Trigger');
    ac.accountSubmission(acNew,acOld,Trigger.oldMap);        

        ac.accountRejection(acNew,acOld,Trigger.oldMap);
            
        /*if(ac_Obj.Status__c=='Submit'){
            if(ac_Obj.Business_Unit__c!=Trigger.oldMap.get(ac_Obj.Id).Business_Unit__c && ac_Obj.RecordTypeId=='012E0000000J1kN'){
                ac_obj.Previous_Value__c=Trigger.oldMap.get(ac_Obj.Id).Business_Unit__c;
                ac.submitForApproval(ac_Obj);
            }    
        }*/
         
        /*else if(ac_Obj.Change_Business_Classification__c==false && ac_Obj.Status__c=='Reject'){
            ac_obj.Business_Unit__c=ac_obj.Previous_Value__c;
        }*/
        
    
}
if(trigger.isafter){


}


}