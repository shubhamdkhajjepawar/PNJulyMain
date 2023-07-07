public with sharing class AccountTriggerHandler {
    /**
     * Method called on before insert
     */
    public static void onBeforeInsert(list<Account> newRecords) {
        for(Account acc : newRecords) {
            if(acc.AccountSource == null){
                acc.AccountSource = acc.Account_Source_Mapper__c;
            }
            if(acc.Email__c == null){
                acc.Email__c = acc.Email_Mapper__c;
            }
        }
    }
}