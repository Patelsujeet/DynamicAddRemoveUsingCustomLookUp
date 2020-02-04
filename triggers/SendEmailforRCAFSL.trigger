trigger SendEmailforRCAFSL on Problem_Summary_and_Quality_Analysis__c (after update,after insert) {
    SendEmailforRCAFSLHandler handler = new SendEmailforRCAFSLHandler();
    if(trigger.Isupdate && SendEmailforRCAFSLHandler.firstRun){
        SendEmailforRCAFSLHandler.firstRun = false;
        handler.SendEmailUpdate(Trigger.new, Trigger.oldMap);
    }
    if(trigger.IsInsert && SendEmailforRCAFSLHandler.firstRun){
        SendEmailforRCAFSLHandler.firstRun = false;
        handler.SendEmailInsert(Trigger.new);
    }
}