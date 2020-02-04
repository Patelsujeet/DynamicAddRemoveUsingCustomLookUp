trigger AI_AU_ServiceTerritoryMember on ServiceTerritoryMember (after insert,after update)
{    
/*
    List<ServiceTerritoryMember> list_srtm=new List<ServiceTerritoryMember>();
        
    for(ServiceTerritoryMember srt:trigger.new){
        list_srtm.add(srt);
      }

    if(trigger.isUpdate){
        TimeSheetManagement.timeSheetDeletion(list_srtm,trigger.oldmap);
    }

    if(trigger.isInsert)
    {
        TimeSheetManagement.serviceTerritoryMemberTimeSheetCreation(list_srtm);
    }
this comment for deployment
*/






    /*
    DateTime enddate;
    List<TimeSheet> del=new List<TimeSheet>();
    List<ServiceTerritoryMember> st=new List<ServiceTerritoryMember>();
    List<Id> stId=new List<Id>();

    if(trigger.isUpdate){
    
    
        for(ServiceTerritoryMember srtm:trigger.new){
            if(srtm.EffectiveEndDate != trigger.oldmap.get(srtm.id).EffectiveEndDate){
                enddate=srtm.EffectiveEndDate;
                st.add(srtm);
                stId.add(srtm.ServiceResourceId);
            }                
        }
        System.debug('EndDate'+enddate);
        
        List<ServiceResource> sr=[select id,Name,(select id,EndDate,StartDate from TimeSheets) from ServiceResource where id in: stId];
        for(ServiceResource sr_obj:sr){
            for(TimeSheet t:sr_obj.TimeSheets){
                if(enddate<t.StartDate){
                    del.add(t);
                }
            }
        }
        
        for(TimeSheet t:del){
            System.debug('Time'+t.Id+'startdate'+t.StartDate);
        }
        
        delete del;        
    }
    */
    /*
    if(trigger.isInsert){    
    
    DateTime createddate;
        for(ServiceTerritoryMember srtm:trigger.new){
            if(srtm.ServiceResourceId!=null && srtm.ServiceTerritoryId!=null)
            {
                createTs.put(srtm.ServiceResourceId,srtm.ServiceTerritoryId);
                createddate=srtm.EffectiveStartDate;
            }
        
        } 
        
        
        List<Number_Of_Working_Day__c> ned=new List<Number_Of_Working_Day__c>();
        List<ServiceTerritory> st=[select id,(Select id,Start_Date__c,End_Date__c from Number_OF_Working_Days__r) from ServiceTerritory where id in: createTs.values()];
        for(ServiceTerritory st_obj:st){
            for(Number_OF_Working_Day__c nd:st_obj.Number_OF_Working_Days__r){
                if(createddate<nd.Start_Date__c ){
                System.debug('Starting:'+nd.Start_Date__c+'StartDate Service'+createdDate);
                    ned.add(nd);
                }
                if(createddate.month()==nd.Start_Date__c.month() && createddate.year()==nd.Start_Date__c.year()){
                    System.debug('Second If Startd:'+nd.Start_Date__c+'StartDate Service'+createdDate);
                    ned.add(nd);
                }
            }
        }
        List<TimeSheet> lst=new List<TimeSheet>();
        
        List<ServiceResource> sr=[select id,name,RelatedRecordId from ServiceResource where id in: createTs.keyset()];
           
           for(ServiceResource sr_obj:sr){
            for(Number_Of_Working_Day__c c:ned){
                System.debug('Starting:'+c.Start_Date__c+'End_Date: '+c.End_Date__c);
                    TimeSheet t=new TimeSheet();
                     t.Number_OF_Working_Day__c=c.Id;
                     t.ServiceResourceId=sr_Obj.id;
                     t.StartDate=c.Start_Date__c;
                     t.EndDate=c.End_Date__c;
                     t.OwnerId=sr_Obj.RelatedRecordId; 
             }
           }
          insert lst;   
          
    }*/

}