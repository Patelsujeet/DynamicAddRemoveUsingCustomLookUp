trigger AI_Number_OF_Working_Day on Number_OF_Working_Day__c (after insert) {
    /*
    List<Number_OF_Working_Day__c> lst=new List<Number_OF_Working_Day__c >();
    for(Number_OF_Working_Day__c c:trigger.new){
        if(c.Service_Territory__c!= null){
            lst.add(c);
        }
    }
    TimeSheetManagement.timeSheetCreation(lst);
	This comment is for deployment
    */
	
	
	
   /* Map<id,String> workidwithregion=new Map<id,String>();
    List<ID> serviceterrilist=new List<Id>();
    String serviceterritory;
    for(Number_OF_Working_Day__c c:trigger.new){
        if(c.Service_Territory__c!= null){
            serviceterrilist.add(c.Service_Territory__c);
        }
    }
    List<ServiceTerritory> ls=[select id,name from ServiceTerritory where id in: serviceterrilist];
    
    for(ServiceTerritory sc:ls){
        serviceterritory=sc.Name;
    }
    List<Id> id=new List<ID>();
    
    List<User> u=[select id,name from User where Territory__c=:serviceterritory and IsActive=:true];
    List<ServiceResource> sr=[select id,name,RelatedRecordId from ServiceResource where RelatedRecordId in : u];
    
    System.debug('++'+sr);
    List<TimeSheet> timesheetlist=new List<TimeSheet>();
    TimeSheet ts;
    
    for(Number_OF_Working_Day__c c:trigger.new){
        for(ServiceResource sr_Obj:sr){
            ts=new TimeSheet();
            ts.Number_OF_Working_Day__c=c.id;
            ts.ServiceResourceId=sr_Obj.id;
            ts.StartDate=c.Start_Date__c;
            ts.EndDate=c.End_Date__c;
            ts.OwnerId=sr_Obj.RelatedRecordId;
            timesheetlist.add(ts);
            }
    }
    insert timesheetlist;     
    
        System.debug('++'+timesheetlist);
 */   
}