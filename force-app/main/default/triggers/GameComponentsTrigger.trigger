trigger GameComponentsTrigger on Game_Components__c (after insert, after update) {
    //Trigger Call After Context
    if(trigger.isAfter){
        //On After Insert
        if (trigger.isInsert) {
            GameComponentsTriggerHandler.onAfterInsert(trigger.new);
        }
        
        //On After Update
        if (trigger.isUpdate) {
            GameComponentsTriggerHandler.onAfterUpdate(trigger.new, trigger.oldMap);
        }
    }
}