public with sharing class GameQuoteHelper {

     static String theQuery;     
     public GameQuoteHelper(){
        Map<String, Schema.SObjectField> fldObjMap = schema.SObjectType.Game_Quote__c.fields.getMap();
        List<Schema.SObjectField> fldObjMapValues = fldObjMap.values();
        theQuery = 'SELECT ';
        for(Schema.SObjectField s : fldObjMapValues)
        {
           //String theLabel = s.getDescribe().getLabel(); 
           String theName = s.getDescribe().getName();
           //String theType = s.getDescribe().getType(); 
        
           // Continue building your dynamic query string
           theQuery += theName + ',';
        }
        // Trim last comma
        theQuery = theQuery.subString(0, theQuery.length() - 1);
     }
     
     public Game_Quote__c getByOpportunity(ID oppId){
        theQuery+=' FROM Game_Quote__c WHERE Opportunity__r.ID=\''+oppId+'\'';
        Game_Quote__c quote=Database.query(theQuery);
        return quote;
     }
     public List<Game_Quote__c> getQuotesByOpportunityID(ID oppId){
      theQuery+=' FROM Game_Quote__c WHERE Opportunity__r.ID=\''+oppId+'\'';
        List<Game_Quote__c> quote=Database.query(theQuery);
        return quote;
     }
}