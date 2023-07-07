trigger UpdatePriceTrigger on Opportunity (before update) {
  List<Opportunity> newList = Trigger.new;

  Map<Id, Opportunity> wonOppMap = new Map<Id, Opportunity>();

  // Validate opportunity status
  for(Opportunity opp :newList){
    if(opp.StageName == 'Closed Won'){
      if(String.isEmpty(opp.Production_Status__c)){
        opp.addError('Please update Production Status.');
      } else {
        // If Closed Won and has Production status collect for further processing
        wonOppMap.put(opp.Id, opp);
      }
    } else if(opp.StageName == 'Closed Lost' && String.isEmpty(opp.Customer_Feedback__c)){
      opp.addError('Please enter value in customer feedback.');
    }
  }

  // Retrieve quotes for Closed Won Opportunities
  Map<Id, List<Quote>> oppToQuoteMap = new Map<Id, List<Quote>>();
  for(Quote quote :[
    SELECT Use_to_Calculate_ROW_1__c, Use_to_Calculate_ROW_2__c, Use_to_Calculate_ROW_3__c, Use_to_Calculate_ROW_4__c, 
      Use_to_Calculate_ROW_11__c, Use_to_Calculate_ROW_12__c, Use_to_Calculate_ROW_13__c, Use_to_Calculate_ROW_14__c, 
      Total_Quantity_1__c, International_Grand_Total_1__c, Product_i_Price1__c, Ocean_Freight_Price1__c, 
      Ground_Freight_Price1__c, Tax, Add_On_Price_1__c, Proofing_Price_1__c, Expedited_Freight_Price1__c, 
      Total_Quantity_2__c, International_Grand_Total_2__c, Product_i_Price2__c, Ocean_Freight_Price2__c, 
      Ground_Freight_Price2__c, Tax_2__c, Add_On_Price_2__c, Proofing_Price_2__c, Expedited_Freight_Price2__c, 
      Total_Quantity_3__c, International_Grand_Total_3__c, Product_i_Price3__c, Ocean_Freight_Price3__c, 
      Ground_Freight_Price3__c, Tax_3__c, Add_On_Price_3__c, Proofing_Price_3__c, Expedited_Freight_Price3__c, 
      Total_Quantity_4__c, International_Grand_Total_4__c, Product_i_Price4__c, Ocean_Freight_Price4__c, 
      Ground_Freight_Price4__c, Tax_4__c, Add_On_Price_4__c, Proofing_Price_4__c, Expedited_Freight_Price4__c, 
      Total_Quantity_11__c, Dom_Purch_Price_11__c, Tax_11__c, Domestic_Freight_Charge_11__c, Additional_charge_s_11__c, 
      Domestic_Grand_Total_11__c, Total_Quantity_12__c, Dom_Purch_Price_12__c, Tax_12__c, Domestic_Freight_Charge_12__c, 
      Additional_charge_s_12__c, Domestic_Grand_Total_12__c, Total_Quantity_13__c, Dom_Purch_Price_13__c, Tax_13__c, 
      Domestic_Freight_Charge_13__c, Additional_charge_s_13__c, Domestic_Grand_Total_13__c, Total_Quantity_14__c, 
      Dom_Purch_Price_14__c, Tax_14__c, Domestic_Freight_Charge_14__c, Additional_charge_s_14__c, Domestic_Grand_Total_14__c,
      OpportunityId
    FROM Quote
    WHERE OpportunityId IN :wonOppMap.keySet()
  ]){
    if(!oppToQuoteMap.containsKey(quote.OpportunityId)) oppToQuoteMap.put(quote.OpportunityId, new List<Quote>());
    oppToQuoteMap.get(quote.OpportunityId).add(quote);
  }

  // Iterate over Closed Won Opportunities copying over child Quote information
  for(Id oppId :oppToQuoteMap.keySet()){
    Opportunity opp = wonOppMap.get(oppId);
    for(Quote quote :oppToQuoteMap.get(oppId)){
      if(quote.Use_to_Calculate_ROW_1__c == 'Yes'){
        opp.Opportunity_Vendor__c = 'International';
        opp.Quantity_2__c = null;
        opp.Actual_Pur_Cost_D__c = null;
        opp.Tax_D__c = null;
        opp.Actual_Ground_Shipping_Cost_D__c = null;
        opp.Additional_Charges_s_AD__c = null;
        opp.Total_Selling_D__c = null;   
        opp.Quantity_1__c = quote.Total_Quantity_1__c;
        opp.Tax_I__c = quote.Tax;
        opp.Total_Selling_Int__c = quote.International_Grand_Total_1__c;
        
        opp.Quoted_Product_Price__c = quote.Product_i_Price1__c;
        opp.Quoted_Ocean_Freight__c = quote.Ocean_Freight_Price1__c;
        opp.Quoted_Ground_Freight__c = quote.Ground_Freight_Price1__c;
        opp.Quoted_Tax__c = quote.Tax;
        opp.Additional_Charges_s_IQ__c = quote.Add_On_Price_1__c;
        opp.Proofing_Price__c = quote.Proofing_Price_1__c;
        opp.Quoted_Expedited_Freight__c = quote.Expedited_Freight_Price1__c;                   
      }
        
      if(quote.Use_to_Calculate_ROW_2__c == 'Yes'){
        opp.Opportunity_Vendor__c = 'International';
        opp.Quantity_2__c = null;
        opp.Actual_Pur_Cost_D__c = null;
        opp.Tax_D__c = null;
        opp.Actual_Ground_Shipping_Cost_D__c = null;
        opp.Additional_Charges_s_AD__c = null;
        opp.Total_Selling_D__c = null;  
        opp.Quantity_1__c = quote.Total_Quantity_2__c;
        opp.Tax_I__c = quote.Tax_2__c;
        opp.Total_Selling_Int__c = quote.International_Grand_Total_2__c;
        
        opp.Quoted_Product_Price__c = quote.Product_i_Price2__c;
        opp.Quoted_Ocean_Freight__c = quote.Ocean_Freight_Price2__c;
        opp.Quoted_Ground_Freight__c = quote.Ground_Freight_Price2__c;
        opp.Quoted_Tax__c = quote.Tax_2__c;
        opp.Additional_Charges_s_IQ__c = quote.Add_On_Price_2__c;
        opp.Proofing_Price__c = quote.Proofing_Price_2__c;
        opp.Quoted_Expedited_Freight__c = quote.Expedited_Freight_Price2__c;
      }

      if(quote.Use_to_Calculate_ROW_3__c == 'Yes'){
        opp.Opportunity_Vendor__c = 'International';
        opp.Quantity_2__c = null;
        opp.Actual_Pur_Cost_D__c = null;
        opp.Tax_D__c = null;
        opp.Actual_Ground_Shipping_Cost_D__c = null;
        opp.Additional_Charges_s_AD__c = null;
        opp.Total_Selling_D__c = null;  
        opp.Quantity_1__c = quote.Total_Quantity_3__c;
        opp.Tax_I__c = quote.Tax_3__c;
        opp.Total_Selling_Int__c = quote.International_Grand_Total_3__c;
        
        opp.Quoted_Product_Price__c = quote.Product_i_Price3__c;
        opp.Quoted_Ocean_Freight__c = quote.Ocean_Freight_Price3__c;
        opp.Quoted_Ground_Freight__c = quote.Ground_Freight_Price3__c;
        opp.Quoted_Tax__c = quote.Tax_3__c;
        opp.Additional_Charges_s_IQ__c = quote.Add_On_Price_3__c;
        opp.Proofing_Price__c = quote.Proofing_Price_3__c;
        opp.Quoted_Expedited_Freight__c = quote.Expedited_Freight_Price3__c;
      }

      if(quote.Use_to_Calculate_ROW_4__c == 'Yes'){
        opp.Opportunity_Vendor__c = 'International';
        opp.Quantity_2__c = null;
        opp.Actual_Pur_Cost_D__c = null;
        opp.Tax_D__c = null;
        opp.Actual_Ground_Shipping_Cost_D__c = null;
        opp.Additional_Charges_s_AD__c = null;
        opp.Total_Selling_D__c = null;  
        opp.Quantity_1__c = quote.Total_Quantity_4__c;
        opp.Tax_I__c = quote.Tax_4__c;
        opp.Total_Selling_Int__c = quote.International_Grand_Total_4__c;
        
        opp.Quoted_Product_Price__c = quote.Product_i_Price4__c;
        opp.Quoted_Ocean_Freight__c = quote.Ocean_Freight_Price4__c;
        opp.Quoted_Ground_Freight__c = quote.Ground_Freight_Price4__c;
        opp.Quoted_Tax__c = quote.Tax_4__c;
        opp.Additional_Charges_s_IQ__c = quote.Add_On_Price_4__c;
        opp.Proofing_Price__c = quote.Proofing_Price_4__c;
        opp.Quoted_Expedited_Freight__c = quote.Expedited_Freight_Price4__c;
      }
      
      if(quote.Use_to_Calculate_ROW_11__c == 'Yes'){
        opp.Opportunity_Vendor__c = 'Domestic';
        opp.Quantity_1__c = null;
        opp.Tax_I__c = null;
        opp.Total_Selling_Int__c = null; 
        opp.Quoted_Product_Price__c = null;
        opp.Quoted_Ocean_Freight__c = null;
        opp.Quoted_Ground_Freight__c = null;
        opp.Quoted_Tax__c = null;
        opp.Additional_Charges_s_IQ__c = null;
        opp.Quoted_Expedited_Freight__c = null;
        opp.Quantity_2__c = quote.Total_Quantity_11__c;
        opp.Actual_Pur_Cost_D__c = quote.Dom_Purch_Price_11__c;
        opp.Tax_D__c = quote.Tax_11__c;
        opp.Actual_Ground_Shipping_Cost_D__c = quote.Domestic_Freight_Charge_11__c;
        opp.Additional_Charges_s_AD__c = quote.Additional_charge_s_11__c;
        opp.Total_Selling_D__c = quote.Domestic_Grand_Total_11__c;   
      }

      if(quote.Use_to_Calculate_ROW_12__c == 'Yes'){
        opp.Opportunity_Vendor__c = 'Domestic';
        opp.Quantity_1__c = null;
        opp.Tax_I__c = null;
        opp.Total_Selling_Int__c = null; 
        opp.Quoted_Product_Price__c = null;
        opp.Quoted_Ocean_Freight__c = null;
        opp.Quoted_Ground_Freight__c = null;
        opp.Quoted_Tax__c = null;
        opp.Additional_Charges_s_IQ__c = null;
        opp.Quoted_Expedited_Freight__c = null;
        opp.Quantity_2__c = quote.Total_Quantity_12__c;
        opp.Actual_Pur_Cost_D__c = quote.Dom_Purch_Price_12__c;
        opp.Tax_D__c = quote.Tax_12__c;
        opp.Actual_Ground_Shipping_Cost_D__c = quote.Domestic_Freight_Charge_12__c;
        opp.Additional_Charges_s_AD__c = quote.Additional_charge_s_12__c;
        opp.Total_Selling_D__c = quote.Domestic_Grand_Total_12__c;   
      }

      if(quote.Use_to_Calculate_ROW_13__c == 'Yes'){
        opp.Opportunity_Vendor__c = 'Domestic';
        opp.Quantity_1__c = null;
        opp.Tax_I__c = null;
        opp.Total_Selling_Int__c = null; 
        opp.Quoted_Product_Price__c = null;
        opp.Quoted_Ocean_Freight__c = null;
        opp.Quoted_Ground_Freight__c = null;
        opp.Quoted_Tax__c = null;
        opp.Additional_Charges_s_IQ__c = null;
        opp.Quoted_Expedited_Freight__c = null;
        opp.Quantity_2__c = quote.Total_Quantity_13__c;
        opp.Actual_Pur_Cost_D__c = quote.Dom_Purch_Price_13__c;
        opp.Tax_D__c = quote.Tax_13__c;
        opp.Actual_Ground_Shipping_Cost_D__c = quote.Domestic_Freight_Charge_13__c;
        opp.Additional_Charges_s_AD__c = quote.Additional_charge_s_13__c;
        opp.Total_Selling_D__c = quote.Domestic_Grand_Total_13__c;   
      }

      if(quote.Use_to_Calculate_ROW_14__c == 'Yes'){
        opp.Opportunity_Vendor__c = 'Domestic';
        opp.Quantity_1__c = null;
        opp.Tax_I__c = null;
        opp.Total_Selling_Int__c = null; 
        opp.Quoted_Product_Price__c = null;
        opp.Quoted_Ocean_Freight__c = null;
        opp.Quoted_Ground_Freight__c = null;
        opp.Quoted_Tax__c = null;
        opp.Additional_Charges_s_IQ__c = null;
        opp.Quoted_Expedited_Freight__c = null;
        opp.Quantity_2__c = quote.Total_Quantity_14__c;
        opp.Actual_Pur_Cost_D__c = quote.Dom_Purch_Price_14__c;
        opp.Tax_D__c = quote.Tax_14__c;
        opp.Actual_Ground_Shipping_Cost_D__c = quote.Domestic_Freight_Charge_14__c;
        opp.Additional_Charges_s_AD__c = quote.Additional_charge_s_14__c;
        opp.Total_Selling_D__c = quote.Domestic_Grand_Total_14__c;   
      }
    }
  }
}