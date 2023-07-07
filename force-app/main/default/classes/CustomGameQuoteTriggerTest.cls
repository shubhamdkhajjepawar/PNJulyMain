@isTest(seeAllData=false)
public class CustomGameQuoteTriggerTest{
    public static testMethod void unitTest01(){
    	Account acc=new Account(
            Name='Doom',
            AccountSource='Advertisement'
        );
        insert acc;
        
        Contact c=new Contact(
            LastName='Marial',
            AccountId=acc.Id,
            Is_Primary__c=true,
            MailingCity='India',
            MailingState='India',
            MailingCountry='India',
            MailingPostalCode='201206',
            MailingStreet='India'
            
        );
        insert c;
        
        Opportunity opp=new Opportunity(
            Name='Doomstone',
            CloseDate=Date.today(),
            Opportunity_Vendor__c='International',
            StageName='Closed Won',
            AccountId=acc.Id,
            Production_Status__c='Waiting For Artwork',
            Production_Status_Clone__c = null,
            Approval_Date__c = Date.today()
            
        );
        insert opp; 
        
        Custom_Game_Quote__c cgq=new Custom_Game_Quote__c(
            Name='quoteNaem',
            Opportunity__c=opp.Id,
            Use_to_Calculate_ROW_1__c='Yes'    
        );
        
        test.startTest();   
        insert cgq;
        
        update cgq;
        test.stopTest();
    }
}