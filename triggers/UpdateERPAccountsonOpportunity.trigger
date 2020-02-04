trigger UpdateERPAccountsonOpportunity on Opportunity (before insert,before update)
{
    /*
    if(trigger.IsInsert || trigger.IsUpdate)
    {

        List<Id> act=new List<Id>();
        String billto;
        String shiptoId;
        String billtoid;
           
            for(Opportunity op:trigger.new){
                if(op.AccountId!=null){
                act.add(op.AccountId);
                }
            }
            
            List<Account> listAccount=[select id,BillTo__c,(Select id,BillTo__c,Address_Type__c from ERP_Accounts__r ) from Account where id in: act];
            
            System.debug('*******'+listAccount);        
        
                for(Account ac:listAccount){
                    for(Opportunity op:trigger.new)
                    {
                        for(ERP_Accounts__c er_acct:ac.ERP_Accounts__r)
                        {
                             if(er_acct.Address_Type__c=='CX')
                               {
                                op.BillTo_ERP_Accounts__c=er_acct.Id;
                                op.ShipTo_ERP_Accounts__c=er_acct.Id;
                               }
                            else if(er_acct.Address_Type__c=='CS')
                            {
                                //System.debug('+++++'+[select id,BillTo__c from Account where id=:op.AccountID]+'*****'+ac.BillTo__c);
                                billto=ac.BillTo__c;
                                shiptoId=er_acct.Id;
                                System.debug('++'+billto);
                                
                            }
                          
                        }
    
                    }
                }
             List<ERP_Accounts__c> billtolist=[select id,Name,Address_Type__c from ERP_Accounts__c where BillTo__c=: billto and Address_type__c=:'CB'];
             if(billtolist != null){
                 for(ERP_Accounts__c er:billtolist){
                     billtoid=er.id;
                 }
            }             
             System.debug('+++++++'+billtolist);
             
             for(Account ac:listAccount){
                 for(Opportunity op:trigger.new){
                     for(ERP_Accounts__c er_acct:ac.ERP_Accounts__r)
                        {             
                            if(er_acct.Address_Type__c=='CS')
                             {
                                  if(billtoid != null && shiptoId != null){
                                      op.BillTo_ERP_Accounts__c=billtoid;
                                      op.ShipTo_ERP_Accounts__c=shiptoId;
                                 }
                             }
                         }    
                     }
                }
    
    }
    */
    
                            /* if(billtoid != null){
                                op.BillTo_ERP_Accounts__c=billtoid.id;
                                op.ShipTo_ERP_Accounts__c=er_acct.Id;
                            }   
                            */
}