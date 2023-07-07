trigger copyAnalysisInfofromGameQuotes on Opportunity (before update) {
  Opportunity[] oppList = Trigger.new;
  // This Trigger will be used to copy Quote information where Use to Row Combination is Marked Yes to opportunity International analysis section. If opportunity is closed won
  for(Opportunity o:oppList){
    List<Game_Quote__c> quoteList = new GameQuoteHelper().getQuotesByOpportunityID(o.Id);
    
    if(
      o.StageName == 'Closed Won' ||
      o.StageName == 'Reprint' ||
      o.StageName == 'Proof Won' ||
      o.StageName == 'Proposal/ Custom Quote' ||
      o.StageName == 'Proposal/ Online Blind Quote' ||
      o.StageName == 'Order Cancelled' ||
      o.StageName == 'Closed Lost'
    ){
      for(Game_Quote__c q:quoteList){
        if(
          (q.Use_to_Calculate_ROW_1__c == 'Yes') ||
          (q.Use_to_Calculate_ROW_2__c == 'Yes')
        ){
          o.Opportunity_Vendor__c = 'International';
          //o.Quantity_2__c = null;
          //o.Actual_Pur_Cost_D__c = null;
          //o.Tax_D__c = null;
          //o.Actual_Ground_Shipping_Cost_D__c = null;
          //o.Additional_Charges_s_AD__c = null;
          //o.Total_Selling_D__c = null;
          o.newshipping_street__c = q.gq_shiptostreet__c;
          o.newshipping_city__c = q.gq_shiptocity__c;
          o.newshipping_state__c = q.gq_shiptostate__c;
          o.newshipping_postal_code__c = q.gq_shiptozip__c;
          o.newshipping_country__c = q.gq_shiptocountry__c;
          o.newshipping_phone__c = q.Phone__c;
          o.newshipping_residential__c = q.newshipping_residential__c;
          o.Amazon_Diamond__c = q.Amazon_Diamond__c;
        }

        if(q.Use_to_Calculate_ROW_1__c == 'Yes'){
          o.Display_Quantity__c = q.Display_Quantity_1__c;
          o.Total_Quantity__c = q.Total_Quantity_1__c;
          o.NEW_ROW__c = q.International_Grand_Total_1__c;
          o.Expedited_Quantity__c = q.Expedited_Quantity_1__c;
          o.Quoted_Product_Purchase_Cost__c = q.Product_Purchase_Cost1__c;
          o.Quoted_Product_Purchase_Markup__c = q.Product_Purchase_Markup1__c;
          o.Quoted_Product_Price__c = q.Product_Price_1__c + q.Assembly_Cost_1__c;
          o.Quoted_Ocean_Freight_Cost__c = q.Ocean_Freight_1__c;
          o.Quoted_Ocean_Freight_Markup__c = q.Ocean_Freight_Markup_i1__c;
          o.Quoted_Ocean_Freight__c = q.Ocean_Freight_Price1__c;
          o.Quoted_International_Product_Price__c = q.Product_Price_1__c + q.Assembly_Cost_1__c;
          o.Quoted_Tax__c = q.Tax_1__c;
          o.Quoted_Ground_Freight_Cost__c = q.Grd_Freight_1__c;
          o.Quoted_Ground_Freight_Markup__c = q.Ground_Freight_Markup_i1__c;
          o.Quoted_Ground_Freight__c = q.Ground_Freight_Price1__c;
          o.Quoted_Expedited_Freight_Cost__c = q.Expedited_Freight_1__c;
          o.Quoted_Expedited_Freight_Markup__c = q.Expedited_Freight_Markup_i1__c;
          o.Quoted_Expedited_Freight__c = q.Expedited_Freight_Price1__c;
          o.Additional_Charges_s_IQ__c = q.Additional_charge_s_1__c;
          o.Quantity_1__c = q.Total_Quantity_1__c;
          o.Tax_I__c = q.Tax_1__c;
          o.Total_Selling_Int__c = q.International_Grand_Total_1__c;
          o.Additional_Charge_s_IA__c = q.Additional_charge_s_1__c;
          o.Additional_Charges_s_IQ__c = q.Additional_Charge_s_1__c;
          o.Proofing_Price__c = q.Prototyping_Cost_1__c;
        }

        if(q.Use_to_Calculate_ROW_2__c == 'Yes'){
          o.Display_Quantity__c = q.Display_Quantity_2__c;
          o.Total_Quantity__c = q.Total_Quantity_2__c;
          o.NEW_ROW__c = q.International_Grand_Total_2__c;
          o.Expedited_Quantity__c = q.Expedited_Quantity_2__c;
          o.Quoted_Product_Purchase_Cost__c = q.Product_Purchase_Cost2__c;
          o.Quoted_Product_Purchase_Markup__c = q.Product_Purchase_Markup2__c;
          o.Quoted_Product_Price__c = q.Product_Price_2__c + q.Assembly_Cost_2__c;
          o.Quoted_Ocean_Freight_Cost__c = q.Ocean_Freight_2__c;
          o.Quoted_Ocean_Freight_Markup__c = q.Ocean_Freight_Markup_i2__c;
          o.Quoted_Ocean_Freight__c = q.Ocean_Freight_Price2__c;
          o.Quoted_International_Product_Price__c = q.Product_Price_2__c + q.Assembly_Cost_2__c;
          o.Quoted_Tax__c = q.Tax_2__c;
          o.Quoted_Ground_Freight_Cost__c = q.Grd_Freight_2__c;
          o.Quoted_Ground_Freight_Markup__c = q.Ground_Freight_Markup_i2__c;
          o.Quoted_Ground_Freight__c = q.Ground_Freight_Price2__c;
          o.Quoted_Expedited_Freight_Cost__c = q.Expedited_Freight_2__c;
          o.Quoted_Expedited_Freight_Markup__c = q.Expedited_Freight_Markup_i2__c;
          o.Quoted_Expedited_Freight__c = q.Expedited_Freight_Price2__c;
          o.Additional_Charges_s_IQ__c = q.Additional_charge_s_2__c;
          o.Quantity_1__c = q.Total_Quantity_2__c;
          o.Tax_I__c = q.Tax_2__c;
          o.Total_Selling_Int__c = q.International_Grand_Total_2__c;
          o.Additional_Charge_s_IA__c = q.Additional_charge_s_2__c;
          o.Additional_Charges_s_IQ__c = q.Additional_Charge_s_2__c;
          o.Proofing_Price__c = q.Prototyping_Cost_2__c;
        }

        for(Game_Quote__c g:quoteList){
          // Check for other  fields as well.
          if(
            (
              o.StageName == 'Closed Won' ||
              o.StageName == 'Reprint' ||
              o.StageName == 'Proof Won' ||
              o.StageName == 'Proposal/ Custom Quote' ||
              o.StageName == 'Proposal/ Online Blind Quote' ||
              o.StageName == 'Order Cancelled' ||
              o.StageName == 'Closed Lost'
            ) && (
              (g.Use_to_Calculate_ROW_1__c == 'Yes') ||
              (g.Use_to_Calculate_ROW_2__c == 'Yes')
            )
          ){
            o.newshipping_liftgate__c = g.newshipping_liftgate__c;
          }
        }
      }
    }
  }
}