trigger UpdateContactTrigger on Opportunity (before insert,before update) {
    Opportunity[] opportunities=Trigger.new;
    for(Opportunity o:opportunities)
    {
    
        /*if (Trigger.isInsert)
        {
            if(o.Probability==0)
            {
                o.Probability=50;
            }
            Account account_source=[select Id, AccountSource from Account where Id= :o.AccountId limit 1];
            o.Opportunity_Source__c=account_source.AccountSource;
        }*/
        if(o.Contact__c==null)
        {
            Integer totalContacts=[select Id from Contact where AccountId= :o.AccountId].size();
            if(totalContacts>1)
            {
                Contact primaryContact=[select Id from Contact where AccountId= :o.AccountId and Is_Primary__c= true limit 1];
                o.Contact__c=primaryContact.Id;
            }
            else
            {
                if([select Id from Contact where AccountId= :o.AccountId].size()>0)
                {
                    o.Contact__c=[select Id from Contact where AccountId= :o.AccountId limit 1].Id;
                }
            }            
        }
    }
}