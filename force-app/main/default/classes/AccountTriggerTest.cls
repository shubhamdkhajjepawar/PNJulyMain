@isTest(seeAllData=false)
public class AccountTriggerTest{
    public static testMethod void unitTest01(){
        Account acc = new Account(Name = 'MFL');
        Test.startTest();
            insert acc;
        Test.stopTest();
    }
}