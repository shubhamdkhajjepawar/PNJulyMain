trigger UpdateDefaultsTrigger on Quote (before insert,before update) {

    //Quotes that are going to be inserted.
    Quote[] quotes=Trigger.new;
    
    Id opportunityId=quotes[0].OpportunityId;
    
    Contact currentContact = ContactHelper.getPrimaryContactByAccount([select Id,AccountId from Opportunity where Id= :opportunityId].AccountId);
    
    for(Quote q:quotes){
    if (Trigger.isInsert)
    {
    if(currentContact!=null)
    {
        if(q.ContactId==null)
        {
            q.ContactId=currentContact.Id;
        }
        if(q.Email==null)
        {
            q.Email=currentContact.Email;
        }
        if(q.Phone==null)
        {
            q.Phone=currentContact.Phone;
        }
       }
        }
        if(q.Product_i_Price1__c!=null || q.Ocean_Freight_Price1__c!=null)
        {
        q.Product_Price_1__c=(q.Product_i_Price1__c==null?0:q.Product_i_Price1__c)+(q.Ocean_Freight_Price1__c==null?0:q.Ocean_Freight_Price1__c);
        }
        else
        {
        q.Product_Price_1__c=null;
        }
        if(q.Product_i_Price2__c!=null || q.Ocean_Freight_Price2__c!=null)
        {
        q.Product_Price_2__c=(q.Product_i_Price2__c==null?0:q.Product_i_Price2__c)+(q.Ocean_Freight_Price2__c==null?0:q.Ocean_Freight_Price2__c);
        }
        else
        {
        q.Product_Price_2__c=null;
        }
        if(q.Product_i_Price3__c!=null || q.Ocean_Freight_Price3__c!=null)
        {
        q.Product_Price_3__c=(q.Product_i_Price3__c==null?0:q.Product_i_Price3__c)+(q.Ocean_Freight_Price3__c==null?0:q.Ocean_Freight_Price3__c);
        }
        else
        {
        q.Product_Price_3__c=null;
        }
        if(q.Product_i_Price4__c!=null || q.Ocean_Freight_Price4__c!=null)
        {
        q.Product_Price_4__c=(q.Product_i_Price4__c==null?0:q.Product_i_Price4__c)+(q.Ocean_Freight_Price4__c==null?0:q.Ocean_Freight_Price4__c);
        }
        else
        {
        q.Product_Price_4__c=null;
        }
   
        
        //International Price One
        
        /*
        if(q.Total_Quantity_1__c!=null && q.Additional_Charge_s_1__c==null)
        {
            q.Additional_Charge_s_1__c=0;
        }
        if(q.Total_Quantity_1__c!=null && q.Additional_Charge_s_1__c!=null)
        {
            q.Product_Price_1__c= q.Product_Price_1__c!=null?q.Product_Price_1__c:0;
            q.Tax=q.Tax!=null?q.Tax:0;
            q.Grd_Freight_1__c=q.Grd_Freight_1__c!=null?q.Grd_Freight_1__c: 0;
            q.Expedited_Freight_1__c=q.Expedited_Freight_1__c!=null?q.Expedited_Freight_1__c:0;
            
        }
        if(q.Total_Quantity_1__c==null)
        {
           // q.Additional_Charge_s_1__c=q.Additional_Charge_s_1__c==0?null:q.Additional_Charge_s_1__c;
       }
        //
       
        //International Price Two
        if(q.Total_Quantity_2__c!=null && q.Additional_Charge_s_2__c==null)
        {
            q.Additional_Charge_s_2__c=0;
        }
        if(q.Total_Quantity_2__c!=null && q.Additional_Charge_s_2__c!=null)
        {
            q.Product_Price_2__c= q.Product_Price_2__c!=null?q.Product_Price_2__c:0;
            q.Tax_2__c=q.Tax_2__c!=null?q.Tax_2__c:0;
            q.Grd_Freight_2__c=q.Grd_Freight_2__c!=null?q.Grd_Freight_2__c: 0;
            q.Expedited_Freight_2__c=q.Expedited_Freight_2__c!=null?q.Expedited_Freight_2__c:0;
        }
        if(q.Total_Quantity_2__c==null)
        {
            q.Additional_Charge_s_2__c=q.Additional_Charge_s_2__c==0?null:q.Additional_Charge_s_2__c;
        }
        //
        //International Price Three
        if(q.Total_Quantity_3__c!=null && q.Additional_Charge_s_3__c==null)
        {
            q.Additional_Charge_s_3__c=0;
        }
        if(q.Total_Quantity_3__c!=null && q.Additional_Charge_s_3__c!=null)
        {
            q.Product_Price_3__c= q.Product_Price_3__c!=null?q.Product_Price_3__c:0;
            q.Tax_3__c=q.Tax_3__c!=null?q.Tax_3__c:0;
            q.Grd_Freight_3__c=q.Grd_Freight_3__c!=null?q.Grd_Freight_3__c: 0;
            q.Expedited_Freight_3__c=q.Expedited_Freight_3__c!=null?q.Expedited_Freight_3__c:0;
        }
        if(q.Total_Quantity_3__c==null)
        {
            q.Additional_Charge_s_3__c=q.Additional_Charge_s_3__c==0?null:q.Additional_Charge_s_3__c;
        }
        //
        //International Price Four
        if(q.Total_Quantity_4__c!=null && q.Additional_Charge_s_4__c==null)
        {
            q.Additional_Charge_s_4__c=0;
        }
        if(q.Total_Quantity_4__c!=null && q.Additional_Charge_s_4__c!=null)
        {
            q.Product_Price_4__c= q.Product_Price_4__c!=null?q.Product_Price_4__c:0;
            q.Tax_4__c=q.Tax_4__c!=null?q.Tax_4__c:0;
            q.Grd_Freight_4__c=q.Grd_Freight_4__c!=null?q.Grd_Freight_4__c: 0;
            q.Expedited_Freight_4__c=q.Expedited_Freight_4__c!=null?q.Expedited_Freight_4__c:0;
        }
        if(q.Total_Quantity_4__c==null)
        {
            q.Additional_Charge_s_4__c=q.Additional_Charge_s_4__c==0?null:q.Additional_Charge_s_4__c;
        }
       
        
        if(q.Total_Quantity_11__c!=null && q.Additional_Charge_s_11__c==null)
        {
            q.Additional_Charge_s_11__c=0;
        }
        if(q.Total_Quantity_11__c!=null && q.Additional_Charge_s_11__c!=null)
        {        
            q.Tax_11__c=q.Tax_11__c!=null?q.Tax_11__c:0;
            q.Dom_Purch_Price_11__c=q.Dom_Purch_Price_11__c!=null?q.Dom_Purch_Price_11__c:0;
            q.Dom_Vendor_s_Freight_Charge_11__c=q.Dom_Vendor_s_Freight_Charge_11__c!=null?q.Dom_Vendor_s_Freight_Charge_11__c:0;
            q.Domestic_Markup_11__c=q.Domestic_Markup_11__c!=null ?q.Domestic_Markup_11__c:0;
        }
        if(q.Total_Quantity_11__c==null)
        {
            q.Additional_Charge_s_11__c=q.Additional_Charge_s_11__c==0?null:q.Additional_Charge_s_11__c;
        }
       
        if(q.Total_Quantity_12__c!=null && q.Additional_Charge_s_12__c==null)
        {
            q.Additional_Charge_s_12__c=0;
        }
        if(q.Total_Quantity_12__c!=null && q.Additional_Charge_s_12__c!=null)
        { 
            q.Tax_12__c=q.Tax_12__c!=null?q.Tax_12__c:0;
            q.Dom_Purch_Price_12__c=q.Dom_Purch_Price_12__c!=null?q.Dom_Purch_Price_12__c:0;
            q.Dom_Vendor_s_Freight_Charge_12__c=q.Dom_Vendor_s_Freight_Charge_12__c!=null?q.Dom_Vendor_s_Freight_Charge_12__c:0;
            q.Domestic_Markup_12__c=q.Domestic_Markup_12__c!=null?q.Domestic_Markup_12__c:0;
        }
        if(q.Total_Quantity_12__c==null)
        {
            q.Additional_Charge_s_12__c=q.Additional_Charge_s_12__c==0?null:q.Additional_Charge_s_12__c;
        }
       
        if(q.Total_Quantity_13__c!=null && q.Additional_Charge_s_13__c==null)
        {
            q.Additional_Charge_s_13__c=0;
        }
        if(q.Total_Quantity_13__c!=null && q.Additional_Charge_s_13__c!=null)
        {
            q.Tax_13__c=q.Tax_13__c!=null?q.Tax_13__c:0; 
            q.Dom_Purch_Price_13__c=q.Dom_Purch_Price_13__c!=null?q.Dom_Purch_Price_13__c:0;
            q.Dom_Vendor_s_Freight_Charge_13__c=q.Dom_Vendor_s_Freight_Charge_13__c!=null?q.Dom_Vendor_s_Freight_Charge_13__c:0;
            q.Domestic_Markup_13__c=q.Domestic_Markup_13__c!=null?q.Domestic_Markup_13__c:0;
        }
        if(q.Total_Quantity_13__c==null)
        {
            q.Additional_Charge_s_13__c=q.Additional_Charge_s_13__c==0?null:q.Additional_Charge_s_13__c;
        }
       
        if(q.Total_Quantity_14__c!=null && q.Additional_Charge_s_14__c==null)
        {
            q.Additional_Charge_s_14__c=0;
        }
        if(q.Total_Quantity_14__c!=null && q.Additional_Charge_s_14__c!=null)
        {
            q.Tax_14__c=q.Tax_14__c!=null?q.Tax_14__c:0;
            q.Dom_Purch_Price_14__c=q.Dom_Purch_Price_14__c!=null?q.Dom_Purch_Price_14__c:0;
            q.Dom_Vendor_s_Freight_Charge_14__c=q.Dom_Vendor_s_Freight_Charge_14__c!=null?q.Dom_Vendor_s_Freight_Charge_14__c:0;
            q.Domestic_Markup_14__c=q.Domestic_Markup_14__c!=null?q.Domestic_Markup_14__c:0;
        }
        if(q.Total_Quantity_14__c==null)
        {
            q.Additional_Charge_s_14__c=q.Additional_Charge_s_14__c==0?null:q.Additional_Charge_s_14__c;
        }
        */

    }
}