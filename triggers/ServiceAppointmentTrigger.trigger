trigger ServiceAppointmentTrigger on ServiceAppointment (before insert, before update, before delete, after insert, after update, after delete) {

    System.debug('Service Appointment Trigger');

    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            //Before Insert
            blogicServiceAppointment.setGanttLabel(Trigger.new);
			blogicServiceAppointment.UpdateSAOwnerInitial(Trigger.new);
        } else if (Trigger.isUpdate) {
            //Before Update
            blogicServiceAppointment.setGanttLabel(Trigger.new);

        } else if (Trigger.isDelete) {
            //Before Delete

        }
    }

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            //After Insert
            blogicServiceAppointment.logInitialStatusHistory(Trigger.new);
            blogicServiceAppointment.setGanttColor(Trigger.oldMap, Trigger.newMap);
            
            //blogicServiceAppointment.addServiceResource(Trigger.new);

        } else if (Trigger.isUpdate) {
            //After Update
            blogicServiceAppointment.logStatusHistory(Trigger.oldMap, Trigger.newMap);
            blogicServiceAppointment.setGanttColor(Trigger.oldMap, Trigger.newMap);
            blogicServiceAppointment.AddARForChangeSAOwner(Trigger.oldMap, Trigger.newMap);

        } else if (Trigger.isDelete) {
            //After Delete

        }
    }

}