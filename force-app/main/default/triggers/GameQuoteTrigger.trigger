trigger GameQuoteTrigger on Game_Quote__c (before insert, before update) {
    //Trigger Call Before Context
    if(trigger.isBefore){
        //On Before Insert
        if (trigger.isInsert) {
            GameQuoteTriggerHandler.onBeforeInsert(trigger.new);
        }
        
        //On Before Update
        if (trigger.isUpdate) {
            GameQuoteTriggerHandler.onBeforeUpdate(trigger.new, trigger.oldMap);
        }
    }
}