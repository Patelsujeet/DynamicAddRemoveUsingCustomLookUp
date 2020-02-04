public class FieldServiceERNCreation {
    
    @AuraEnabled
    Public Static Asset getAsset(Id recordId){
        Asset Asst = [Select Id,Name,Sales_Order_Number__c,Account.Name,Tonnage_Description__c,Date_Shipped__c,Frame_Size__c,Model_Descriptions__c,Service_Area_Region__c From Asset where Id = : recordId];
        return Asst;
    }
    @AuraEnabled
    public static Map<String, String> getLabels(Id recordId) {
        
        String type='Asset';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType AsstSchema = schemaMap.get(type);
        Map<String, Schema.SObjectField> fieldMap = AsstSchema.getDescribe().fields.getMap();
        Map<String, String> fieldsLabel = new Map<String, String>();
        
        for (String fieldName: fieldMap.keySet()) {
            //System.debug(fieldName);
            //System.debug(fieldMap.get(fieldname).getDescribe().getLabel());
            fieldsLabel.put(fieldName, fieldMap.get(fieldname).getDescribe().getLabel());
        }
        return fieldsLabel;
    }
    /*@AuraEnabled        
public static List<String> getPickListValuesIntoList(String objectType, String selectedField){
List<String> pickListValuesList = new List<String>();
Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectType);
Schema.DescribeSObjectResult res = convertToObj.getDescribe();
Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(selectedField).getDescribe();
List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
for( Schema.PicklistEntry pickListVal : ple){
pickListValuesList.add(pickListVal.getLabel());
}     
return pickListValuesList;
}*/
    @AuraEnabled
    public static List <String> getPiklistValues(string fieldName) {
        List<String> plValues = new List<String>();
        
        //Get the object type from object name. Here I've used custom object Book.
        Schema.SObjectType objType = Schema.getGlobalDescribe().get('ERN__c');
        
        //Describe the sObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        
        //Get the specific field information from field name. Here I've used custom field Category__c of Book object.
        Schema.DescribeFieldResult objFieldInfo = objDescribe.fields.getMap().get(fieldName).getDescribe();
        
        //Get the picklist field values.
        List<Schema.PicklistEntry> picklistvalues = objFieldInfo.getPicklistValues();
        
        //Add the picklist values to list.
        for(Schema.PicklistEntry plv: picklistvalues) {
            plValues.add(plv.getValue());
        }
        plValues.sort();
        return plValues;
    }
    /*@AuraEnabled
public static Boolean getERNCreationCriteria(Id AssetId, Decimal TotalCores, Decimal TotalMGO, Decimal TotalAirEje){
System.debug('AssetId--> '+ AssetId);
Boolean IsAlert = false;
Asset asst = [Select Id, Date_Shipped__c,Model_Descriptions__c, SerialNumber From Asset where id = : AssetId];
if(asst.Date_Shipped__c >= Date.valueOf('2007-01-01') && !asst.Model_Descriptions__c.toLowercase().contains('maxima') && (TotalCores <= 3 && TotalCores > 0) || (TotalMGO <= 4 && TotalMGO > 0) || (TotalAirEje <= 4 && TotalAirEje > 0)){
IsAlert = true;
}
System.debug('IsAlert--> '+ IsAlert);
Return IsAlert;
}*/
    @AuraEnabled
    public static Id createERNRecord (ERN__c Ern, Id AssetId){
        Asset Asst = [Select Id,AccountId, Date_Shipped__c,Model_Descriptions__c, SerialNumber, Tonnage_Description__c, Frame_Size__c, Model_Code__c,Service_Area_Region__c  From Asset where id = : AssetId];
        Id recTypeId = Schema.SObjectType.ERN__c.getRecordTypeInfosByName().get('Open Service ERN').getRecordTypeId();
        ERN__c e = new ERN__c();
        
        e = Ern;
        
        e.Asset__c = AssetId;
        e.Account__c = asst.AccountId;
        e.Product_Line__c = asst.Model_Code__c;
        e.Tonnage__c = asst.Tonnage_Description__c;
        e.Injection_Unit__c = asst.Frame_Size__c;
        e.RecordTypeId = recTypeId;
        e.Region__c = asst.Service_Area_Region__c;
        System.debug('Product Line'+asst.Model_Code__c);
        System.debug('ERN Product Family'+e.Product_Family__c);
        insert e;
        return e.Id;
    }
    @AuraEnabled
    public static List<ContentDocument> getUploadedFiles (Id ErnId){
        system.debug('getUploadedFiles Started');
        Set<Id> DocIds = new set<Id>();
        for(ContentDocumentLink cdl :[Select Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: ErnId]){
            DocIds.add(cdl.ContentDocumentId);
        }
        List<ContentDocument> Docs = [Select Id, title from ContentDocument where id In : DocIds];
        Return Docs;
    }
    @AuraEnabled
    public static List<ContentDocument> DeleteSelectedFile (Id DocId, Id ErnId){
        ContentDocument DelCondoc = [Select id From ContentDocument Where id =: DocId];
        Delete DelCondoc;
        Set<Id> DocIds = new set<Id>();
        for(ContentDocumentLink cdl :[Select Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: ErnId]){
            DocIds.add(cdl.ContentDocumentId);
        }
        List<ContentDocument> Docs = [Select Id, title from ContentDocument where id In : DocIds];
        Return Docs;
    }
    
    @AuraEnabled 
    public static List<sObject> fetchAsset(String searchKeyWord,String ern_id){
        System.debug('****'+ern_id);
        String sreachkey='%'+searchKeyWord+'%';
        List<ERN__c> er=[select id,Account__c from ERN__c where id=:ern_id];
        List<sObject> ls=[select id,name,Sales_Order_Number__c from Asset where Account.Id=:er[0].Account__c AND Sales_Order_Number__c Like: sreachkey];
        return ls;
    }
    
    @AuraEnabled
    public static List<ERN_Assets__c> insertERN_Asset(String ern_data,String ern_id){
        List<String> ls=(List<String>)System.JSON.deserialize(ern_data, List<String>.class);
        Map<String,String> m=new Map<String,String>();
        Map<String,String> m2=new Map<String,String>();
        for(String ls_obj:ls){
            List<String> tmp=ls_obj.split(':');
            m.put(tmp[0],tmp[1]);
        }
        List<Asset> ls_asset=[select id,Name from Asset where Name in: m.keySet()];
        for(Asset ast:ls_asset){
            m2.put(ast.Name,ast.Id);
        }
        
        List<ERN_Assets__c> list_ERN_Asset=new List<ERN_Assets__c>();
        for(String st:m.keySet()){
            List<String> extraDetail=m.get(st).split(';');
            System.debug('exta'+extraDetail);
            /*extraDetail is List will contain the detail which is fetch from component 
extraDetail[0] will contain software Version
extraDetail[1] will contain control Rock
extraDetail[2] will contain Electrical Circuit
extraDetail[3] will contain Hydraulic Circuit Number
extraDetail[4] will contain Machine Modifications in Field/Remarks
*/
            ERN_Assets__c e1=new ERN_Assets__c();
            e1.Asset__c=m2.get(st);
            e1.ERN__c=ern_id;
            
            if(extraDetail.size()!=5){
                try{
                    e1.Software_Version__c=extraDetail[1];
                }
                catch(Exception ex){
                    e1.Software_Version__c='';
                }
                try{
                    e1.Control_Rack_Details__c=extraDetail[2];
                }
                catch(Exception ex){
                    e1.Control_Rack_Details__c='';
                }
                try{
                    e1.Electrical_Circuit__c=extraDetail[3];
                }
                catch(Exception ex){
                    e1.Electrical_Circuit__c='';
                        }
                try{
                    e1.Hydraulic_Circuit_Number__c=extraDetail[4];
                }
                catch(Exception ex){
                    e1.Hydraulic_Circuit_Number__c='';
                }
                try{
                    e1.Machine_Modifications_in_Field_Remarks__c=extraDetail[5];
                }
                catch(Exception ex){
                    e1.Machine_Modifications_in_Field_Remarks__c='';
                }
            }
            else if(extraDetail.size()!=5){
                e1.Software_Version__c=extraDetail[1];
                e1.Control_Rack_Details__c=extraDetail[2];
                e1.Electrical_Circuit__c=extraDetail[3];
                e1.Hydraulic_Circuit_Number__c=extraDetail[4];
                e1.Machine_Modifications_in_Field_Remarks__c=extraDetail[5];
            }
            
            
            list_ERN_Asset.add(e1);
        }
        insert list_ERN_Asset;
        List<ERN_Assets__c> ern_Asset_List=[Select Id,Asset__r.Name,ERN__r.Name,Asset__r.Sales_Order_Number__c,Asset__r.Account.Name from ERN_Assets__c where id in: list_ERN_Asset];
        System.debug('+++'+list_ERN_Asset);
        System.debug('+++'+m2);
        System.debug('+++'+ls);
        System.debug('+++'+ern_Asset_List);
        return ern_Asset_List;	
    }
    
}