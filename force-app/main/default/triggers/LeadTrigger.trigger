trigger LeadTrigger on Lead (before insert, before update, after insert, after update) {
    //Trigger Call Before Context
    if(trigger.isBefore){
        //On Before Insert
        if (trigger.isInsert) {
            LeadTriggerHandler.onBeforeInsert(trigger.new);
        }
        
        //On Before Update
        if (trigger.isUpdate) {
            LeadTriggerHandler.onBeforeUpdate(trigger.new, trigger.oldMap);
        }
    }
    
    //Trigger Call After Context
    if(trigger.isAfter){
        //On After Insert
        if (trigger.isInsert) {
            LeadTriggerHandler.onAfterInsert(trigger.new);
        }
        
        //On After Update
        if (trigger.isUpdate) {
            LeadTriggerHandler.onAfterUpdate(trigger.new, trigger.oldMap);
        }
    }
}