({
    keyPressController : function(component, event, helper) {
        // get the search Input keyword   
        
        var variable=event.target;
        var searchText = variable.value;     
        var dataEle = variable.getAttribute("id");
        component.set("v.currentElementId",dataEle);
        
        if( searchText.length > 0 ){
            helper.searchHelper(component,event,searchText);            
        }      
        
        console.log("getAsset"+component.get("v.selectedAssetName")+":");
        console.log("Search KEyword"+searchText);
        console.log(component.get("v.index"));
        console.log("Component at index "+dataEle+" has value "+variable.value);
        
    },
    
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
        // get the selected Account record from the COMPONETN event 	 
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        component.set("v.selectedRecord" , selectedAccountGetFromEvent); 
        component.set("v.selectedAssetName",selectedAccountGetFromEvent.Name);
        
        document.getElementById(component.get("v.currentElementId")).style.display="none";
        document.getElementById(component.get("v.currentElementId")).value=null;
        component.set("v.listOfSearchRecords", []);
        
        console.log("event"+JSON.stringify(event.getParam("recordByEvent")));
        console.log("getAsset"+ document.getElementById(component.get("v.currentElementId")).value);
        
        
    },
    clearSelection : function(component,event,helper){
        console.log(component.get("v.selectedAssetName"));
        component.set("v.selectedAssetName",null);
        document.getElementById(component.get("v.currentElementId")).style.display="";
    },
    
    deleteR : function(cmp,event,helper){
		console.log("ern_asset"+cmp.get("v.index")); 
        var removeCmp=document.getElementById("ern_asset"+cmp.get("v.index"));
        //removeCmp.style.display="none";
        removeCmp.remove();
	}
 })