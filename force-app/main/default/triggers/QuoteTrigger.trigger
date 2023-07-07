/**
 * @description       : 
 * @author            : Ashwani Soni
 * @group             : 
 * @last modified on  : 08-04-2021
 * @last modified by  : Ashwani Soni
**/
trigger QuoteTrigger on Quote (before insert, before update, after insert, after update) {
    // Trigger Call Before Context
    if(trigger.isBefore){
        // On Before Insert
        if(trigger.isInsert) {
            QuoteTriggerHandler.onBeforeInsert(trigger.new);
        }

        // On Before Update
        if(trigger.isUpdate) {
            QuoteTriggerHandler.onBeforeUpdate(trigger.new, trigger.oldMap);
        }
    }

    // Trigger Call After Context
    if(trigger.isAfter){
        // On After Insert
        if(trigger.isInsert){
            QuoteTriggerHandler.onAfterInsert(trigger.new);
            QuoteTriggerHelper.afterInsert(Trigger.New);
        }

        //on After Update
        if(trigger.isUpdate) {
            QuoteTriggerHandler.onAfterUpdate(trigger.new, trigger.oldMap);
        }
    }
}