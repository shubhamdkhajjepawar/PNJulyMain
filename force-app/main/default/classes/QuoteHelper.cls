public with sharing class QuoteHelper{

     static String theQuery;     
     public QuoteHelper(){
        Map<String, Schema.SObjectField> fldObjMap = schema.SObjectType.Quote.fields.getMap();
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
     
     public Quote getByOpportunity(ID oppId){
        theQuery+=' from Quote where OpportunityId=\''+oppId+'\'';
        Quote quote=Database.query(theQuery);
        return quote;
     }
     public List<Quote> getQuotesByOpportunityID(ID oppId){
      theQuery+=' from Quote where OpportunityId=\''+oppId+'\'';
        List<Quote> quote=Database.query(theQuery);
        return quote;
     }
     
    
    
}