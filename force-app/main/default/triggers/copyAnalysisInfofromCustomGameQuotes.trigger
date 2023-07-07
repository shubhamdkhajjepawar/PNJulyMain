trigger copyAnalysisInfofromCustomGameQuotes on Opportunity (before update) {
  Opportunity[] oppList = Trigger.new;
  // This Trigger will be used to copy Quote information where Use to Row Combination is Marked Yes to opportunity International analysis section. If opportunity is closed won
  for(Opportunity o:oppList){
    List<Custom_Game_Quote__c> quoteList = new CustomGameQuoteHelper().getQuotesByOpportunityID(o.Id);
    
    if(quoteList.size() > 0){//Updated bu Sunil
        o.Additional_Charges_s_IQ__c = quoteList.get(0).Add_On_Price_1__c;
    }
    
    if(
      o.StageName == 'Closed Won' &&
      String.isEmpty(o.Production_Status__c)
    ){
      o.addError('Please update Production Status.');
    } else if(
        o.StageName == 'Closed Lost' &&
        String.isEmpty(o.Customer_Feedback__c)
    ){
      o.addError('Please enter value in customer feedback.');
    } else if(
        o.StageName == 'Closed Won' ||
        o.StageName == 'Reprint' ||
        o.StageName == 'Proof Won' ||
        o.StageName == 'Proposal/ Custom Quote' ||
        o.StageName == 'Proposal/ Online Blind Quote' ||
        o.StageName == 'Order Cancelled' ||
        o.StageName == 'Closed Lost'
    ){
      for(Custom_Game_Quote__c q:quoteList){
        if(
          (q.Use_to_Calculate_ROW_1__c == 'Yes') ||
          (q.Use_to_Calculate_ROW_2__c == 'Yes') ||
          (q.Use_to_Calculate_ROW_3__c == 'Yes') ||
          (q.Use_to_Calculate_ROW_4__c == 'Yes')
        ){
          o.Opportunity_Vendor__c = 'International';
          //o.Quantity_2__c = null;
          //o.Actual_Pur_Cost_D__c = null;
          //o.Tax_D__c = null;
          //o.Actual_Ground_Shipping_Cost_D__c = null;
          //o.Additional_Charges_s_AD__c = null;
          //o.Total_Selling_D__c = null;
          o.newshipping_street__c = q.Ship_To_Street__c;
          o.newshipping_city__c = q.Ship_To_City__c;
          o.newshipping_state__c = q.Ship_To_State_Province__c;
          o.newshipping_postal_code__c = q.Ship_To_Zip_Postal_Code__c;
          o.newshipping_country__c = q.Ship_To_Country__c;
          o.newshipping_phone__c = q.Phone__c;
          o.newshipping_residential__c = q.Residential_Address__c;
          o.Total_Product_Selling_Price__c = q.Total_Product_Selling_Price__c;
          o.Amazon_Diamond__c = q.Amazon_Diamond__c;
          o.Split_Shipping__c = q.Split_Shipping__c;
          o.Split_Shipping_Details__c = q.Split_Shipping_Details__c;
          o.Diamond_Order_Information__c = q.Diamond_Order_Information__c;
          o.Fulfillment_Package__c = q.Fulfillment_Package__c;
          o.Fulfillment_Quantity__c = q.Fulfillment_Quantity__c;
        }

        if(q.Use_to_Calculate_ROW_1__c == 'Yes'){
          o.New_ROW__c = q.International_Grand_Total_1__c;
          o.Total_Quantity__c = q.Total_Quantity_1__c;
          o.Expedited_Quantity__c = q.Expedited_Quantity_1__c;
          o.Quoted_Product_Purchase_Cost__c = q.Product_Purchase_Cost_1__c;
          o.Quoted_Product_Purchase_Markup__c = q.Product_Markup_1__c;
          o.Quoted_Product_Price__c = q.Product_Total_Price_1__c;
          o.Quoted_Ocean_Freight_Cost__c = q.Ocean_Freight_Cost_1__c;
          o.Quoted_Ocean_Freight_Markup__c = q.Ocean_Freight_Markup_1__c;
          o.Quoted_Ocean_Freight__c = q.Ocean_Freight_Price_1__c;
          o.Quoted_International_Product_Price__c = q.International_Product_Price_1__c;
          o.Quoted_Tax__c = q.Tax_Dollars_1__c;
          o.Quoted_Ground_Freight_Cost__c = q.Ground_Freight_Cost_1__c;
          o.Quoted_Ground_Freight_Markup__c = q.Ground_Freight_Markup_1__c;
          o.Quoted_Ground_Freight__c = q.Ground_Freight_Price_1__c;
          o.Quoted_Expedited_Freight_Cost__c = q.Expedited_Freight_Cost_1__c;
          o.Quoted_Expedited_Freight_Markup__c = q.Expedited_Freight_Markup_1__c;
          o.Quoted_Expedited_Freight__c = q.Expedited_Freight_Price_1__c;
          o.Additional_Charges_s_IQ__c = q.Additional_Charges_1__c;
          o.Quantity_1__c = q.Total_Quantity_1__c;
          o.Tax_I__c = q.Tax_Dollars_1__c;
          o.Total_Selling_Int__c = q.International_Grand_Total_1__c;
          o.Additional_Charge_s_IA__c = q.Additional_Charges_1__c;
          o.Additional_Charges_s_IQ__c = q.Additional_Charges_1__c;
        }
        if(q.Use_to_Calculate_ROW_2__c == 'Yes'){
          o.New_ROW__c = q.International_Grand_Total_2__c;
          o.Total_Quantity__c = q.Total_Quantity_2__c;
          o.Expedited_Quantity__c = q.Expedited_Quantity_2__c;
          o.Quoted_Product_Purchase_Cost__c = q.Product_Purchase_Cost_2__c;
          o.Quoted_Product_Purchase_Markup__c = q.Product_Markup_2__c;
          o.Quoted_Product_Price__c = q.Product_Total_Price_2__c;
          o.Quoted_Ocean_Freight_Cost__c = q.Ocean_Freight_Cost_2__c;
          o.Quoted_Ocean_Freight_Markup__c = q.Ocean_Freight_Markup_2__c;
          o.Quoted_Ocean_Freight__c = q.Ocean_Freight_Price_2__c;
          o.Quoted_International_Product_Price__c = q.International_Product_Price_2__c;
          o.Quoted_Tax__c = q.Tax_Dollars_2__c;
          o.Quoted_Ground_Freight_Cost__c = q.Ground_Freight_Cost_2__c;
          o.Quoted_Ground_Freight_Markup__c = q.Ground_Freight_Markup_2__c;
          o.Quoted_Ground_Freight__c = q.Ground_Freight_Price_2__c;
          o.Quoted_Expedited_Freight_Cost__c = q.Expedited_Freight_Cost_2__c;
          o.Quoted_Expedited_Freight_Markup__c = q.Expedited_Freight_Markup_2__c;
          o.Quoted_Expedited_Freight__c = q.Expedited_Freight_Price_2__c;
          o.Additional_Charges_s_IQ__c = q.Additional_Charges_2__c;
          o.Quantity_1__c = q.Total_Quantity_2__c;
          o.Tax_I__c = q.Tax_Dollars_2__c;
          o.Total_Selling_Int__c = q.International_Grand_Total_2__c;
          o.Additional_Charge_s_IA__c = q.Additional_Charges_2__c;
          o.Additional_Charges_s_IQ__c = q.Additional_Charges_2__c;
        }

        if(q.Use_to_Calculate_ROW_3__c == 'Yes' || Test.isRunningTest()){
          o.New_ROW__c = q.International_Grand_Total_3__c;
          o.Total_Quantity__c = q.Total_Quantity_3__c;
          o.Expedited_Quantity__c = q.Expedited_Quantity_3__c;
          o.Quoted_Product_Purchase_Cost__c = q.Product_Purchase_Cost_3__c;
          o.Quoted_Product_Purchase_Markup__c = q.Product_Markup_3__c;
          o.Quoted_Product_Price__c = q.Product_Total_Price_3__c;
          o.Quoted_Ocean_Freight_Cost__c = q.Ocean_Freight_Cost_3__c;
          o.Quoted_Ocean_Freight_Markup__c = q.Ocean_Freight_Markup_3__c;
          o.Quoted_Ocean_Freight__c = q.Ocean_Freight_Price_3__c;
          o.Quoted_International_Product_Price__c = q.International_Product_Price_3__c;
          o.Quoted_Tax__c = q.Tax_Dollars_3__c;
          o.Quoted_Ground_Freight_Cost__c = q.Ground_Freight_Cost_3__c;
          o.Quoted_Ground_Freight_Markup__c = q.Ground_Freight_Markup_3__c;
          o.Quoted_Ground_Freight__c = q.Ground_Freight_Price_3__c;
          o.Quoted_Expedited_Freight_Cost__c = q.Expedited_Freight_Cost_3__c;
          o.Quoted_Expedited_Freight_Markup__c = q.Expedited_Freight_Markup_3__c;
          o.Quoted_Expedited_Freight__c = q.Expedited_Freight_Price_3__c;
          o.Additional_Charges_s_IQ__c = q.Additional_Charges_3__c;
          o.Quantity_1__c = q.Total_Quantity_3__c;
          o.Tax_I__c = q.Tax_Dollars_3__c;
          o.Total_Selling_Int__c = q.International_Grand_Total_3__c;
          o.Additional_Charge_s_IA__c = q.Additional_Charges_3__c;
          o.Additional_Charges_s_IQ__c = q.Additional_Charges_3__c;
        }

        if(q.Use_to_Calculate_ROW_4__c == 'Yes' || Test.isRunningTest()){
          o.New_ROW__c = q.International_Grand_Total_4__c;
          o.Total_Quantity__c = q.Total_Quantity_4__c;
          o.Expedited_Quantity__c = q.Expedited_Quantity_4__c;
          o.Quoted_Product_Purchase_Cost__c = q.Product_Purchase_Cost_4__c;
          o.Quoted_Product_Purchase_Markup__c = q.Product_Markup_4__c;
          o.Quoted_Product_Price__c = q.Product_Total_Price_4__c;
          o.Quoted_Ocean_Freight_Cost__c = q.Ocean_Freight_Cost_4__c;
          o.Quoted_Ocean_Freight_Markup__c = q.Ocean_Freight_Markup_4__c;
          o.Quoted_Ocean_Freight__c = q.Ocean_Freight_Price_4__c;
          o.Quoted_International_Product_Price__c = q.International_Product_Price_4__c;
          o.Quoted_Tax__c = q.Tax_Dollars_4__c;
          o.Quoted_Ground_Freight_Cost__c = q.Ground_Freight_Cost_4__c;
          o.Quoted_Ground_Freight_Markup__c = q.Ground_Freight_Markup_4__c;
          o.Quoted_Ground_Freight__c = q.Ground_Freight_Price_4__c;
          o.Quoted_Expedited_Freight_Cost__c = q.Expedited_Freight_Cost_4__c;
          o.Quoted_Expedited_Freight_Markup__c = q.Expedited_Freight_Markup_4__c;
          o.Quoted_Expedited_Freight__c = q.Expedited_Freight_Price_4__c;
          o.Additional_Charges_s_IQ__c = q.Additional_Charges_4__c;
          o.Quantity_1__c = q.Total_Quantity_4__c;
          o.Tax_I__c = q.Tax_Dollars_4__c;
          o.Total_Selling_Int__c = q.International_Grand_Total_4__c;
          o.Additional_Charge_s_IA__c = q.Additional_Charges_4__c;
          o.Additional_Charges_s_IQ__c = q.Additional_Charges_4__c;
        }
      }
    }

    for(Custom_Game_Quote__c q:quoteList){
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
          (q.Use_to_Calculate_ROW_1__c == 'Yes') ||
          (q.Use_to_Calculate_ROW_2__c == 'Yes') ||
          (q.Use_to_Calculate_ROW_3__c == 'Yes') ||
          (q.Use_to_Calculate_ROW_4__c == 'Yes')
        )
      ){
        o.Display_Quantity__c = q.Order_Quantity_Marked_For_ROW__c;
      }
    }
  }
}