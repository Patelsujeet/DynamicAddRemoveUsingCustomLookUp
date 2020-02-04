trigger LeadTrigger on Lead (before insert, before update, before delete, after insert, after update, after delete) {

    System.debug('Lead Trigger');
    /*
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            //Before Insert

        } else if (Trigger.isUpdate) {
            //Before Update

        } else if (Trigger.isDelete) {
            //Before Delete

        }
    }
    */
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            //After Insert
            blogicLead.createServiceCases(Trigger.new);

        } /*else if (Trigger.isUpdate) {
            //After Update

        } else if (Trigger.isDelete) {
            //After Delete

        }*/
    }

}