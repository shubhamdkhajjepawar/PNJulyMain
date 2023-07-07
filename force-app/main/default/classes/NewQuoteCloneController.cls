public class NewQuoteCloneController {
    private Quote quote;
   static String theQuery;  
   public string Message='';
    public NewQuoteCloneController(ApexPages.StandardController controller) {
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
         theQuery+=' from Quote where Id=\''+ApexPages.currentPage().getParameters().get('id')+'\'';
        this.quote=Database.query(theQuery);
     
    }
    public PageReference autoRun() {
      try
        {
        Quote newQuote=new Quote();
        newQuote=this.quote;
        newQuote.Id=null;
        newQuote.Quoted_Created__c=Date.today();
        newQuote.Quote_Valid_Until__c=Date.today()+30;
        newQuote.Use_to_Calculate_ROW_1__c='No';
        newQuote.Use_to_Calculate_ROW_2__c='NO';
        newQuote.Use_to_Calculate_ROW_3__c='NO';
        newQuote.Use_to_Calculate_ROW_4__c='NO';
        newQuote.Use_to_Calculate_ROW_11__c='NO';
        newQuote.Use_to_Calculate_ROW_12__c='NO';
        newQuote.Use_to_Calculate_ROW_13__c='NO';
        newQuote.Use_to_Calculate_ROW_14__c='NO';
/*      newQuote.Product_Purchase_Cost1__c=null;
        newQuote.Product_Purchase_Cost2__c=null;
        newQuote.Product_Purchase_Cost3__c=null;
        newQuote.Product_Purchase_Cost4__c=null;
        newQuote.Product_Purchase_Markup1__c=null;
        newQuote.Product_Purchase_Markup2__c=null;
        newQuote.Product_Purchase_Markup3__c=null;
        newQuote.Product_Purchase_Markup4__c=null;
*/      newQuote.Ocean_Freight_1__c=null;
        newQuote.Ocean_Freight_2__c=null;
            newQuote.Ocean_Freight_3__c=null;
            newQuote.Ocean_Freight_4__c=null;
            newQuote.Ocean_Freight_5__c=null;
            newQuote.Ocean_Freight_6__c=null;
            newQuote.Ocean_Freight_Markup_i1__c=null;
            newQuote.Ocean_Freight_Markup_i2__c=null;
            newQuote.Ocean_Freight_Markup_i3__c=null;
            newQuote.Ocean_Freight_Markup_i4__c=null;
/*          newQuote.Tax=null;
            newQuote.Tax_2__c=null;
            newQuote.Tax_3__c=null;
            newQuote.Tax_4__c=null;
*/          newQuote.Grd_Freight_1__c=null;
            newQuote.Grd_Freight_2__c=null;
            newQuote.Grd_Freight_3__c=null;
            newQuote.Grd_Freight_4__c=null;
            newQuote.Ground_Freight_Markup_i1__c=null;
            newQuote.Ground_Freight_Markup_i2__c=null;
            newQuote.Ground_Freight_Markup_i3__c=null;
            newQuote.Ground_Freight_Markup_i4__c=null;
            newQuote.Expedited_Freight_1__c=null;
            newQuote.Expedited_Freight_2__c=null;
            newQuote.Expedited_Freight_3__c=null;
            newQuote.Expedited_Freight_4__c=null;
            newQuote.Expedited_Freight_Markup_i1__c=null;
            newQuote.Expedited_Freight_Markup_i2__c=null;
            newQuote.Expedited_Freight_Markup_i3__c=null;
            newQuote.Expedited_Freight_Markup_i4__c=null;
/*          newQuote.Additional_charge_s_1__c=null;
            newQuote.Additional_charge_s_2__c=null;
            newQuote.Additional_charge_s_3__c=null;
            newQuote.Additional_charge_s_4__c=null;
*/        
     newQuote.Is_Used_To_Calculate_Row__c=false;
       Database.SaveResult[] results= Database.insert(new SObject[]{newQuote});
       // Check results.
        for (Integer i = 0; i < results.size(); i++) {
        if (results[i].isSuccess()) {
        Message=results[i].getId();
        }
        else
        {
        Message=results[i].getErrors()[0].getMessage();
        }
        }
           PageReference p=new PageReference('/'+String.valueof(this.quote.opportunityId));
            p.setRedirect(true);
            return p;
          }
        catch(System.DmlException ex){
        Message=ex.getMessage();
            ApexPages.addMessages(ex);
        }
        return null;
        //  return  null;
       
    }
    public String getGreeting() {
  
     
    return Message;
    }
}