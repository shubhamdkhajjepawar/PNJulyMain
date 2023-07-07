@isTest(seeAllData=false)
public class LeadTriggerTest{
    public static testMethod void unitTest01(){
        list<AutoNumberConfiguration__c> acs = new list<AutoNumberConfiguration__c>();
        acs.add(new AutoNumberConfiguration__c(Name = 'Others', Last_Generated_Number__c = 0));
        insert acs;
        
        Campaign camp = new Campaign(Name = Constants.Campaign_PN_Sample_Packets, IsActive = True);
        insert camp;
        
        Lead lstLead =   new Lead();
        lstLead.Company = 'JohnMiller';
        lstLead.LastName = 'Mike';
        lstLead.Status = 'Open';               
        lstLead.LeadSource = Constants.Lead_Source_Site_Sample_Packet_Request;
        
        Test.startTest();
            insert lstLead;
            
            lstLead.Status = 'Qualified';
            update lstLead;
        Test.stopTest();
    }
    
    public static testMethod void unitTest02(){
        list<AutoNumberConfiguration__c> acs = new list<AutoNumberConfiguration__c>();
        acs.add(new AutoNumberConfiguration__c(Name = 'Others', Last_Generated_Number__c = 0));
        insert acs;
        
        Lead lstLead =   new Lead();
        lstLead.Company = 'JohnMiller';
        lstLead.LastName = 'Mike';
        lstLead.Status = 'Open';               
        lstLead.LeadSource = 'PRN Site Blind Quote';
        
        Test.startTest();
            insert lstLead;
        Test.stopTest();
    }
}