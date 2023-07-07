public with sharing class ContactTriggerHandler {
    /**
     * Method called on After insert
     */
    public static void onAfterInsert(list<Contact> newRecords) {
        checkPrimaryContact(newRecords);
    }
    
    /**
     * Method called on After update
     */
    public static void onAfterUpdate(list<Contact> newRecords, map<Id, Contact> oldRecordMap) {
        checkPrimaryContact(newRecords);
    }
    
    //Method to CheckPrimaryContactTrigger 
    public static void checkPrimaryContact(list<Contact> records) {
        set<string> setAccountIds = new set<string>();
        set<string> setContactIds = new set<string>();
        for(Contact con: records){
            if(con.Is_Primary__c && con.AccountId != null){
                setAccountIds.add(con.AccountId);
                setContactIds.add(con.Id);
            }
        }
        
        list<Contact> contactToUpdate = new list<Contact>();
        for(Contact c: [SELECT Id, Is_Primary__c FROM Contact WHERE Id NOT IN : setContactIds AND AccountId IN: setAccountIds AND Is_Primary__c = true]){
            c.Is_Primary__c = false;
            contactToUpdate.add(c);
        }
        
        if(contactToUpdate.size() > 0){
            Constants.CHECKPRIMARYCONTACTTRIGGER = true;
            update contactToUpdate;
        }
    }
}