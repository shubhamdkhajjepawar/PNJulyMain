trigger ContactTrigger on Contact (after insert, after update) {
    //Trigger Call After Context
    if(trigger.isAfter && !Constants.CHECKPRIMARYCONTACTTRIGGER){
        //On After Insert
        if (trigger.isInsert) {
            ContactTriggerHandler.onAfterInsert(trigger.new);
        }
        
        //On After Update
        if (trigger.isUpdate) {
            ContactTriggerHandler.onAfterUpdate(trigger.new, trigger.oldMap);
        }
    }
}