@isTest
public class OpportunityTriggerTest{
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
        
        Quote q=new Quote(
            Name='quoteNaem',
            Quoted_Created__c=Date.today(),
            Quote_Source__c='International',
            OpportunityId=opp.Id,
            Use_to_Calculate_ROW_1__c='Yes'    
        );
        insert q;
        
        test.startTest();
        
        q.Use_to_Calculate_ROW_1__c='No';
        q.Use_to_Calculate_ROW_2__c='Yes';
        update q;
        
        opp.Production_Status__c = 'Hardcopy Proof Approved';
        update opp;
        
        q.Use_to_Calculate_ROW_2__c='No';
        q.Use_to_Calculate_ROW_3__c='Yes';
        update q;
        
        opp.Production_Status__c = 'Ready For Proofing';
        update opp;
        
        q.Use_to_Calculate_ROW_3__c='No';
        q.Use_to_Calculate_ROW_4__c='Yes';
        update q;
        
        opp.Production_Status__c = 'Approved for production';
        update opp;
        
        q.Use_to_Calculate_ROW_4__c='No';
        q.Use_to_Calculate_ROW_11__c='Yes';
        update q;
        
        opp.Production_Status__c = 'Ready For Proofing';
        update opp;
        
        q.Use_to_Calculate_ROW_11__c='No';
        q.Use_to_Calculate_ROW_12__c='Yes';
        update q;
        
        opp.Production_Status__c = 'In-Production';
        update opp;
        
        q.Use_to_Calculate_ROW_12__c='No';
        q.Use_to_Calculate_ROW_13__c='Yes';
        update q;
        
        opp.Production_Status__c = 'Ready For Proofing';
        update opp;
        
        q.Use_to_Calculate_ROW_13__c='No';
        q.Use_to_Calculate_ROW_14__c='Yes';
        update q;
        
        test.stopTest();
    }
    
    public static testMethod void unitTest02(){
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
        
        Game_Quote__c gq=new Game_Quote__c(
            Name='quoteNaem',
            Opportunity__c=opp.Id,
            Use_to_Calculate_ROW_1__c='Yes'    
        );
        insert gq;
        
        test.startTest();
        
        gq.Use_to_Calculate_ROW_1__c='No';
        gq.Use_to_Calculate_ROW_2__c='Yes';
        update gq;
        
        opp.Production_Status__c = 'Production Hold';
        update opp;
        
        test.stopTest();
    }
    
    public static testMethod void unitTest03(){
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
        insert cgq;
        
        test.startTest();
        
        cgq.Use_to_Calculate_ROW_1__c='No';
        cgq.Use_to_Calculate_ROW_2__c='Yes';
        update cgq;
        
        opp.Production_Status__c = 'Ready For Proofing';
        update opp;
        
        cgq.Use_to_Calculate_ROW_2__c='No';
        cgq.Use_to_Calculate_ROW_3__c='Yes';
        update cgq;
        
        opp.Production_Status__c = 'Production Resumed';
        update opp;
        
        cgq.Use_to_Calculate_ROW_3__c='No';
        cgq.Use_to_Calculate_ROW_4__c='Yes';
        update cgq;
        
        test.stopTest();
    }
}