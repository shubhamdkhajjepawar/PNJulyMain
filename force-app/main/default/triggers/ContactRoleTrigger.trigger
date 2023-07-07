trigger ContactRoleTrigger on Opportunity (after insert) {

//get the id of all involved accounts
Set<ID> accountIds = new Set<ID>();
for(Opportunity opt:Trigger.New){
    accountIds.add(opt.AccountId);
}

//get all contacts for those accounts
list<Contact> contacts = new list<Contact>();
contacts = [select id, AccountId from Contact where Is_Primary__c = true Limit 5000];

//organize these contacts by account
Map<Id,List<Contact>> contactsByAccount = new Map<ID,List<Contact>>();
for(Contact c:contacts){
    if(contactsByAccount.get(c.AccountId) == null){
        contactsByAccount.put(c.AccountId,new List<Contact>());
    }
    contactsByAccount.get(c.AccountId).add(c);
}
                                          
//create the OpportunityContactRole objects
list<OpportunityContactRole> lstOCR = new list<OpportunityContactRole>();
for(Opportunity opt:Trigger.New){
    if(contactsByAccount.get(opt.AccountId) != null){
        Boolean firstContact = true;
        for(Contact c: contactsByAccount.get(opt.AccountId)){
            OpportunityContactRole ocr = new OpportunityContactRole(OpportunityId=opt.id, ContactId=c.id);
            if(firstContact) {
                ocr.IsPrimary = TRUE;
                firstContact = FALSE;
            }
            lstOCR.add(ocr);
        }
    }
}
insert lstOCR;
}