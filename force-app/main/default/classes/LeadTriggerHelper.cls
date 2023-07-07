/*
    Helper Class for Lead Trigger
*/
public class LeadTriggerHelper {

    public static List<Lead> newLeads;
    public static List<Lead> oldLeads;
    public static Map<Id, Lead> newMapLeads;
    public static Map<Id, Lead> oldMapLeads;
    
     
    public static void deleteSamplePacketTask() {
    
   
        Map<Id, List<Task>> mapWhoId_ListTask = new Map<Id, List<Task>>();
        Set<Id> convertedContactIds = new Set<Id>();
        
        for(Lead l : newLeads) {
            convertedContactIds.add(l.convertedContactId);
        } 
        if(newLeads!=null){
        for(Task t : [Select Id, WhoId From Task Where Status <> 'Completed'
                                                       AND Subject Like '%Sample Packet%' 
                                                       AND (WhoId in : convertedContactIds OR WhoId in : newLeads)]) {
            if(mapWhoId_ListTask.containsKey(t.whoId)) {
                List<Task> listTask = mapWhoId_ListTask.get(t.whoId);
                listTask.add(t);
                mapWhoId_ListTask.put(t.whoId, listTask);
            }
            else {
                List<Task> listTask = new List<Task>();
                listTask.add(t);
                mapWhoId_ListTask.put(t.whoId, listTask);
            }
        }
        }
        for(Lead l : newLeads) {
            if(l.IsConverted) {
                if(mapWhoId_ListTask.containsKey(l.convertedContactId)){ 
                    delete mapWhoId_ListTask.get(l.convertedContactId);
                }
            }
            else if((l.Status != null 
                && l.Status == 'Qualified' 
                && l.Status != oldMapLeads.get(l.Id).Status)) {
            
                if(mapWhoId_ListTask.containsKey(l.Id)){ 
                    delete mapWhoId_ListTask.get(l.Id);
                }
            }
        
        }
        
    }

    public static void setInclude_In_SamplePacketCSV() {
        
        for(Lead l : newLeads) {
            if(l.LeadSource == Constants.Lead_Source_Site_Sample_Packet_Request) {
                l.Include_In_SamplePacketCSV__c = true;
            }
        }
    }
    
    public static void createSamplePacketCampaignMember() {
    
        List<Campaign> cmlist = [Select id From Campaign where Name =: Constants.Campaign_PN_Sample_Packets];
        if(cmlist.size() > 0) {
            List<CampaignMember> listCM = new List<CampaignMember>();
            for(Lead l : newLeads) {
                if(l.LeadSource == Constants.Lead_Source_Site_Sample_Packet_Request) {
                    CampaignMember cml = new CampaignMember(CampaignId = cmlist.get(0).Id, LeadId = l.Id);
                    listCM.add(cml);
                }
            }
            insert listCM;
        }
        
    }
    /*
    public static string GetUserIdByUserName(string username)
    {
    User u=[SELECT Id from User where username=:username limit 1];
    if(u!=null)
    return u.Id;
    else
    return '';
    }
    public static Integer getLeadByEmail(string email)
    {
     List<Lead> l=[SELECT Id from Lead where Email=:email];
    if(l!=null)
    return l.size();
    else
    return 0;
    }
    */
}