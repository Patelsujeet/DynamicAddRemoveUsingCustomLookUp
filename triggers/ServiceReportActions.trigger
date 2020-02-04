trigger ServiceReportActions on ContentDocumentLink (After insert) {
 set<Id> SAIds = new Set<Id>();
 set<Id> DocIds = new Set<Id>();
    Map<Id,ContentDocumentLink> MapConDoc = new Map<Id,ContentDocumentLink>();
    for (ContentDocumentLink con : Trigger.New){
        MapConDoc.put(con.ContentDocumentId,con);
    }
    List<String> Numbers = new List<String>();
    List<ContentVersion> CVs = [Select Id,Title,ContentDocumentId From ContentVersion Where ContentDocumentId In : MapConDoc.keySet()];
    for(ContentVersion CV : CVs){
        if(CV.Title.startsWith('SA')){
        string pnumber = CV.Title.substring(0,CV.Title.indexOf('_'));
        Numbers.add(pnumber);
        }
    }
    system.debug(Numbers);
    List<ServiceAppointment> SAs = [Select Id,AppointmentNumber,ParentRecordId From ServiceAppointment Where AppointmentNumber =: Numbers];
    List<ContentDocumentLink> ClinkInsert = new List<ContentDocumentLink>();
    if(SAs.size()>0){
        for(ContentVersion CV : CVs){
            for(ServiceAppointment SA :SAs){
                if(CV.Title.contains(SA.AppointmentNumber) && MapConDoc.get(CV.ContentDocumentId).LinkedEntityId != SA.ParentRecordId){
                    ContentDocumentLink Clink = new ContentDocumentLink();
                    Clink.ContentDocumentId = CV.ContentDocumentId;
                    Clink.LinkedEntityId = SA.ParentRecordId;
                    Clink.ShareType = 'V';
                    ClinkInsert.add(Clink);
                }
            }
        }
    }
    Insert ClinkInsert;
}