({
    fileUpload : function(component, event, helper) {
        var uploadedFiles = event.getParam("files");
        console.log(uploadedFiles.length);
        console.log(uploadedFiles.documentId);
    },
    navigateToERN : function(component,event,helper){
        
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.ern_Id")
        });
        navEvt.fire();
    }
})