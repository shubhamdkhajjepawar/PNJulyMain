trigger LockOppOwnerToAcct on Opportunity (before insert) {

 Set<ID> acctIDs = New Set<ID>();
    Map<ID,ID> accToOwner = New Map<ID,ID>();

    for(Opportunity opp : trigger.new){

        acctIDs.add(opp.accountID);

    }

    for(Account a : [Select OwnerID From Account Where ID IN :acctIDs])
        accToOwner.put(a.id,a.ownerID);


    for(Opportunity opp : trigger.new){
        if(accToOwner.containsKey(opp.AccountID))
            opp.OwnerID = accToOwner.get(opp.AccountID);
    }


}