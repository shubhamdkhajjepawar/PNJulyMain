@isTest(seeAllData=false)
public class ContactTriggerTest{
    public static testMethod void unitTest01(){
        Account acc = new Account(Name = 'MFL');
        insert acc;
        
        Contact con1 = new Contact(LastName = 'Sharma', AccountId = acc.Id, Is_Primary__c = true);
        insert con1;
        
        Contact con2 = new Contact(LastName = 'Sharma', AccountId = acc.Id);
        insert con2;
        Test.startTest();
            con2.LastName = 'SharmaJi';
            update con2;
        Test.stopTest();
    }
}