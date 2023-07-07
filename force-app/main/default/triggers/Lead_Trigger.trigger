/*
    trigger on lead
*/
trigger Lead_Trigger on Lead (before insert, before update, before delete, after insert, after update, after delete) {
    
    //set context variables
    LeadTriggerHelper.newLeads = trigger.new;
    LeadTriggerHelper.oldLeads = trigger.old;
    LeadTriggerHelper.newMapLeads = trigger.newMap;
    LeadTriggerHelper.oldMapLeads = trigger.oldMap;
    
            
    if(trigger.isAfter) {
        
        //if is insert
        if(trigger.IsInsert) {
            LeadTriggerHelper.createSamplePacketCampaignMember();
        }
        
        //if is update
        if(trigger.isUpdate) {
        try{  
           //delete sample packet tasks
          LeadTriggerHelper.deleteSamplePacketTask();
          }catch(Exception ex){}
        
        }
    }
    else {
        //if is insert
        if(trigger.IsInsert) {
            LeadTriggerHelper.setInclude_In_SamplePacketCSV();
        }
    }
     

}