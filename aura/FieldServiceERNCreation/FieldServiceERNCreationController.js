({
    doInit : function(component, event, helper) {
        var actionAsset = component.get("c.getAsset");
        actionAsset.setParams({
            recordId : component.get("v.recordId")
        });
        // Add callback behavior for when response is received
        actionAsset.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.Asset", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        // Send action off to be executed
        $A.enqueueAction(actionAsset);
        
        var actionLabels = component.get("c.getLabels");
        actionLabels.setParams({
            recordId : component.get("v.recordId")
        });
        actionLabels.setCallback(this, function(response) {
            
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.labels", response.getReturnValue());
            }
            else{
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(actionLabels);
        
        helper.fetchPickListVal(component,"Category__c","selectCategory","No");
        //helper.fetchPickListVal(component,"Region__c","ERNRegions","Yes"); Commented on 11-1-2019
    },
    
    handleCategoryChange: function (component, event, helper) {
        //Get the Selected values   
        // var selectedValues = event.getParam("value");
        var d = new Date('2007-01-01');
        var d1 = new Date(component.get("v.Asset.Date_Shipped__c"));
        //console.log(d.getTime());
        //console.log('Date Shipped3->' + d1.getTime());
        if(d1.getTime() < d.getTime()){
            component.set("v.BeforeJan2007",true);
        }
        console.log("v.BeforeJan2007" + component.get("v.BeforeJan2007"));
        var selectedValues = component.get("v.newERN.Category__c");
        //Update the Selected Values  
        component.set("v.selectedCategoryList", selectedValues);
        helper.ActionsAfterCategorySelection(component, event, helper);
    },
    
    CheckCriteriaAndValidations : function(component, event, helper){
    	helper.ValidateFieldValuesBeforeNext(component, event);
    },
    CreateNewERN : function(component, event, helper){
        //helper.CheckERNCriteriaBeforeCreate(component, event, helper);
        
        var allValid;
        var RequestDescrption = component.find("RequestDescrption");
        var MachineModification = component.find("MachineModification");
        console.log("RequestDescrption->" + RequestDescrption.get('v.validity').valid);
        if(RequestDescrption.get('v.validity').valid === false){
            RequestDescrption.showHelpMessageIfInvalid();
        }
        else if(MachineModification.get('v.validity').valid === false){
            MachineModification.showHelpMessageIfInvalid();
        }
       
        
        /*
        if (component.get("v.selectionsContainsRetrofit") || 
            component.get("v.selectionContainsCore") ||
            component.get("v.selectionContainsMGO") ||
           component.get("v.selectionContainsAirEje") ||
           component.get("v.selectionContainsSoftware")){
                allValid = component.find("fieldRequired").reduce(function(valid,inputComp){
                    inputComp.showHelpMessageIfInvalid();
                    console.log("inputComp"+inputComp.get("v.name"));	        
                    return valid && inputComp.get('v.validity').valid;
                },true);
            }
        */
        /*
        var allValid = component.find("fieldRequired").reduce(function(valid,inputComp){
            inputComp.showHelpMessageIfInvalid();
        	console.log("inputComp"+inputComp.get("v.name"));	        
  			return valid && inputComp.get('v.validity').valid;
        },true);*/
        
        /*if(component.get("v.BeforeJan2007") === true){
            if(component.find('ElectricalCircuitNumber').get('v.validity').valid === false)
            component.find('ElectricalCircuitNumber').showHelpMessageIfInvalid();
            if(component.find('HydraulicCircuitNumber').get('v.validity').valid === false)
            component.find('HydraulicCircuitNumber').showHelpMessageIfInvalid();
        }*/
        //if(RequestDescrption.get('v.validity').valid === true && MachineModification.get('v.validity').valid === true && (component.get("v.BeforeJan2007") === false || (component.get("v.BeforeJan2007") === true && component.find('ElectricalCircuitNumber').get('v.validity').valid === true && 
       //                                               component.find('HydraulicCircuitNumber').get('v.validity').valid === true))){
       
        /*This part of code is added by me*/
       
        if((RequestDescrption.get('v.validity').valid === true && MachineModification.get('v.validity').valid === true) ){
            console.log("Controller component.get(v.CreateERNCheck)->" + component.get("v.CreateERNCheck"));
            if(component.get("v.CreateERNCheck") === true && allValid){
           	 helper.CreateERN(component, event, helper);
            }     
            else if(component.get("v.CreateERNCheck")){
                helper.CreateERN(component, event, helper);
            }
        }
        
    },
    //For File Upload
    handleUploadFinished: function (component, event, helper) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        alert(uploadedFiles.length + " Files has been uploaded successfully! ");
        
        var getUploadedFiles = component.get("c.getUploadedFiles");
        getUploadedFiles.setParams({
            ErnId : component.get("v.newERN.Id")
        });
        // Add callback behavior for when response is received
        getUploadedFiles.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.Files", response.getReturnValue());
                console.log("Uploaded Files:" + component.get("v.Files"));
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        // Send action off to be executed
        $A.enqueueAction(getUploadedFiles);
    },
    DeleteAction :function(component, event, helper) {        
        if(confirm('Are you sure?')){
            console.log('Delete ID' +  event.target.id);
            var DeleteSelectedFile = component.get("c.DeleteSelectedFile");
        DeleteSelectedFile.setParams({
            DocId : event.target.id,
            ErnId : component.get("v.newERN.Id")
        });
        DeleteSelectedFile.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.Files", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        // Send action off to be executed
        $A.enqueueAction(DeleteSelectedFile);
        }
    },
    FinishAction : function(component, event, helper) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
                    dismissActionPanel.fire(); 
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success Message',
                        message: 'ERN is successfully created!!',
                        messageTemplate: 'ERN is successfully created!!',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
    },
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
       // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
   },
    
 // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
     // make Spinner attribute to false for hide loading spinner    
       component.set("v.Spinner", false);
    },
    
    CancelAction :  function(component , event, helper){
        component.set("v.isOpen",false);
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
    
    AddAsset : function(component,evt,helper){
        component.set("v.mulitpleAsset",true);
    },
    
    cancelAddComponent : function(component,event,helper){
        component.set("v.mulitpleAsset",event.getParam("addMultipleComponent"));
    }
    
})