public with sharing class LeadTriggerHandler {
    /**
     * Method called on before insert
     */
    public static void onBeforeInsert(list<Lead> newRecords) {
    	boolean isUpdate = false;
    	map<String, AutoNumberConfiguration__c> autoNumberConfigurations = AutoNumberConfiguration__c.getAll();
        
        for(Lead l : newRecords) {
            if(l.LeadSource == Constants.Lead_Source_Site_Sample_Packet_Request) {
                l.Include_In_SamplePacketCSV__c = true;
            }
            
            string leadStat = (autoNumberConfigurations.containsKey(l.LeadSource) ? l.LeadSource : 'Others');
            if(l.Custom_Lead_Number__c == null){
            	integer lastStatNumber = Integer.valueOf(autoNumberConfigurations.get(leadStat).Last_Generated_Number__c);
            	l.Custom_Lead_Number__c = lastStatNumber + 1;
            	autoNumberConfigurations.get(leadStat).Last_Generated_Number__c = lastStatNumber + 1; 
            	isUpdate = true;
            }
        }
        
        if(isUpdate){
        	update autoNumberConfigurations.values();
        }
    }
    
    /**
     * Method called on before update
     */
    public static void onBeforeUpdate(list<Lead> newRecords, map<Id, Lead> oldRecordMap) {
    	boolean isUpdate = false;
    	map<String, AutoNumberConfiguration__c> autoNumberConfigurations = AutoNumberConfiguration__c.getAll();
    	
    	for(Lead l : newRecords) {
        	string leadStat = (autoNumberConfigurations.containsKey(l.LeadSource) ? l.LeadSource : 'Others');
            if(l.Custom_Lead_Number__c == null){
            	integer lastStatNumber = Integer.valueOf(autoNumberConfigurations.get(leadStat).Last_Generated_Number__c);
            	l.Custom_Lead_Number__c = lastStatNumber + 1;
            	autoNumberConfigurations.get(leadStat).Last_Generated_Number__c = lastStatNumber + 1; 
            	isUpdate = true;
            }
        }
        
        if(isUpdate){
        	update autoNumberConfigurations.values();
        }
    }
    
    /**
     * Method called on after insert
     */
    public static void onAfterInsert(list<Lead> newRecords) {
        list<Campaign> campaigns = [SELECT id From Campaign where Name =: Constants.Campaign_PN_Sample_Packets];
        list<CampaignMember> campaignMembers = new list<CampaignMember>();
        list<Lead> leadAssignmentRules = new list<Lead>();
        for(Lead l : newRecords) {
            if(l.LeadSource == Constants.Lead_Source_Site_Sample_Packet_Request && campaigns.size() > 0) {
                campaignMembers.add(new CampaignMember(CampaignId = campaigns.get(0).Id, LeadId = l.Id));
            }
            
            if ((l.LeadSource == 'PRN Site Blind Quote') || (l.LeadSource == 'PRN Site Freight Quote') || (l.LeadSource == 'PRN Card Game Print Quote Request') || (l.LeadSource == 'PRN Board Game Print Quote Request') || (l.LeadSource == 'PRN Card Game Blind Order') || (l.LeadSource == 'PRN Card Game Blind Quote') || (l.LeadSource == 'PRN Board Game Blind Order') || (l.LeadSource == 'PRN Board Game Blind Quote') || (l.LeadSource == 'PRN Custom Card Game Quote Form') || (l.LeadSource == 'PRN Custom Board Game Quote Form') || (l.LeadSource == 'PRN Blind Order')){
                leadAssignmentRules.add(new Lead(id = l.id));   
            }
        }
        
        //Insert CampaignMember
        if(campaignMembers.size() > 0){
            insert campaignMembers;
        }
        
        //Calc Lead Assignment Rule
        if(leadAssignmentRules.size() > 0){
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule= true;
            Database.update(leadAssignmentRules, dmo);
        }
    }
    
    /**
     * Method called on after update
     */
    public static void onAfterUpdate(list<Lead> newRecords, map<Id, Lead> oldRecordMap) {
        set<Id> convertedContactIds = new set<Id>();
        for(Lead l : newRecords) {
            convertedContactIds.add(l.convertedContactId);
        } 
        
        //Task to delete
        map<Id, list<Task>> mapWhoId_ListTask = new map<Id, list<Task>>();
        for(Task t : [SELECT Id, WhoId FROM Task WHERE Status <> 'Completed' AND Subject like '%Sample Packet%' AND (WhoId IN : convertedContactIds OR WhoId IN : newRecords)]) {
            if(!mapWhoId_ListTask.containsKey(t.whoId)){
                mapWhoId_ListTask.put(t.whoId, new list<Task>());
            }
            mapWhoId_ListTask.get(t.whoId).add(t);
        }
        list<Task> taskToDelete = new list<Task>();
        for(Lead l : newRecords) {
            if(l.IsConverted) {
                if(mapWhoId_ListTask.containsKey(l.convertedContactId)){ 
                    taskToDelete.addAll(mapWhoId_ListTask.get(l.convertedContactId));
                }
            } else if((l.Status != null && l.Status == 'Qualified' && l.Status != oldRecordMap.get(l.Id).Status)) {
                if(mapWhoId_ListTask.containsKey(l.Id)){ 
                    taskToDelete.addAll(mapWhoId_ListTask.get(l.Id));
                }
            }
        }
        if(taskToDelete.size() > 0){
            Database.delete(taskToDelete, false);
        }
    }
}