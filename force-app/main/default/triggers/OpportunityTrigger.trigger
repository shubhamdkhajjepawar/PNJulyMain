trigger OpportunityTrigger on Opportunity (before insert, before update) {
    //Trigger Call Before Context
    if(trigger.isBefore){
        //On Before Insert
        if (trigger.isInsert) {
            OpportunityTriggerHandler.onBeforeInsert(trigger.new);
        }
        
        //On Before Update
        if (trigger.isUpdate) {
            OpportunityTriggerHandler.onBeforeUpdate(trigger.new, trigger.oldMap);
        }
    }
}