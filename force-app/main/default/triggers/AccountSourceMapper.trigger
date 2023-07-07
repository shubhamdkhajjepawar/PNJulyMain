trigger AccountSourceMapper on Account (before insert) {
    for(Account a:Trigger.new){
        if(a.AccountSource==null){
         a.AccountSource=a.Account_Source_Mapper__c;
        }
        if(a.Email__c ==null)
        {
            a.Email__c = a.Email_Mapper__c;
        }
    }
}