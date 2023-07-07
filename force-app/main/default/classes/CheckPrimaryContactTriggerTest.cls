@isTest
public class CheckPrimaryContactTriggerTest{
    public static testMethod void testUpdateTrigger(){
        Account acc=new Account(Name='Doom', AccountSource='Advertisement');
        insert acc;
        
        Contact c=new Contact(
            LastName='Marial 1',
            AccountId=acc.Id,
            Is_Primary__c=true,
            MailingCity='India',
            MailingState='India',
            MailingCountry='India',
            MailingPostalCode='201206',
            MailingStreet='India'
        );
        insert c;
        
        Contact pc=new Contact(
            LastName='Marial 2',
            AccountId=acc.Id,
            Is_Primary__c=true,
            MailingCity='India',
            MailingState='India',
            MailingCountry='India',
            MailingPostalCode='201206',
            MailingStreet='India'
        );
        
        test.startTest();  
        insert pc;    
        test.stopTest(); 
    }
}