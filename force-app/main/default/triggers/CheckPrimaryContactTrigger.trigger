trigger CheckPrimaryContactTrigger on Contact (before insert,before update) {
    Contact[] contacts=Trigger.new;
    for(Contact c:contacts){

        if(c.Is_Primary__c==true){
           Integer length=[select Id from Contact where AccountId= :c.AccountId and Is_Primary__c=true and Id!=:c.Id].size();
           if(length>0){
               c.Is_Primary__c.addError('Primary contact with given account is already exists.');
           }
          
           }
           else
           {
           Integer length=[select Id from Contact where AccountId= :c.AccountId and Is_Primary__c=true].size();
           if(length<1){
               c.Is_Primary__c=true;
           }
        }
    }
}