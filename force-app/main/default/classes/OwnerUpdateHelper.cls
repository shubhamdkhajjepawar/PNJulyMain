/*
 * Helper class for 'OwnerUpdate' trigger.
 */
public with sharing class OwnerUpdateHelper {
	public static List<sObject> newRecords;
	public static List<sObject> oldRecords;
	public static Map<Id, sObject> newMapRecords;
	public static Map<Id, sObject> oldMapRecords;
	
	// Method used update the owner for sobject passed in parameter.
	public static void updateOwner( String sObjectName ) {
		List<sObject> sObjectListToUpdate = new List<sObject>();
	    Map<Id,sObject> sObjectMap = new Map<Id,sObject>();
	    List<Id> sObjIdList = new List<Id>();
	    
	    for (sObject sObj : newRecords)
	    {
	    	// Assignment condition:
            if(sObj.get('TempOwnerId__c') != null && sObj.get('TempOwnerId__c') != '') {
                if(sObj.get('OwnerId') != sObj.get('TempOwnerId__c')) {
                    sObjectMap.put( sObj.id, sObj );
                    sObjIdList.add(sObj.id);
                }
            }
	    }
	    
	    if (sObjectMap.isEmpty()) return;
	    
	    for (sObject sObj : Database.query('SELECT OwnerId, TempOwnerId__c FROM ' + sObjectName + ' WHERE id in : sObjIdList') ) {
	        sObj.put( 'OwnerId', sObjectMap.get(sObj.Id).get('TempOwnerId__c') );
	        
	        //flag to stop infinite loop upon update
	        sObj.put('TempOwnerId__c', 'SKIP');
	        
	        sObjectListToUpdate.add(sObj);
	    }

	    //Update last assignment for Assignment Group in batch
	    if (sObjectListToUpdate.size() > 0) {
	        try {
	            update sObjectListToUpdate;
	        } catch (Exception e){}
	    }
	}
}