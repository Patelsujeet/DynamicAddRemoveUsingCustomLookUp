({
    addRow: function(component, event, helper) {
        helper.addAccountRecord(component, event);
    },
    
    save: function(component, event, helper) {
        
        var customLookupClass=document.getElementsByClassName("slds-grid slds-gutters cCustomLookup");
        
        var ern_asset_data=new Array();
        var asset_List=new Array();
        try{
            
            for(var i = 0 ; i< customLookupClass.length ;i++){
                var child_slds_col=customLookupClass[i];
                var slds_col=child_slds_col.getElementsByClassName("slds-col");
                
                var input_data=child_slds_col.getElementsByClassName("slds-input");
                
                var assetName=child_slds_col.getElementsByClassName("slds-pill__label slds-p-left_x-small")[0].innerHTML;
                
                
                
                var temp=assetName+":";
                asset_List.push(assetName);
                
                for(var k=0; k < input_data.length ; k++ ){
                    if(input_data[k].value!=''){
                        temp=temp+input_data[k].value+";";
                    }
                    else{
                        temp=temp+''+";";
                    }
                }
                ern_asset_data.push(temp);
            }  
            
            component.set("v.ern_asset_Insert",ern_asset_data);
            var interval;
            if(component.get("v.ern_asset_Insert")!=null){
                console.log(helper.validateAssetList(component, event,asset_List));
                if(helper.validateAssetList(component, event,asset_List)){
                    component.set("v.message","Duplicate Asset is Not Allowed !!!");
                    component.set("v.toastType","error");
                    component.set("v.showToast",true);
                    
                    interval=window.setTimeout(
                        $A.getCallback(function() { 
                            component.set("v.showToast",false);
                        }), 3000
                    );  
                    
                }
                else if(!helper.validateAssetList(component, event,asset_List)){
                    console.log('success');
                    helper.saveERN_AssetList(component, event, helper);    
                }            
            }
            console.log("list asset"+asset_List);
        }catch(ex){
            if (ex instanceof TypeError) {
                component.set("v.message","Please Fill Asset !!!");
                component.set("v.toastType","error");
                component.set("v.showToast",true);
                
                var asset_Error=window.setTimeout(
                    $A.getCallback(function() { 
                        component.set("v.showToast",false);
                    }), 3000
                );  
            }
            else{
                component.set("v.message","Please Contact To System Admin!!!");
                component.set("v.toastType","error");
                component.set("v.showToast",true);
                
                var asset_Error=window.setTimeout(
                    $A.getCallback(function() { 
                        component.set("v.showToast",false);
                    }), 3000
                );  
            } 
            
        }
        
    } ,
    
    deleteRow : function(component, event, helper){
        var j=component.get("v.ern_asset_List");
        try{
            j.pop();
            component.set("v.ern_asset_List",j);
            //document.getElementById("dynamicCmp").deleteRow(1);
            
            console.log(component.get("v.ern_asset_List").length);
            console.log(component.get("v.ern_asset_List"));
            console.log(component.get("v.temp"));    
        }
        catch(err){
            console.log("error");
        }
    },
    
    Cancel : function(component,event,helper){
        var can=component.getEvent("cancelComponent");
        can.setParams({
            "addMultipleComponent":false
        });
        can.fire();
    }
    
})