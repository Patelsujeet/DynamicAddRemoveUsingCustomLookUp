({
	doInit : function(component, event, helper) {
        if(component.get("v.toastType")=="Success" || component.get("v.toastType")=="success"){
            component.set("v.toastType","slds-notify slds-notify_toast slds-theme_success");
            component.set("v.toastIcon","utility:success");
            component.set("v.toastVariant","success");
        }
        else if(component.get("v.toastType")=="info" || component.get("v.toastType")=="Info"){
            component.set("v.toastType","slds-notify slds-notify_toast slds-theme_info");
            component.set("v.toastIcon","action:info");
            component.set("v.toastVariant","info");
        }
        else if(component.get("v.toastType")=="warning" || component.get("v.toastType")=="Warning"){
            component.set("v.toastType","slds-notify slds-notify_toast slds-theme_warning");
            component.set("v.toastIcon","utility:warning");
            component.set("v.toastVariant","warning");
        }
        else if(component.get("v.toastType")=="error" || component.get("v.toastType")=="Error"){
            component.set("v.toastVariant","error");
            component.set("v.toastIcon","utility:error");
            component.set("v.toastType","slds-notify slds-notify_toast slds-theme_error");            
        }
            
	},
    handleClick : function(component,event,helper){
        component.set("v.show",false);
    }
})