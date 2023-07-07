public with sharing class OpportunityTriggerHandler {
    /**
* Method called on before insert
*/
    public static void onBeforeInsert(list<Opportunity> newRecords) {
        set<string> accountids = new set<string>();
        //Iterate opportunity
        for(Opportunity opp: newRecords){
            accountids.add(opp.AccountId);
        }
        
        map<string, string> accountOwnerMap = new map<string, string>();
        map<string, string> accountContactMap = new map<string, string>();
        for(Account acc : [SELECT Id, OwnerId, (SELECT Id FROM Contacts order by Is_Primary__c desc limit 1) FROM Account WHERE Id IN : accountids]){
            accountOwnerMap.put(acc.Id, acc.OwnerId);
            if(acc.Contacts.size() > 0){
                accountContactMap.put(acc.Id, acc.Contacts.get(0).Id);
            }
        }
        
        //Re-iterate opportunity
        for(Opportunity opp: newRecords){
            if(accountOwnerMap.containsKey(opp.AccountId)){
                opp.OwnerId = accountOwnerMap.get(opp.AccountId);
            }
            
            if(opp.Contact__c == null && accountContactMap.containsKey(opp.AccountId)){
                opp.Contact__c = accountContactMap.get(opp.AccountId);
            }
        }
    }
    
    /**
* Method called on before update
*/
    public static void onBeforeUpdate(list<Opportunity> newRecords, map<Id, Opportunity> oldRecordMap) {
        set<String> productionStatus = new set<String>{'Hardcopy Proof Approved', 'Approved for production', 'In-Production', 
            'Production Hold', 'Production Resumed', 'Off-Press', 'In-Transit'};
                
                set<String> stages = new set<String>{'Closed Won', 'Reprint', 'Proof Won', 'Proposal/ Custom Quote',
                    'Proposal/ Online Blind Quote', 'Order Cancelled', 'Closed Lost'};
                        
                        set<string> wonProductionOpportunityIds = new set<string>();
        
        set<string> stagesOpportunityIds = new set<string>();
        
        set<string> accountids = new set<string>();
        
        //Iterate opportunity
        for(Opportunity opp: newRecords){
            //Validation
            if(opp.StageName == 'Closed Won' && String.isEmpty(opp.Production_Status__c)){
                opp.addError('Please update Production Status.');
            }else if(opp.StageName == 'Closed Lost' && String.isEmpty(opp.Customer_Feedback__c)){
                opp.addError('Please enter value in customer feedback.');
            }
            
            //Set Production Status Clone field to act as a type of history field for Production Status
            if(opp.Production_Status__c != null && productionStatus.contains(opp.Production_Status__c)){
                opp.Production_Status_Clone__c = opp.Production_Status__c;
            }
            
            //When Production Status is advanced past hardcopy proof approved, always set the status back to the Clone when artwork is uploaded
            if(opp.Production_Status__c == 'Ready for Proofing' && opp.Approval_Date__c != null && opp.Production_Status_Clone__c != null && productionStatus.contains(opp.Production_Status_Clone__c)){
                opp.Production_Status__c = opp.Production_Status_Clone__c;
            }
            
            // If Closed Won and has Production status collect for further processing
            if(opp.StageName == 'Closed Won' && opp.Production_Status__c != null){
                wonProductionOpportunityIds.add(opp.Id);
            }
            
            //Game_Quote__c and Custom_Game_Quote__c stages
            if(opp.StageName != null && stages.contains(opp.StageName)){
                stagesOpportunityIds.add(opp.Id);
            }
            
            accountids.add(opp.AccountId);
        }
        
        //If Closed Won and has Production status collect for further processing
        map<string, Quote> wonProductionQuoteMap = new map<string, Quote>();
        if(wonProductionOpportunityIds.size() > 0){
            list<Quote> quotes = (list<Quote>)UtilityController.returnQuoteListRecords('Quote', 'OpportunityId', wonProductionOpportunityIds);
            for(Quote qu: quotes){
                wonProductionQuoteMap.put(qu.OpportunityId, qu);
            }
        }
        
        //Analysis Info from Quote
        map<string, Quote> quoteMap = new map<string, Quote>();
        if(stagesOpportunityIds.size() > 0){
            list<Quote> quotes = (list<Quote>)UtilityController.returnQuoteListRecords('Quote', 'OpportunityId', stagesOpportunityIds);
            for(Quote qu: quotes){
                quoteMap.put(qu.OpportunityId, qu);
            }
        }
        
        //Analysis Info from Game_Quote__c
        map<string, Game_Quote__c> gameQuoteMap = new map<string, Game_Quote__c>();
        if(stagesOpportunityIds.size() > 0){
            list<Game_Quote__c> gameQuotes = (list<Game_Quote__c>)UtilityController.returnQuoteListRecords('Game_Quote__c', 'Opportunity__c', stagesOpportunityIds);
            for(Game_Quote__c gq: gameQuotes){
                gameQuoteMap.put(gq.Opportunity__c, gq);
            }
        }
        
        //Analysis Info from Custom_Game_Quote__c
        map<string, Custom_Game_Quote__c> customGameQuoteMap = new map<string, Custom_Game_Quote__c>();
        if(stagesOpportunityIds.size() > 0){
            list<Custom_Game_Quote__c> gameQuotes = (list<Custom_Game_Quote__c>)UtilityController.returnQuoteListRecords('Custom_Game_Quote__c', 'Opportunity__c', stagesOpportunityIds);
            for(Custom_Game_Quote__c cgq: gameQuotes){
                customGameQuoteMap.put(cgq.Opportunity__c, cgq);
            }
        }
        
        //Update Contact__c
        map<string, string> accountContactMap = new map<string, string>();
        for(Account acc : [SELECT Id, OwnerId, (SELECT Id FROM Contacts order by Is_Primary__c desc limit 1) FROM Account WHERE Id IN : accountids]){
            if(acc.Contacts.size() > 0){
                accountContactMap.put(acc.Id, acc.Contacts.get(0).Id);
            }
        }
        
        //Re-iterate opportunity
        for(Opportunity opp: newRecords){
            //Update Price - If Closed Won and has Production status collect for further processing
            if(wonProductionQuoteMap.containsKey(opp.Id)){
                Quote qRecord = wonProductionQuoteMap.get(opp.Id);
                if(qRecord.Use_to_Calculate_ROW_1__c == 'Yes'){
                    opp.Opportunity_Vendor__c = 'International';
                    opp.Quantity_2__c = null;
                    opp.Actual_Pur_Cost_D__c = null;
                    opp.Tax_D__c = null;
                    opp.Actual_Ground_Shipping_Cost_D__c = null;
                    opp.Additional_Charges_s_AD__c = null;
                    opp.Total_Selling_D__c = null;   
                    opp.Quantity_1__c = qRecord.Total_Quantity_1__c;
                    opp.Tax_I__c = qRecord.Tax;
                    opp.Total_Selling_Int__c = qRecord.International_Grand_Total_1__c;
                    
                    opp.Quoted_Product_Price__c = qRecord.Product_i_Price1__c;
                    opp.Quoted_Ocean_Freight__c = qRecord.Ocean_Freight_Price1__c;
                    opp.Quoted_Ground_Freight__c = qRecord.Ground_Freight_Price1__c;
                    opp.Quoted_Tax__c = qRecord.Tax;
                    opp.Additional_Charges_s_IQ__c = qRecord.Add_On_Price_1__c;
                    opp.Proofing_Price__c = qRecord.Proofing_Price_1__c;
                    opp.Quoted_Expedited_Freight__c = qRecord.Expedited_Freight_Price1__c;                   
                }
                
                if(qRecord.Use_to_Calculate_ROW_2__c == 'Yes'){
                    opp.Opportunity_Vendor__c = 'International';
                    opp.Quantity_2__c = null;
                    opp.Actual_Pur_Cost_D__c = null;
                    opp.Tax_D__c = null;
                    opp.Actual_Ground_Shipping_Cost_D__c = null;
                    opp.Additional_Charges_s_AD__c = null;
                    opp.Total_Selling_D__c = null;  
                    opp.Quantity_1__c = qRecord.Total_Quantity_2__c;
                    opp.Tax_I__c = qRecord.Tax_2__c;
                    opp.Total_Selling_Int__c = qRecord.International_Grand_Total_2__c;
                    
                    opp.Quoted_Product_Price__c = qRecord.Product_i_Price2__c;
                    opp.Quoted_Ocean_Freight__c = qRecord.Ocean_Freight_Price2__c;
                    opp.Quoted_Ground_Freight__c = qRecord.Ground_Freight_Price2__c;
                    opp.Quoted_Tax__c = qRecord.Tax_2__c;
                    opp.Additional_Charges_s_IQ__c = qRecord.Add_On_Price_2__c;
                    opp.Proofing_Price__c = qRecord.Proofing_Price_2__c;
                    opp.Quoted_Expedited_Freight__c = qRecord.Expedited_Freight_Price2__c;
                }
                
                if(qRecord.Use_to_Calculate_ROW_3__c == 'Yes'){
                    opp.Opportunity_Vendor__c = 'International';
                    opp.Quantity_2__c = null;
                    opp.Actual_Pur_Cost_D__c = null;
                    opp.Tax_D__c = null;
                    opp.Actual_Ground_Shipping_Cost_D__c = null;
                    opp.Additional_Charges_s_AD__c = null;
                    opp.Total_Selling_D__c = null;  
                    opp.Quantity_1__c = qRecord.Total_Quantity_3__c;
                    opp.Tax_I__c = qRecord.Tax_3__c;
                    opp.Total_Selling_Int__c = qRecord.International_Grand_Total_3__c;
                    
                    opp.Quoted_Product_Price__c = qRecord.Product_i_Price3__c;
                    opp.Quoted_Ocean_Freight__c = qRecord.Ocean_Freight_Price3__c;
                    opp.Quoted_Ground_Freight__c = qRecord.Ground_Freight_Price3__c;
                    opp.Quoted_Tax__c = qRecord.Tax_3__c;
                    opp.Additional_Charges_s_IQ__c = qRecord.Add_On_Price_3__c;
                    opp.Proofing_Price__c = qRecord.Proofing_Price_3__c;
                    opp.Quoted_Expedited_Freight__c = qRecord.Expedited_Freight_Price3__c;
                }
                
                if(qRecord.Use_to_Calculate_ROW_4__c == 'Yes'){
                    opp.Opportunity_Vendor__c = 'International';
                    opp.Quantity_2__c = null;
                    opp.Actual_Pur_Cost_D__c = null;
                    opp.Tax_D__c = null;
                    opp.Actual_Ground_Shipping_Cost_D__c = null;
                    opp.Additional_Charges_s_AD__c = null;
                    opp.Total_Selling_D__c = null;  
                    opp.Quantity_1__c = qRecord.Total_Quantity_4__c;
                    opp.Tax_I__c = qRecord.Tax_4__c;
                    opp.Total_Selling_Int__c = qRecord.International_Grand_Total_4__c;
                    
                    opp.Quoted_Product_Price__c = qRecord.Product_i_Price4__c;
                    opp.Quoted_Ocean_Freight__c = qRecord.Ocean_Freight_Price4__c;
                    opp.Quoted_Ground_Freight__c = qRecord.Ground_Freight_Price4__c;
                    opp.Quoted_Tax__c = qRecord.Tax_4__c;
                    opp.Additional_Charges_s_IQ__c = qRecord.Add_On_Price_4__c;
                    opp.Proofing_Price__c = qRecord.Proofing_Price_4__c;
                    opp.Quoted_Expedited_Freight__c = qRecord.Expedited_Freight_Price4__c;
                }
                
                if(qRecord.Use_to_Calculate_ROW_11__c == 'Yes'){
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
                    opp.Quantity_2__c = qRecord.Total_Quantity_11__c;
                    opp.Actual_Pur_Cost_D__c = qRecord.Dom_Purch_Price_11__c;
                    opp.Tax_D__c = qRecord.Tax_11__c;
                    opp.Actual_Ground_Shipping_Cost_D__c = qRecord.Domestic_Freight_Charge_11__c;
                    opp.Additional_Charges_s_AD__c = qRecord.Additional_charge_s_11__c;
                    opp.Total_Selling_D__c = qRecord.Domestic_Grand_Total_11__c;   
                }
                
                if(qRecord.Use_to_Calculate_ROW_12__c == 'Yes'){
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
                    opp.Quantity_2__c = qRecord.Total_Quantity_12__c;
                    opp.Actual_Pur_Cost_D__c = qRecord.Dom_Purch_Price_12__c;
                    opp.Tax_D__c = qRecord.Tax_12__c;
                    opp.Actual_Ground_Shipping_Cost_D__c = qRecord.Domestic_Freight_Charge_12__c;
                    opp.Additional_Charges_s_AD__c = qRecord.Additional_charge_s_12__c;
                    opp.Total_Selling_D__c = qRecord.Domestic_Grand_Total_12__c;   
                }
                
                if(qRecord.Use_to_Calculate_ROW_13__c == 'Yes'){
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
                    opp.Quantity_2__c = qRecord.Total_Quantity_13__c;
                    opp.Actual_Pur_Cost_D__c = qRecord.Dom_Purch_Price_13__c;
                    opp.Tax_D__c = qRecord.Tax_13__c;
                    opp.Actual_Ground_Shipping_Cost_D__c = qRecord.Domestic_Freight_Charge_13__c;
                    opp.Additional_Charges_s_AD__c = qRecord.Additional_charge_s_13__c;
                    opp.Total_Selling_D__c = qRecord.Domestic_Grand_Total_13__c;   
                }
                
                if(qRecord.Use_to_Calculate_ROW_14__c == 'Yes'){
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
                    opp.Quantity_2__c = qRecord.Total_Quantity_14__c;
                    opp.Actual_Pur_Cost_D__c = qRecord.Dom_Purch_Price_14__c;
                    opp.Tax_D__c = qRecord.Tax_14__c;
                    opp.Actual_Ground_Shipping_Cost_D__c = qRecord.Domestic_Freight_Charge_14__c;
                    opp.Additional_Charges_s_AD__c = qRecord.Additional_charge_s_14__c;
                    opp.Total_Selling_D__c = qRecord.Domestic_Grand_Total_14__c;   
                }
            }
            
            //Quote
            if(quoteMap.containsKey(opp.Id)){
                Quote quRecord = quoteMap.get(opp.Id);
                if(quRecord.Use_to_Calculate_ROW_1__c=='Yes' || quRecord.Use_to_Calculate_ROW_2__c=='Yes' || quRecord.Use_to_Calculate_ROW_3__c=='Yes' || quRecord.Use_to_Calculate_ROW_4__c=='Yes'){
                    opp.Opportunity_Vendor__c='International';
                    opp.Quoted_Product__c=quRecord.Product__c;
                    opp.Quoted_Product_Size__c=quRecord.Product_Size__c;
                    opp.Quoted_Page_Count__c=quRecord.Page_Count__c;
                    opp.Quoted_Binding__c=quRecord.Binding__c;
                    opp.newshipping_street__c=quRecord.ShippingStreet;
                    opp.Ship_To_Street_2__c=quRecord.Ship_To_Street_2__c;
                    opp.newshipping_city__c=quRecord.ShippingCity;
                    opp.newshipping_state__c=quRecord.ShippingState;
                    opp.newshipping_postal_code__c=quRecord.ShippingPostalCode;
                    opp.newshipping_country__c=quRecord.ShippingCountry;
                    opp.newshipping_phone__c=quRecord.Phone;
                    opp.newshipping_residential__c=quRecord.newshipping_residential__c;
                    opp.newshipping_liftgate__c=quRecord.newshipping_liftgate__c;//Sunil | Changes 11-Aug-2022
                    opp.Total_Product_Selling_Price__c=quRecord.Total_Product_Selling_Price__c;
                    opp.PRN_AS_Warehousing_Interest__c=quRecord.PRN_AS_Warehousing_Interest__c;
                    opp.PRN_AS_Fulfillment_Interest__c=quRecord.PRN_AS_Fulfillment_Interest__c;
                    opp.PRN_AS_Pick_And_Pack_Interest__c=quRecord.PRN_AS_Pick_And_Pack_Interest__c;
                    opp.PRN_headtailbands__c=quRecord.PRN_headtailbands__c;
                    opp.Amazon_Diamond__c=quRecord.Amazon_Diamond__c;
                    opp.PRN_variantcovers__c=quRecord.PRN_variantcovers__c;
                    opp.PRN_frenchfoldcovers__c=quRecord.PRN_frenchfoldcovers__c;
                    opp.Sequential_Foil_Numbering__c=quRecord.Sequential_Foil_Numbering__c;
                    opp.Shrink_Wrapping__c=quRecord.Shrink_Wrapping__c;
                    opp.Split_Shipping__c=quRecord.Split_Shipping__c;
                    opp.Split_Shipping_Details__c=quRecord.Split_Shipping_Details__c;
                    opp.Diamond_Order_Information__c=quRecord.Diamond_Order_Information__c;
                    opp.Fulfillment_Package__c=quRecord.Fulfillment_Package__c;
                    opp.Fulfillment_Quantity__c=quRecord.Fulfillment_Quantity__c;
                    opp.Prepress_Method__c=quRecord.Prepress_Method__c;
                    opp.Specialty_Options_Book__c=quRecord.Specialty_Options_Book__c;
                    opp.Ribbon_Color__c=quRecord.Ribbon_Color__c;
                    opp.PrePress_Dust_Jacket_Flap_Width__c=quRecord.Dust_Jacket_Flap_Width__c;
                    opp.Prepress_Dust_Jacket_Spine__c=quRecord.Dust_Jacket_Spine_Width__c;
                    opp.Prepress_French_Fold_Flap_Width__c=quRecord.French_Fold_Flap_Width__c;
                    opp.ISBN__c=quRecord.ISBN__c;
                    opp.Metallic_Ink_Color__c=quRecord.Metallic_Ink_Color__c;
                    opp.Number_of_Spot_Colors__c=quRecord.Number_of_Spot_Colors__c;
                    opp.PrePress_Spine__c=quRecord.Spine_Width__c;
                    opp.Bossing_Style__c=quRecord.Bossing_Style__c; //Sunil | Added 17-05-2022
                    //PG 05/20/2023 - Populate Ship to company
                    if(quRecord.Ship_To_Company__c!=null && quRecord.Ship_To_Company__c!=''){
                    opp.newshipping_company__c=quRecord.Ship_To_Company__c;
                    }
                }
                
                if(quRecord.Use_to_Calculate_ROW_1__c=='Yes'){
                    opp.Int_l_Vendor__c=quRecord.Int_l_Vendor_1__c;
                    opp.Total_Quantity__c=quRecord.Total_Quantity_1__c;
                    opp.Expedited_Quantity__c=quRecord.Expedited_Quantity_1__c;
                    opp.Quoted_Product_Purchase_Cost__c=quRecord.Product_Purchase_Cost1__c;
                    opp.Quoted_Product_Purchase_Markup__c=quRecord.Product_Purchase_Markup1__c;
                    opp.Quoted_Product_Price__c=quRecord.Product_i_Price1__c;
                    opp.Quoted_Ocean_Freight_Cost__c=quRecord.Ocean_Freight_1__c;
                    opp.Quoted_Ocean_Freight_Markup__c=quRecord.Ocean_Freight_Markup_i1__c;
                    opp.Quoted_Ocean_Freight__c=quRecord.Ocean_Freight_Price1__c;
                    opp.Quoted_International_Product_Price__c=quRecord.Product_Price_1__c;
                    opp.Quoted_Tax__c=quRecord.Tax;
                    opp.Quoted_Ground_Freight_Cost__c=quRecord.Grd_Freight_1__c;
                    opp.Quoted_Ground_Freight_Markup__c=quRecord.Ground_Freight_Markup_i1__c;
                    opp.Quoted_Ground_Freight__c=quRecord.Ground_Freight_Price1__c;
                    opp.Quoted_Expedited_Freight_Cost__c=quRecord.Expedited_Freight_1__c;
                    opp.Quoted_Expedited_Freight_Markup__c=quRecord.Expedited_Freight_Markup_i1__c;
                    opp.Quoted_Expedited_Freight__c=quRecord.Expedited_Freight_Price1__c;
                    opp.Quoted_Discount_Reason__c=quRecord.Discount_Reason_1__c;
                    opp.Quantity_1__c=quRecord.Total_Quantity_1__c;
                    opp.Tax_I__c=quRecord.Tax;
                    opp.Total_Selling_Int__c=quRecord.International_Grand_Total_1__c;
                    opp.Additional_Charge_s_IA__c=quRecord.Add_On_Price_1__c;
                    opp.Additional_Charges_s_IQ__c=quRecord.Add_On_Price_1__c;
                }
                
                if(quRecord.Use_to_Calculate_ROW_2__c=='Yes'){
                    opp.Int_l_Vendor__c=quRecord.Int_l_Vendor_2__c;
                    opp.Total_Quantity__c=quRecord.Total_Quantity_2__c;
                    opp.Expedited_Quantity__c=quRecord.Expedited_Quantity_2__c;
                    opp.Quoted_Product_Purchase_Cost__c=quRecord.Product_Purchase_Cost2__c;
                    opp.Quoted_Product_Purchase_Markup__c=quRecord.Product_Purchase_Markup2__c;
                    opp.Quoted_Product_Price__c=quRecord.Product_i_Price2__c;
                    opp.Quoted_Ocean_Freight_Cost__c=quRecord.Ocean_Freight_2__c;                       
                    opp.Quoted_Ocean_Freight_Markup__c=quRecord.Ocean_Freight_Markup_i2__c;
                    opp.Quoted_Ocean_Freight__c=quRecord.Ocean_Freight_Price2__c;
                    opp.Quoted_International_Product_Price__c=quRecord.Product_Price_2__c;
                    opp.Quoted_Tax__c=quRecord.Tax_2__c;
                    opp.Quoted_Ground_Freight_Cost__c=quRecord.Grd_Freight_2__c;
                    opp.Quoted_Ground_Freight_Markup__c=quRecord.Ground_Freight_Markup_i2__c;
                    opp.Quoted_Ground_Freight__c=quRecord.Ground_Freight_Price2__c;
                    opp.Quoted_Expedited_Freight_Cost__c=quRecord.Expedited_Freight_2__c;
                    opp.Quoted_Expedited_Freight_Markup__c=quRecord.Expedited_Freight_Markup_i2__c;
                    opp.Quoted_Expedited_Freight__c=quRecord.Expedited_Freight_Price2__c;
                    opp.Quoted_Discount_Reason__c=quRecord.Discount_Reason_2__c;
                    opp.Quantity_1__c=quRecord.Total_Quantity_2__c;
                    opp.Tax_I__c=quRecord.Tax_2__c;
                    opp.Total_Selling_Int__c=quRecord.International_Grand_Total_2__c;
                    opp.Additional_Charge_s_IA__c=quRecord.Add_On_Price_2__c; 
                    opp.Additional_Charges_s_IQ__c=quRecord.Add_On_Price_2__c;
                }
                
                if(quRecord.Use_to_Calculate_ROW_3__c=='Yes'){
                    opp.Int_l_Vendor__c=quRecord.Int_l_Vendor_3__c;
                    opp.Total_Quantity__c=quRecord.Total_Quantity_3__c;
                    opp.Expedited_Quantity__c=quRecord.Expedited_Quantity_3__c;
                    opp.Quoted_Product_Purchase_Cost__c=quRecord.Product_Purchase_Cost3__c;
                    opp.Quoted_Product_Purchase_Markup__c=quRecord.Product_Purchase_Markup3__c;
                    opp.Quoted_Product_Price__c=quRecord.Product_i_Price3__c;
                    opp.Quoted_Ocean_Freight_Cost__c=quRecord.Ocean_Freight_3__c;
                    opp.Quoted_Ocean_Freight_Markup__c=quRecord.Ocean_Freight_Markup_i3__c;
                    opp.Quoted_Ocean_Freight__c=quRecord.Ocean_Freight_Price3__c;
                    opp.Quoted_International_Product_Price__c=quRecord.Product_Price_3__c;
                    opp.Quoted_Tax__c=quRecord.Tax_3__c;
                    opp.Quoted_Ground_Freight_Cost__c=quRecord.Grd_Freight_3__c;
                    opp.Quoted_Ground_Freight_Markup__c=quRecord.Ground_Freight_Markup_i3__c;
                    opp.Quoted_Ground_Freight__c=quRecord.Ground_Freight_Price3__c;
                    opp.Quoted_Expedited_Freight_Cost__c=quRecord.Expedited_Freight_3__c;
                    opp.Quoted_Expedited_Freight_Markup__c=quRecord.Expedited_Freight_Markup_i3__c;
                    opp.Quoted_Expedited_Freight__c=quRecord.Expedited_Freight_Price3__c;
                    opp.Quoted_Discount_Reason__c=quRecord.Discount_Reason_3__c;
                    opp.Quantity_1__c=quRecord.Total_Quantity_3__c;
                    opp.Tax_I__c=quRecord.Tax_3__c;
                    opp.Total_Selling_Int__c=quRecord.International_Grand_Total_3__c;
                    opp.Additional_Charge_s_IA__c=quRecord.Add_On_Price_3__c;
                    opp.Additional_Charges_s_IQ__c=quRecord.Add_On_Price_3__c;
                }
                
                if(quRecord.Use_to_Calculate_ROW_4__c=='Yes'){
                    opp.Int_l_Vendor__c=quRecord.Int_l_Vendor_4__c;
                    opp.Total_Quantity__c=quRecord.Total_Quantity_4__c;
                    opp.Expedited_Quantity__c=quRecord.Expedited_Quantity_4__c;
                    opp.Quoted_Product_Purchase_Cost__c=quRecord.Product_Purchase_Cost4__c;
                    opp.Quoted_Product_Purchase_Markup__c=quRecord.Product_Purchase_Markup4__c;
                    opp.Quoted_Product_Price__c=quRecord.Product_i_Price4__c;
                    opp.Quoted_Ocean_Freight_Cost__c=quRecord.Ocean_Freight_4__c;
                    opp.Quoted_Ocean_Freight_Markup__c=quRecord.Ocean_Freight_Markup_i4__c;
                    opp.Quoted_Ocean_Freight__c=quRecord.Ocean_Freight_Price4__c;
                    opp.Quoted_International_Product_Price__c=quRecord.Product_Price_4__c;
                    opp.Quoted_Tax__c=quRecord.Tax_4__c;
                    opp.Quoted_Ground_Freight_Cost__c=quRecord.Grd_Freight_4__c;
                    opp.Quoted_Ground_Freight_Markup__c=quRecord.Ground_Freight_Markup_i4__c;
                    opp.Quoted_Ground_Freight__c=quRecord.Ground_Freight_Price4__c;
                    opp.Quoted_Expedited_Freight_Cost__c=quRecord.Expedited_Freight_4__c;
                    opp.Quoted_Expedited_Freight_Markup__c=quRecord.Expedited_Freight_Markup_i4__c;
                    opp.Quoted_Expedited_Freight__c=quRecord.Expedited_Freight_Price4__c;
                    opp.Quoted_Discount_Reason__c=quRecord.Discount_Reason_4__c;
                    opp.Quantity_1__c=quRecord.Total_Quantity_4__c;
                    opp.Tax_I__c=quRecord.Tax_4__c;
                    opp.Total_Selling_Int__c=quRecord.International_Grand_Total_4__c;
                    opp.Additional_Charge_s_IA__c=quRecord.Add_On_Price_4__c;
                    opp.Additional_Charges_s_IQ__c=quRecord.Add_On_Price_4__c;
                }
                
                if(quRecord.Use_to_Calculate_ROW_11__c=='Yes' || quRecord.Use_to_Calculate_ROW_12__c=='Yes' || quRecord.Use_to_Calculate_ROW_13__c=='Yes' || quRecord.Use_to_Calculate_ROW_14__c=='Yes'){
                    opp.Opportunity_Vendor__c='Domestic';
                    opp.PRN_AS_Warehousing_Interest__c=quRecord.PRN_AS_Warehousing_Interest__c;
                    opp.PRN_AS_Fulfillment_Interest__c=quRecord.PRN_AS_Fulfillment_Interest__c;
                    opp.PRN_AS_Pick_And_Pack_Interest__c=quRecord.PRN_AS_Pick_And_Pack_Interest__c;
                    opp.PRN_headtailbands__c=quRecord.PRN_headtailbands__c;
                }
                
                if(quRecord.Use_to_Calculate_ROW_11__c=='Yes'){
                    opp.Quantity_2__c=quRecord.Total_Quantity_11__c;
                    opp.Tax_D__c=quRecord.Tax_11__c;
                    opp.Actual_Pur_Cost_D__c=quRecord.Dom_Purch_Price_11__c;
                    opp.Actual_Ground_Shipping_Cost_D__c=quRecord.Domestic_Freight_Charge_11__c;
                    opp.Total_Selling_D__c=quRecord.Domestic_Grand_Total_11__c;
                    opp.Actual_Ground_Shipping_Cost_D__c=quRecord.Domestic_Freight_Charge_11__c;
                    opp.Additional_Charges_s_AD__c=quRecord.Additional_charge_s_11__c;
                    opp.Total_Selling_D__c=quRecord.Domestic_Grand_Total_11__c;  
                }
                if(quRecord.Use_to_Calculate_ROW_12__c=='Yes'){
                    opp.Quantity_2__c=quRecord.Total_Quantity_12__c;
                    opp.Tax_D__c=quRecord.Tax_12__c;
                    opp.Actual_Pur_Cost_D__c=quRecord.Dom_Purch_Price_12__c;
                    opp.Actual_Ground_Shipping_Cost_D__c=quRecord.Domestic_Freight_Charge_12__c;
                    opp.Total_Selling_D__c=quRecord.Domestic_Grand_Total_12__c;
                    opp.Actual_Ground_Shipping_Cost_D__c=quRecord.Domestic_Freight_Charge_12__c;
                    opp.Additional_Charges_s_AD__c=quRecord.Additional_charge_s_12__c;
                    opp.Total_Selling_D__c=quRecord.Domestic_Grand_Total_12__c;  
                }
                
                if(quRecord.Use_to_Calculate_ROW_13__c=='Yes'){
                    opp.Quantity_2__c=quRecord.Total_Quantity_13__c;
                    opp.Tax_D__c=quRecord.Tax_13__c;
                    opp.Actual_Pur_Cost_D__c=quRecord.Dom_Purch_Price_13__c;
                    opp.Actual_Ground_Shipping_Cost_D__c=quRecord.Domestic_Freight_Charge_13__c;
                    opp.Total_Selling_D__c=quRecord.Domestic_Grand_Total_13__c;
                    opp.Actual_Ground_Shipping_Cost_D__c=quRecord.Domestic_Freight_Charge_13__c;
                    opp.Additional_Charges_s_AD__c=quRecord.Additional_charge_s_13__c;
                    opp.Total_Selling_D__c=quRecord.Domestic_Grand_Total_13__c;  
                }
                
                if(quRecord.Use_to_Calculate_ROW_14__c=='Yes'){
                    opp.Quantity_2__c=quRecord.Total_Quantity_14__c;
                    opp.Tax_D__c=quRecord.Tax_14__c;
                    opp.Actual_Pur_Cost_D__c=quRecord.Dom_Purch_Price_14__c;
                    opp.Actual_Ground_Shipping_Cost_D__c=quRecord.Domestic_Freight_Charge_14__c;
                    opp.Total_Selling_D__c=quRecord.Domestic_Grand_Total_14__c;
                    opp.Actual_Ground_Shipping_Cost_D__c=quRecord.Domestic_Freight_Charge_14__c;
                    opp.Additional_Charges_s_AD__c=quRecord.Additional_charge_s_14__c;
                    opp.Total_Selling_D__c=quRecord.Domestic_Grand_Total_14__c;  
                }
                
                if(quRecord.Use_to_Calculate_ROW_1__c=='Yes' || quRecord.Use_to_Calculate_ROW_2__c=='Yes' || quRecord.Use_to_Calculate_ROW_3__c=='Yes' || quRecord.Use_to_Calculate_ROW_4__c=='Yes' || quRecord.Use_to_Calculate_ROW_11__c=='Yes' || quRecord.Use_to_Calculate_ROW_12__c=='Yes' || quRecord.Use_to_Calculate_ROW_13__c=='Yes' || quRecord.Use_to_Calculate_ROW_14__c=='Yes'){
                    opp.PRN_additionalinfo__c=quRecord.PRN_additionalinfo__c;
                    //opp.PRN_basicembossdeboss__c=quRecord.PRN_basicembossdeboss__c;//PG 02/16/2023 - Removed per direction from Jeff
                    //opp.PRN_basicfoilstamping__c=quRecord.PRN_basicfoilstamping__c;//PG 02/16/2023 - Removed per direction from Jeff
                    //opp.Complex_Foil_Stamp__c=quRecord.Complex_Foil_Stamp__c;//Updated by Sunil | 21-07-2022 //PG 02/16/2023 - Removed per direction from Jeff
                    opp.PRN_bindingtype__c=quRecord.PRN_bindingtype__c;
                    opp.PRN_corners__c=quRecord.PRN_corners__c;
                    opp.PRN_coverpapercoating__c=quRecord.PRN_coverpapercoating__c;
                    opp.PRN_coverpaperfinishstyle__c=quRecord.PRN_coverpaperfinishstyle__c;
                    opp.PRN_coverpaperfinishtype__c=quRecord.PRN_coverpaperfinishtype__c;
                    opp.PRN_coverpaperweight__c=quRecord.PRN_coverpaperweight__c;
                    opp.PRN_dustjacket__c=quRecord.PRN_dustjacket__c;
                    opp.PRN_dustjacketfinishstyle__c=quRecord.PRN_dustjacketfinishstyle__c;
                    opp.PRN_endsheets__c=quRecord.PRN_endsheets__c;
                    opp.PRN_height__c=quRecord.PRN_height__c;
                    opp.PRN_insidepagecount__c=quRecord.PRN_insidepagecount__c;
                    opp.PRN_insidepapercoating__c=quRecord.PRN_insidepapercoating__c;
                    opp.PRN_insidepaperweight__c=quRecord.PRN_insidepaperweight__c;
                    opp.PRN_printingcolor__c=quRecord.PRN_printingcolor__c;
                    opp.PRN_printoninsidecoversendsheets__c=quRecord.PRN_printoninsidecoversendsheets__c;
                    opp.PRN_proofing__c=quRecord.PRN_proofing__c;
                    //opp.PRN_spotuv__c=quRecord.PRN_spotuv__c;//PG 02/16/2023 - Removed per direction from Jeff
                    opp.PRN_width__c=quRecord.PRN_width__c;
                    opp.newshipping_liftgate__c=quRecord.newshipping_liftgate__c;
                    opp.Foil_Stamp_Color__c=quRecord.Foil_Stamp_Color__c;
                    opp.Faux_Leather_Cover_Options__c=quRecord.Faux_Leather_Cover_Options__c;
                    opp.Fabric_Cover_Options__c=quRecord.Fabric_Cover_Options__c;
                    opp.Texture_Options__c=quRecord.Texture_Options__c;
                    opp.Perforated_Pages__c=quRecord.Perforated_Pages__c; //Updated by Sunil | 24-02-2022
                    opp.Project_Spine_Style__c=quRecord.Spine_Style__c; //Updated by Sunil | 24-02-2022
                    opp.Soy_Ink__c=quRecord.Soy_Ink__c; //Updated by Sunil | 24-02-2022
                    opp.Foil_Stamping_Style__c=quRecord.Foil_Stamping_Style__c;//PG 03/08/2023
                    opp.Spot_UV_Style__c=quRecord.Spot_UV_Style__c;//PG 03/08/2023
                    if(opp.StageName=='Closed Won' || opp.StageName=='Reprint'){
                        opp.Display_Quantity__c=quRecord.Order_Quantity_Marked_For_ROW__c;
                    }
                }
            }
            
            //Game_Quote__c
            if(gameQuoteMap.containsKey(opp.Id)){
                Game_Quote__c gqRecord = gameQuoteMap.get(opp.Id);
                if(gqRecord.Use_to_Calculate_ROW_1__c == 'Yes' || gqRecord.Use_to_Calculate_ROW_2__c == 'Yes'){
                    opp.Opportunity_Vendor__c = 'International';
                    opp.newshipping_street__c = gqRecord.gq_shiptostreet__c;
                    opp.newshipping_city__c = gqRecord.gq_shiptocity__c;
                    opp.newshipping_state__c = gqRecord.gq_shiptostate__c;
                    opp.newshipping_postal_code__c = gqRecord.gq_shiptozip__c;
                    opp.newshipping_country__c = gqRecord.gq_shiptocountry__c;
                    opp.newshipping_phone__c = gqRecord.Phone__c;
                    opp.newshipping_residential__c = gqRecord.newshipping_residential__c;
                    opp.newshipping_liftgate__c=gqRecord.newshipping_liftgate__c;//Sunil | Changes 11-Aug-2022
                    opp.Amazon_Diamond__c = gqRecord.Amazon_Diamond__c;  
                    opp.newshipping_liftgate__c = gqRecord.newshipping_liftgate__c;
                }
                
                if(gqRecord.Use_to_Calculate_ROW_1__c == 'Yes'){
                    opp.Display_Quantity__c = gqRecord.Display_Quantity_1__c;
                    opp.Total_Quantity__c = gqRecord.Total_Quantity_1__c;
                    opp.NEW_ROW__c = gqRecord.International_Grand_Total_1__c;
                    opp.Expedited_Quantity__c = gqRecord.Expedited_Quantity_1__c;
                    opp.Quoted_Product_Purchase_Cost__c = gqRecord.Product_Purchase_Cost1__c;
                    opp.Quoted_Product_Purchase_Markup__c = gqRecord.Product_Purchase_Markup1__c;
                    opp.Quoted_Product_Price__c = (gqRecord.Product_Price_1__c != null ? gqRecord.Product_Price_1__c : 0) + (gqRecord.Assembly_Cost_1__c != null ? gqRecord.Assembly_Cost_1__c : 0);
                    opp.Quoted_Ocean_Freight_Cost__c = gqRecord.Ocean_Freight_1__c;
                    opp.Quoted_Ocean_Freight_Markup__c = gqRecord.Ocean_Freight_Markup_i1__c;
                    opp.Quoted_Ocean_Freight__c = gqRecord.Ocean_Freight_Price1__c;
                    opp.Quoted_International_Product_Price__c = (gqRecord.Product_Price_1__c != null ? gqRecord.Product_Price_1__c : 0) + (gqRecord.Assembly_Cost_1__c != null ? gqRecord.Assembly_Cost_1__c : 0);
                    opp.Quoted_Tax__c = gqRecord.Tax_1__c;
                    opp.Quoted_Ground_Freight_Cost__c = gqRecord.Grd_Freight_1__c;
                    opp.Quoted_Ground_Freight_Markup__c = gqRecord.Ground_Freight_Markup_i1__c;
                    opp.Quoted_Ground_Freight__c = gqRecord.Ground_Freight_Price1__c;
                    opp.Quoted_Expedited_Freight_Cost__c = gqRecord.Expedited_Freight_1__c;
                    opp.Quoted_Expedited_Freight_Markup__c = gqRecord.Expedited_Freight_Markup_i1__c;
                    opp.Quoted_Expedited_Freight__c = gqRecord.Expedited_Freight_Price1__c;
                    opp.Quantity_1__c = gqRecord.Total_Quantity_1__c;
                    opp.Tax_I__c = gqRecord.Tax_1__c;
                    opp.Total_Selling_Int__c = gqRecord.International_Grand_Total_1__c;
                    opp.Additional_Charge_s_IA__c = gqRecord.Additional_charge_s_1__c;
                    opp.Additional_Charges_s_IQ__c = gqRecord.Additional_Charge_s_1__c;
                    opp.Proofing_Price__c = gqRecord.Prototyping_Cost_1__c;
                }
                
                if(gqRecord.Use_to_Calculate_ROW_2__c == 'Yes'){
                    opp.Display_Quantity__c = gqRecord.Display_Quantity_2__c;
                    opp.Total_Quantity__c = gqRecord.Total_Quantity_2__c;
                    opp.NEW_ROW__c = gqRecord.International_Grand_Total_2__c;
                    opp.Expedited_Quantity__c = gqRecord.Expedited_Quantity_2__c;
                    opp.Quoted_Product_Purchase_Cost__c = gqRecord.Product_Purchase_Cost2__c;
                    opp.Quoted_Product_Purchase_Markup__c = gqRecord.Product_Purchase_Markup2__c;
                    opp.Quoted_Product_Price__c = (gqRecord.Product_Price_2__c != null ? gqRecord.Product_Price_2__c : 0) + (gqRecord.Assembly_Cost_2__c != null ? gqRecord.Assembly_Cost_2__c : 0);
                    opp.Quoted_Ocean_Freight_Cost__c = gqRecord.Ocean_Freight_2__c;
                    opp.Quoted_Ocean_Freight_Markup__c = gqRecord.Ocean_Freight_Markup_i2__c;
                    opp.Quoted_Ocean_Freight__c = gqRecord.Ocean_Freight_Price2__c;
                    opp.Quoted_International_Product_Price__c = (gqRecord.Product_Price_2__c != null ? gqRecord.Product_Price_2__c : 0) + (gqRecord.Assembly_Cost_2__c != null ? gqRecord.Assembly_Cost_2__c : 0);
                    opp.Quoted_Tax__c = gqRecord.Tax_2__c;
                    opp.Quoted_Ground_Freight_Cost__c = gqRecord.Grd_Freight_2__c;
                    opp.Quoted_Ground_Freight_Markup__c = gqRecord.Ground_Freight_Markup_i2__c;
                    opp.Quoted_Ground_Freight__c = gqRecord.Ground_Freight_Price2__c;
                    opp.Quoted_Expedited_Freight_Cost__c = gqRecord.Expedited_Freight_2__c;
                    opp.Quoted_Expedited_Freight_Markup__c = gqRecord.Expedited_Freight_Markup_i2__c;
                    opp.Quoted_Expedited_Freight__c = gqRecord.Expedited_Freight_Price2__c;
                    opp.Quantity_1__c = gqRecord.Total_Quantity_2__c;
                    opp.Tax_I__c = gqRecord.Tax_2__c;
                    opp.Total_Selling_Int__c = gqRecord.International_Grand_Total_2__c;
                    opp.Additional_Charge_s_IA__c = gqRecord.Additional_charge_s_2__c;
                    opp.Additional_Charges_s_IQ__c = gqRecord.Additional_Charge_s_2__c;
                    opp.Proofing_Price__c = gqRecord.Prototyping_Cost_2__c;
                }
            }
            
            //Custom_Game_Quote__c
            if(customGameQuoteMap.containsKey(opp.Id)){
                Custom_Game_Quote__c gqRecord = customGameQuoteMap.get(opp.Id);
                if(gqRecord.Use_to_Calculate_ROW_1__c == 'Yes' || gqRecord.Use_to_Calculate_ROW_2__c == 'Yes' || gqRecord.Use_to_Calculate_ROW_3__c == 'Yes' ||gqRecord.Use_to_Calculate_ROW_4__c == 'Yes'){
                    opp.Opportunity_Vendor__c = 'International';
                    opp.newshipping_street__c = gqRecord.Ship_To_Street__c;
                    opp.newshipping_city__c = gqRecord.Ship_To_City__c;
                    opp.newshipping_state__c = gqRecord.Ship_To_State_Province__c;
                    opp.newshipping_postal_code__c = gqRecord.Ship_To_Zip_Postal_Code__c;
                    opp.newshipping_country__c = gqRecord.Ship_To_Country__c;
                    opp.newshipping_phone__c = gqRecord.Phone__c;
                    opp.newshipping_residential__c = gqRecord.Residential_Address__c;
                    opp.newshipping_liftgate__c=opp.newshipping_residential__c;//Sunil | Changes 11-Aug-2022
                    opp.Total_Product_Selling_Price__c = gqRecord.Total_Product_Selling_Price__c;
                    opp.Amazon_Diamond__c = gqRecord.Amazon_Diamond__c;
                    opp.Split_Shipping__c = gqRecord.Split_Shipping__c;
                    opp.Split_Shipping_Details__c = gqRecord.Split_Shipping_Details__c;
                    opp.Diamond_Order_Information__c = gqRecord.Diamond_Order_Information__c;
                    opp.Fulfillment_Package__c = gqRecord.Fulfillment_Package__c;
                    opp.Fulfillment_Quantity__c = gqRecord.Fulfillment_Quantity__c;
                    opp.Display_Quantity__c = gqRecord.Order_Quantity_Marked_For_ROW__c;
                }
                
                if(gqRecord.Use_to_Calculate_ROW_1__c == 'Yes'){
                    opp.New_ROW__c = gqRecord.International_Grand_Total_1__c;
                    opp.Total_Quantity__c = gqRecord.Total_Quantity_1__c;
                    opp.Expedited_Quantity__c = gqRecord.Expedited_Quantity_1__c;
                    opp.Quoted_Product_Purchase_Cost__c = gqRecord.Product_Purchase_Cost_1__c;
                    opp.Quoted_Product_Purchase_Markup__c = gqRecord.Product_Markup_1__c;
                    opp.Quoted_Product_Price__c = gqRecord.Product_Total_Price_1__c;
                    opp.Quoted_Ocean_Freight_Cost__c = gqRecord.Ocean_Freight_Cost_1__c;
                    opp.Quoted_Ocean_Freight_Markup__c = gqRecord.Ocean_Freight_Markup_1__c;
                    opp.Quoted_Ocean_Freight__c = gqRecord.Ocean_Freight_Price_1__c;
                    opp.Quoted_International_Product_Price__c = gqRecord.International_Product_Price_1__c;
                    opp.Quoted_Tax__c = gqRecord.Tax_Dollars_1__c;
                    opp.Quoted_Ground_Freight_Cost__c = gqRecord.Ground_Freight_Cost_1__c;
                    opp.Quoted_Ground_Freight_Markup__c = gqRecord.Ground_Freight_Markup_1__c;
                    opp.Quoted_Ground_Freight__c = gqRecord.Ground_Freight_Price_1__c;
                    opp.Quoted_Expedited_Freight_Cost__c = gqRecord.Expedited_Freight_Cost_1__c;
                    opp.Quoted_Expedited_Freight_Markup__c = gqRecord.Expedited_Freight_Markup_1__c;
                    opp.Quoted_Expedited_Freight__c = gqRecord.Expedited_Freight_Price_1__c;
                    opp.Quantity_1__c = gqRecord.Total_Quantity_1__c;
                    opp.Tax_I__c = gqRecord.Tax_Dollars_1__c;
                    opp.Total_Selling_Int__c = gqRecord.International_Grand_Total_1__c;
                    opp.Additional_Charge_s_IA__c = gqRecord.Additional_Charges_1__c;
                    opp.Additional_Charges_s_IQ__c = checkNull(gqRecord.Assembly_Cost_1__c)+checkNull(gqRecord.Additional_Charges_1__c)+checkNull(gqRecord.Add_On_Price_1__c);//Updated by Sunil | 01-12-2018
                    opp.Proofing_Price__c = gqRecord.Prototyping_Cost_1__c;//Updated by Sunil | 01-12-2018
                }
                
                if(gqRecord.Use_to_Calculate_ROW_2__c == 'Yes'){
                    opp.New_ROW__c = gqRecord.International_Grand_Total_2__c;
                    opp.Total_Quantity__c = gqRecord.Total_Quantity_2__c;
                    opp.Expedited_Quantity__c = gqRecord.Expedited_Quantity_2__c;
                    opp.Quoted_Product_Purchase_Cost__c = gqRecord.Product_Purchase_Cost_2__c;
                    opp.Quoted_Product_Purchase_Markup__c = gqRecord.Product_Markup_2__c;
                    opp.Quoted_Product_Price__c = gqRecord.Product_Total_Price_2__c;
                    opp.Quoted_Ocean_Freight_Cost__c = gqRecord.Ocean_Freight_Cost_2__c;
                    opp.Quoted_Ocean_Freight_Markup__c = gqRecord.Ocean_Freight_Markup_2__c;
                    opp.Quoted_Ocean_Freight__c = gqRecord.Ocean_Freight_Price_2__c;
                    opp.Quoted_International_Product_Price__c = gqRecord.International_Product_Price_2__c;
                    opp.Quoted_Tax__c = gqRecord.Tax_Dollars_2__c;
                    opp.Quoted_Ground_Freight_Cost__c = gqRecord.Ground_Freight_Cost_2__c;
                    opp.Quoted_Ground_Freight_Markup__c = gqRecord.Ground_Freight_Markup_2__c;
                    opp.Quoted_Ground_Freight__c = gqRecord.Ground_Freight_Price_2__c;
                    opp.Quoted_Expedited_Freight_Cost__c = gqRecord.Expedited_Freight_Cost_2__c;
                    opp.Quoted_Expedited_Freight_Markup__c = gqRecord.Expedited_Freight_Markup_2__c;
                    opp.Quoted_Expedited_Freight__c = gqRecord.Expedited_Freight_Price_2__c;
                    opp.Quantity_1__c = gqRecord.Total_Quantity_2__c;
                    opp.Tax_I__c = gqRecord.Tax_Dollars_2__c;
                    opp.Total_Selling_Int__c = gqRecord.International_Grand_Total_2__c;
                    opp.Additional_Charge_s_IA__c = gqRecord.Additional_Charges_2__c;
                    opp.Additional_Charges_s_IQ__c = checkNull(gqRecord.Assembly_Cost_2__c)+checkNull(gqRecord.Additional_Charges_2__c)+checkNull(gqRecord.Add_On_Price_2__c);//Updated by Sunil | 01-12-2018
                    opp.Proofing_Price__c = gqRecord.Prototyping_Cost_2__c;//Updated by Sunil | 01-12-2018
                }
                
                if(gqRecord.Use_to_Calculate_ROW_3__c == 'Yes'){
                    opp.New_ROW__c = gqRecord.International_Grand_Total_3__c;
                    opp.Total_Quantity__c = gqRecord.Total_Quantity_3__c;
                    opp.Expedited_Quantity__c = gqRecord.Expedited_Quantity_3__c;
                    opp.Quoted_Product_Purchase_Cost__c = gqRecord.Product_Purchase_Cost_3__c;
                    opp.Quoted_Product_Purchase_Markup__c = gqRecord.Product_Markup_3__c;
                    opp.Quoted_Product_Price__c = gqRecord.Product_Total_Price_3__c;
                    opp.Quoted_Ocean_Freight_Cost__c = gqRecord.Ocean_Freight_Cost_3__c;
                    opp.Quoted_Ocean_Freight_Markup__c = gqRecord.Ocean_Freight_Markup_3__c;
                    opp.Quoted_Ocean_Freight__c = gqRecord.Ocean_Freight_Price_3__c;
                    opp.Quoted_International_Product_Price__c = gqRecord.International_Product_Price_3__c;
                    opp.Quoted_Tax__c = gqRecord.Tax_Dollars_3__c;
                    opp.Quoted_Ground_Freight_Cost__c = gqRecord.Ground_Freight_Cost_3__c;
                    opp.Quoted_Ground_Freight_Markup__c = gqRecord.Ground_Freight_Markup_3__c;
                    opp.Quoted_Ground_Freight__c = gqRecord.Ground_Freight_Price_3__c;
                    opp.Quoted_Expedited_Freight_Cost__c = gqRecord.Expedited_Freight_Cost_3__c;
                    opp.Quoted_Expedited_Freight_Markup__c = gqRecord.Expedited_Freight_Markup_3__c;
                    opp.Quoted_Expedited_Freight__c = gqRecord.Expedited_Freight_Price_3__c;
                    opp.Quantity_1__c = gqRecord.Total_Quantity_3__c;
                    opp.Tax_I__c = gqRecord.Tax_Dollars_3__c;
                    opp.Total_Selling_Int__c = gqRecord.International_Grand_Total_3__c;
                    opp.Additional_Charge_s_IA__c = gqRecord.Additional_Charges_3__c;
                    opp.Additional_Charges_s_IQ__c = checkNull(gqRecord.Assembly_Cost_3__c)+checkNull(gqRecord.Additional_Charges_3__c)+checkNull(gqRecord.Add_On_Price_3__c);//Updated by Sunil | 01-12-2018
                    opp.Proofing_Price__c = gqRecord.Prototyping_Cost_3__c;//Updated by Sunil | 01-12-2018
                }
                
                if(gqRecord.Use_to_Calculate_ROW_4__c == 'Yes'){
                    opp.New_ROW__c = gqRecord.International_Grand_Total_4__c;
                    opp.Total_Quantity__c = gqRecord.Total_Quantity_4__c;
                    opp.Expedited_Quantity__c = gqRecord.Expedited_Quantity_4__c;
                    opp.Quoted_Product_Purchase_Cost__c = gqRecord.Product_Purchase_Cost_4__c;
                    opp.Quoted_Product_Purchase_Markup__c = gqRecord.Product_Markup_4__c;
                    opp.Quoted_Product_Price__c = gqRecord.Product_Total_Price_4__c;
                    opp.Quoted_Ocean_Freight_Cost__c = gqRecord.Ocean_Freight_Cost_4__c;
                    opp.Quoted_Ocean_Freight_Markup__c = gqRecord.Ocean_Freight_Markup_4__c;
                    opp.Quoted_Ocean_Freight__c = gqRecord.Ocean_Freight_Price_4__c;
                    opp.Quoted_International_Product_Price__c = gqRecord.International_Product_Price_4__c;
                    opp.Quoted_Tax__c = gqRecord.Tax_Dollars_4__c;
                    opp.Quoted_Ground_Freight_Cost__c = gqRecord.Ground_Freight_Cost_4__c;
                    opp.Quoted_Ground_Freight_Markup__c = gqRecord.Ground_Freight_Markup_4__c;
                    opp.Quoted_Ground_Freight__c = gqRecord.Ground_Freight_Price_4__c;
                    opp.Quoted_Expedited_Freight_Cost__c = gqRecord.Expedited_Freight_Cost_4__c;
                    opp.Quoted_Expedited_Freight_Markup__c = gqRecord.Expedited_Freight_Markup_4__c;
                    opp.Quoted_Expedited_Freight__c = gqRecord.Expedited_Freight_Price_4__c;
                    opp.Quantity_1__c = gqRecord.Total_Quantity_4__c;
                    opp.Tax_I__c = gqRecord.Tax_Dollars_4__c;
                    opp.Total_Selling_Int__c = gqRecord.International_Grand_Total_4__c;
                    opp.Additional_Charge_s_IA__c = gqRecord.Additional_Charges_4__c;
                    opp.Additional_Charges_s_IQ__c = checkNull(gqRecord.Assembly_Cost_4__c)+checkNull(gqRecord.Additional_Charges_4__c)+checkNull(gqRecord.Add_On_Price_4__c);//Updated by Sunil | 01-12-2018
                    opp.Proofing_Price__c = gqRecord.Prototyping_Cost_4__c;//Updated by Sunil | 01-12-2018
                }
            }
            
            //Update Contact__c
            if(opp.Contact__c == null && accountContactMap.containsKey(opp.AccountId)){
                opp.Contact__c = accountContactMap.get(opp.AccountId);
            }
        }//End For loop
    }
    
    //Method to check null or not
    public static decimal checkNull(decimal inputValue){
        return (inputValue != null ? inputValue : 0);
    }
}