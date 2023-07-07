@isTest (seeAllData = false)
public class Lead_TriggerTest{
    

    
      
  
    
    public static void doConvert(Id leadId){

        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(leadId);
        lc.setDoNotCreateOpportunity(True); 

        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
    }

}