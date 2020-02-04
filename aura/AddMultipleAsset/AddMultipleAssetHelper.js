({
    addAccountRecord: function(component, event) {
        //get the account List from component  
        var accountList = component.get("v.ern_asset_List");
        var i = component.get("v.temp");
        //document.getElementById("dynamicCmp").insertRow(0);
        i++;
        accountList.push(i);
        console.log("new"+JSON.stringify(accountList));
        component.set("v.ern_asset_List", accountList);
        component.set("v.temp",i);
    },
    
    validateAssetList: function(component, event,asset_List) {
        
        for(var i = 0; i <= asset_List.length; i++) {
            for(var j = i; j <= asset_List.length; j++) {
                if(i != j && asset_List[i] == asset_List[j]) {
                    return true;
                }
            }
        }
        return false;
    },
    
    saveERN_AssetList: function(component, event) {
        //Call Apex class 
        var action = component.get("c.insertERN_Asset");
        console.log("list data"+JSON.stringify(component.get("v.ern_asset_Insert")));
        action.setParams({
            "ern_data":JSON.stringify(component.get("v.ern_asset_Insert")),
            "ern_id":component.get("v.ern_id"),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.ern_To_Upload_File",response.getReturnValue());
                component.set("v.isPopUp",true);
                
            }
        }); 
        $A.enqueueAction(action);
    }
    
})