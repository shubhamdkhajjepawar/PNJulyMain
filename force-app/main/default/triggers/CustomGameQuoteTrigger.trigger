trigger CustomGameQuoteTrigger on Custom_Game_Quote__c (before insert, before update) {
    //Trigger Call Before Context
    if(trigger.isBefore){
        //On Before Insert
        if (trigger.isInsert) {
            CustomGameQuoteTriggerHandler.onBeforeInsert(trigger.new);
        }
        
        //On Before Update
        if (trigger.isUpdate) {
            CustomGameQuoteTriggerHandler.onBeforeUpdate(trigger.new, trigger.oldMap);
        }
    }
}