public class ReorderButtonController {
   private Opportunity opportunity;
   static String theQuery;  
   public string Message='';
   public ReorderButtonController(ApexPages.StandardController controller) {
     Map<String, Schema.SObjectField> fldObjMap = schema.SObjectType.Opportunity.fields.getMap();
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
         theQuery+=' from Opportunity where Id=\''+ApexPages.currentPage().getParameters().get('id')+'\'';
        this.opportunity=Database.query(theQuery);
     
    }
    public PageReference autoRun() {
  //        try
  //        {
        Opportunity newOpportunity=new Opportunity();
        newOpportunity.Name=this.opportunity.Name + ' Reorder';
        newOpportunity.AccountId=this.opportunity.AccountId;
        newOpportunity.Opportunity_Vendor__c=this.opportunity.Opportunity_Vendor__c;
        newOpportunity.StageName='Draft';
        newOpportunity.Product__c=this.opportunity.Product__c;
        newOpportunity.CloseDate=Date.today().addDays(30) ;
        
        insert newOpportunity;
    //    Database.SaveResult[] results= Database.insert(new SObject[]{newOpportunity});
            
        Quote reQuote=new Quote(
            OpportunityId=newOpportunity.Id,
            Quoted_Created__c=Date.today(),
            Name=newOpportunity.Name,
            ShippingStreet=this.opportunity.newshipping_street__c,
            ShippingCity=this.opportunity.newshipping_city__c,
            ShippingState=this.opportunity.newshipping_state__c,
            ShippingCountry=this.opportunity.newshipping_country__c,
            ShippingPostalCode=this.opportunity.newshipping_postal_code__c,
            Phone=this.opportunity.newshipping_phone__c,
            PRN_additionalinfo__c=this.opportunity.PRN_additionalinfo__c,
            //PRN_basicembossdeboss__c=this.opportunity.PRN_basicembossdeboss__c,//PG 02/16/2023 - removed per direction from Jeff
            //PRN_basicfoilstamping__c=this.opportunity.PRN_basicfoilstamping__c,//PG 02/16/2023 - removed per direction from Jeff
            PRN_bindingtype__c=this.opportunity.PRN_bindingtype__c,
            PRN_corners__c=this.opportunity.PRN_corners__c,
            PRN_coverpapercoating__c=this.opportunity.PRN_coverpapercoating__c,
            PRN_coverpaperfinishstyle__c=this.opportunity.PRN_coverpaperfinishstyle__c,
            PRN_coverpaperfinishtype__c=this.opportunity.PRN_coverpaperfinishtype__c,
            PRN_coverpaperweight__c=this.opportunity.PRN_coverpaperweight__c,
            PRN_dustjacket__c=this.opportunity.PRN_dustjacket__c,
            PRN_dustjacketfinishstyle__c=this.opportunity.PRN_dustjacketfinishstyle__c,
            PRN_endsheets__c=this.opportunity.PRN_endsheets__c,
            PRN_headtailbands__c=this.opportunity.PRN_headtailbands__c,
            PRN_height__c=this.opportunity.PRN_height__c,
            PRN_insidepagecount__c=this.opportunity.PRN_insidepagecount__c,
            PRN_insidepapercoating__c=this.opportunity.PRN_insidepapercoating__c,
            PRN_insidepaperweight__c=this.opportunity.PRN_insidepaperweight__c,
            PRN_printingcolor__c=this.opportunity.PRN_printingcolor__c,
            PRN_printoninsidecoversendsheets__c=this.opportunity.PRN_printoninsidecoversendsheets__c,
            PRN_proofing__c=this.opportunity.PRN_proofing__c,
            //PRN_spotuv__c=this.opportunity.PRN_spotuv__c,//PG 02/16/2023 - removed per direction from Jeff
            PRN_width__c=this.opportunity.PRN_width__c,
            Display_Quantity_1__c=this.opportunity.Display_Quantity__c,
            Use_to_Calculate_ROW_1__c='Yes',
            Expedited_Quantity_1__c=this.opportunity.Expedited_Quantity__c
            );
            
       insert reQuote;
        
        PageReference pageRef = new PageReference('/' + String.valueof(newOpportunity.Id));
        pageRef.setRedirect(true);
        return pageRef;
        
    }
}
       // Database.SaveResult[] quoteresults= Database.insert(new SObject[]{reQuote});
                     
       // Check results.
/*        for (Integer i = 0; i < results.size(); i++) {
        if (results[i].isSuccess()) {
        Message=results[i].getId();
        }
        else
        {
        Message=results[i].getErrors()[0].getMessage();
        }
        }
           PageReference p=new PageReference('/'+String.valueof(newOpportunity.Id));
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
*/