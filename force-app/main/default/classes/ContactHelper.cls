public with sharing class ContactHelper{
    public static Contact getPrimaryContactByAccount(ID accId){
        Integer totalContact=[select Id from Contact where AccountId= :accId].size();
        if(totalContact>1){
           return [select Id,Email,Phone,FirstName,LastName from Contact where AccountId= :accId and Is_Primary__c=true limit 1];
        }else{
           return [select Id,Email,Phone,FirstName,LastName from Contact where AccountId= :accId  limit 1];
        }
    }
}