({	
    fetchPickListVal : function (component, fld, elementId, defaultval){
        var eleId = component.find(elementId);
        console.log("defaultval -> "+ defaultval);
        console.log("ERNCreated - "+ component.get("v.ERNCreated"));
        var action = component.get("c.getPiklistValues");
        action.setParams({
            fieldName : fld
        })
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                var plValues = [];
                if(defaultval === "Yes"){
                    plValues.push({
                        label: "--Select One--",
                        value: ""
                    });
                }
                for (var i = 0; i < result.length; i++) {
                    plValues.push({
                        label: result[i],
                        value: result[i]
                    });
                }
                eleId.set("v.options", plValues);
            }
            else{
                window.alert("There is an error to create ERN. Please contact your System Administrator.");
            }
        });
        $A.enqueueAction(action);
    },
    ActionsAfterCategorySelection : function (component, event, helper){
        var selectedValues = component.get("v.selectedCategoryList");
        console.log('Selectd Category-' + selectedValues);
        if(selectedValues.includes("Core")){
            var selectionContainsCore = true;
            component.set("v.selectionContainsCore", selectionContainsCore); 
            console.log('Contains Core -' + selectionContainsCore);
            component.set("v.CreateERNCheck", false);
        }
        else if(!selectedValues.includes("Core")){
            var selectionContainsCore = false;
            component.set("v.selectionContainsCore", selectionContainsCore); 
            component.set("v.newERN.Existing_Core__c", null);
            component.set("v.newERN.Required_Additional_Core__c", null);
            console.log('Contains Core -' + selectionContainsCore);
        }
        if(selectedValues.includes("MGO")){
            var selectionContainsMGO = true;
            component.set("v.selectionContainsMGO", selectionContainsMGO); 
            console.log('Contains MGO -' + selectionContainsMGO);
            component.set("v.CreateERNCheck", false);
        }
        else if(!selectedValues.includes("MGO")){
            var selectionContainsMGO = false;
            component.set("v.selectionContainsMGO", selectionContainsMGO); 
            component.set("v.newERN.Existing_MGO__c", null);
            component.set("v.newERN.Required_Additional_MGO__c", null);
            console.log('Contains MGO -' + selectionContainsMGO);
        }
        if(selectedValues.includes("Air Ejection")){
            var selectionContainsAirEje = true;
            component.set("v.selectionContainsAirEje", selectionContainsAirEje); 
            console.log('Contains AE-' + selectionContainsAirEje);
            component.set("v.CreateERNCheck", false);
        }
        else if(!selectedValues.includes("Air Ejection")){
            var selectionContainsAirEje = false;
            component.set("v.selectionContainsAirEje", selectionContainsAirEje); 
            component.set("v.newERN.Existing_Air_Ejection__c", null);
            component.set("v.newERN.Required_Additional_Air_Ejection__c", null);
            console.log('Contains AE -' + selectionContainsAirEje);
        }
        /*if(selectedValues.includes("Software")){
            var selectionContainsSoftware = true;
            component.set("v.selectionContainsSoftware", selectionContainsSoftware); 
            console.log('Contains Software-' + selectionContainsSoftware);
        }
        else if(!selectedValues.includes("Software")){
            var selectionContainsSoftware = false;
            component.set("v.selectionContainsSoftware", selectionContainsSoftware); 
            component.set("v.newERN.Software_Version__c", null);
            component.set("v.newERN.Control_Rack_Details__c", null);
            console.log('Contains Software -' + selectionContainsSoftware);
        }*/
        if(selectedValues.includes("OPC") || selectedValues.includes("RMS") || selectedValues.includes("Software") || selectedValues.includes("Drive/Motor")){
            component.set("v.selectionContainsSoftware",true);
            console.log('OPC-' + component.get("v.selectionContainsSoftware"));
        }
        else if(!selectedValues.includes("OPC") || !selectedValues.includes("RMS")){
            component.set("v.selectionContainsSoftware",false);
        }
        if(selectedValues.includes("Retrofitment-Control") || 
           selectedValues.includes("Retrofitment-Servo") || 
           selectedValues.includes("Retrofitment/Refurbishment"))
        {
            if(component.get("v.BeforeJan2007")==false){
                component.set("v.BeforeJan2007Checking",true);
            }
           component.set("v.selectionsContainsRetrofit",true);
            console.log('Contains selectionsContainsRetrofit -' + component.get("v.selectionsContainsRetrofit"));
        }
        else if(!selectedValues.includes("Retrofitment-Control") || 
                 !selectedValues.includes("Retrofitment-Servo") || 
                !selectedValues.includes("Retrofitment/Refurbishment")){
            component.set("v.selectionsContainsRetrofit",false);
            
        }
    },
    
    
    ValidateFieldValuesBeforeNext : function (component, event, helper){
        var inputcat = component.find("selectCategory");
        
        var lisofselectvalue=component.get("v.selectedCategoryList");
        var i;
        let m=new Map();
        for(i of lisofselectvalue){
            console.log(i);
            if(i=='MGO'){
                if(component.find('ExistingMGO').get('v.validity').valid== false ){
                            component.find('ExistingMGO').showHelpMessageIfInvalid();
                        } else if(component.find('AdditionalMGO').get('v.validity').valid== false){
                            component.find('AdditionalMGO').showHelpMessageIfInvalid();
                        }
                        else{
                            m.set('MGO',true);
                        }
            }
            else if(i=='OPC'){
                if(component.find('Software').get('v.validity').valid== false ){
                            component.find('Software').showHelpMessageIfInvalid();
                        } else if(component.find('ControlRack').get('v.validity').valid== false){
                            component.find('ControlRack').showHelpMessageIfInvalid();
                        }
                        else{
                        	m.set('OPC',true);        
                            }
                		
            }
           else if(i=='Core'){
                    if(component.find('ExistingCore').get('v.validity').valid== false ){
                            component.find('ExistingCore').showHelpMessageIfInvalid();
                        } else if(component.find('AdditionalCore').get('v.validity').valid== false){
                            component.find('AdditionalCore').showHelpMessageIfInvalid();
                        }
               			else{
                        	m.set('Core',true);        
                            }
                }
          else if(i=='Retrofitment-Control' || i=='Retrofitment-Servo' || i=='Retrofitment/Refurbishment'){
                   if(component.find('ElectricalCircuitNumber').get('v.validity').valid== false ){
                            component.find('ElectricalCircuitNumber').showHelpMessageIfInvalid();
                        } else if(component.find('HydraulicCircuitNumber').get('v.validity').valid== false){
                            component.find('HydraulicCircuitNumber').showHelpMessageIfInvalid();
                        }else if(component.find('ExistingControl').get('v.validity').valid== false){
                            component.find('ExistingControl').showHelpMessageIfInvalid();
                        }
              			else{
                        	m.set('Retrofitment',true);        
                            }
               }
              else if(i=='Air Ejection'){
					if(component.find('ExistingAirEjection').get('v.validity').valid== false ){
                            component.find('ExistingAirEjection').showHelpMessageIfInvalid();
                        } else if(component.find('AdditionalAirEjection').get('v.validity').valid== false){
                            component.find('AdditionalAirEjection').showHelpMessageIfInvalid();
                        }  
                  		else{
                        	m.set('Air Ejection',true);        
                            }
              }
               else{
            	console.log('this is ');   
                   m.set('Other'+i,true);
               }
            
        }
        console.log(m);
        let count=0;
        for(let [k,v] of m){
            if(v==true){
                count++;
            }
        }
        console.log("count"+count);
        console.log('list'+lisofselectvalue.length);
        if(count==lisofselectvalue.length){
            component.set("v.CreateERNCheck",true);
        }
       
    },
    
    CreateERN : function (component, event, helper){
        console.log("component.get(v.CreateERNCheck)" + component.get("v.CreateERNCheck"));
        this.CheckERNCriteriaBeforeCreate(component, event, helper);
        if(component.get("v.CreateERNCheck") === true ){
            console.log("CreateERN");
            var CreateErn = component.get("c.createERNRecord");
            CreateErn.setParams({	
                Ern : component.get("v.newERN"),
                AssetId : component.get("v.recordId")
            });
            CreateErn.setCallback(this, function(response) {
                var state = response.getState();
                console.log(state);
                if(state === "SUCCESS"){
                    component.set("v.newERN.Id", response.getReturnValue());
                    console.log("ERN Id:" + response.getReturnValue() + " "+component.get("v.newERN.Id"));
                    component.set("v.ERNCreated", true);
                }
                 else if (state === "ERROR") {
                     console.log("Unknown error"+response.getError());
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                     errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
                else{
                    alert("There is an Error while creating an ERN. Please contact your System Administrator.")
                }
            });
            $A.enqueueAction(CreateErn);
        }
    },
    
    CheckERNCriteriaBeforeCreate : function (component, event, helper){
        console.log("CheckERNCriteriaBeforeCreate");
        console.log(component.get("v.Asset.Model_Descriptions__c"));
       
        if(component.get("v.Asset.Model_Descriptions__c")!=null)
        {
         	 console.log("Model Description: " + component.get("v.Asset.Model_Descriptions__c").includes("Maxima") );   
             var CreateERNCheck = true;
            var core = component.get("v.selectionContainsCore");
            var totalcores = 0;
            totalcores = Number(component.get("{!v.newERN.Existing_Core__c}")) + Number(component.get("{!v.newERN.Required_Additional_Core__c}"));
            console.log('Contains total core -> ' + totalcores);
            
            var MGO = component.get("v.selectionContainsMGO");
            var totalMGOs = 0;
            totalMGOs = Number(component.get("{!v.newERN.Existing_MGO__c}")) + Number(component.get("{!v.newERN.Required_Additional_MGO__c}"));
            console.log('Contains total MGO -> ' + totalMGOs);
            
            var AirEje = component.get("v.selectionContainsAirEje");
            var totalAirEje = 0;
            totalAirEje = Number(component.get("{!v.newERN.Existing_Air_Ejection__c}")) + Number(component.get("{!v.newERN.Required_Additional_Air_Ejection__c}"));
            console.log('Contains total Air Ejection -> ' + totalAirEje);
            
            if(component.get("v.BeforeJan2007") === false && component.get("v.Asset.Model_Descriptions__c").includes("Maxima") === false && core === true && totalcores <= 3){
                CreateERNCheck = false;
                component.set("v.CreateERNCheck", CreateERNCheck);
                console.log("CreateERNCheck->" + component.get("v.CreateERNCheck"));
                window.alert("Take sales price for Selected Core & Generate SPO!");
            }     
            
            else if(component.get("v.BeforeJan2007") === false && component.get("v.Asset.Model_Descriptions__c").includes("Maxima") === false && MGO === true && totalMGOs <= 4){
                CreateERNCheck = false;
                component.set("v.CreateERNCheck", CreateERNCheck);
                console.log("CreateERNCheck->" + component.get("v.CreateERNCheck"));
                window.alert("Take sales price for Selected MGO & Generate SPO!");
            }
            
            
                else if(component.get("v.BeforeJan2007") === false && component.get("v.Asset.Model_Descriptions__c").includes("Maxima") === false && AirEje === true && totalAirEje <= 4){
                    CreateERNCheck = false;
                    component.set("v.CreateERNCheck", CreateERNCheck);
                    console.log("CreateERNCheck->" + component.get("v.CreateERNCheck"));
                    window.alert("Take sales price for Selected Air Ejection & Generate SPO!");
                }
            
                    else{
                    component.set("v.CreateERNCheck", true);
                    console.log("CreateERNCheck->" + component.get("v.CreateERNCheck"));
                }
        }
        else
        {
            alert("Model Description is Not Available on This Record........");
        }
       
    }
})