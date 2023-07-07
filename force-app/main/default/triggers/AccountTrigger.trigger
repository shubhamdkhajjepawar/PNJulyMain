trigger AccountTrigger on Account (before insert) {
    //Trigger Call Before Context
    if(trigger.isBefore){
        //On Before Insert
        if (trigger.isInsert) {
            AccountTriggerHandler.onBeforeInsert(trigger.new);
        }
    }
}