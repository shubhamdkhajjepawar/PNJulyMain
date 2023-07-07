trigger copyAnalysisInfofromQuote on Opportunity (before update) {
Opportunity[] oppList=Trigger.new;
// This Trigger will be used to copy Quote information where Use to Row Combination is Marked Yes to opportunity International && domestic analysis section. If opportunity is closed won
    for(Opportunity o:oppList)
    {
     List<Quote> quoteList= new QuoteHelper().getQuotesByOpportunityID(o.Id);
        if(o.StageName=='Closed Won' && String.isEmpty(o.Production_Status__c))
        {
        o.addError('Please update Production Status.');
        }
        else if(o.StageName=='Closed Lost' && String.isEmpty(o.Customer_Feedback__c))
        {
        o.addError('Please enter value in customer feedback.');
        }
        else if(o.StageName=='Closed Won' || o.StageName=='Reprint' || o.StageName=='Proof Won' || o.StageName=='Proposal/ Custom Quote' || o.StageName=='Proposal/ Online Blind Quote' || o.StageName=='Order Cancelled' || o.StageName=='Closed Lost')
        {
            for(Quote q:quoteList)
            {
                if((q.Use_to_Calculate_ROW_1__c=='Yes') || (q.Use_to_Calculate_ROW_2__c=='Yes') || (q.Use_to_Calculate_ROW_3__c=='Yes') || (q.Use_to_Calculate_ROW_4__c=='Yes'))
                {
                    o.Opportunity_Vendor__c='International';
                    //o.Quantity_2__c=null;
                    //o.Actual_Pur_Cost_D__c=null;
                    //o.Tax_D__c=null;
                    //o.Actual_Ground_Shipping_Cost_D__c=null;
                    //o.Additional_Charges_s_AD__c=null;
                    //o.Total_Selling_D__c=null;
                    o.Quoted_Product__c=q.Product__c;
                    o.Quoted_Product_Size__c=q.Product_Size__c;
                    o.Quoted_Page_Count__c=q.Page_Count__c;
                    o.Quoted_Binding__c=q.Binding__c;
                    o.newshipping_street__c=q.ShippingStreet;
                    o.newshipping_city__c=q.ShippingCity;
                    o.newshipping_state__c=q.ShippingState;
                    o.newshipping_postal_code__c=q.ShippingPostalCode;
                    o.newshipping_country__c=q.ShippingCountry;
                    o.newshipping_phone__c=q.Phone;
                    o.newshipping_residential__c=q.newshipping_residential__c;
                    o.Total_Product_Selling_Price__c=q.Total_Product_Selling_Price__c;
                    o.PRN_AS_Warehousing_Interest__c=q.PRN_AS_Warehousing_Interest__c;
                    o.PRN_AS_Fulfillment_Interest__c=q.PRN_AS_Fulfillment_Interest__c;
                    o.PRN_AS_Pick_And_Pack_Interest__c=q.PRN_AS_Pick_And_Pack_Interest__c;
                    o.PRN_headtailbands__c=q.PRN_headtailbands__c;
                    o.Amazon_Diamond__c=q.Amazon_Diamond__c;
                    o.PRN_variantcovers__c=q.PRN_variantcovers__c;
                    o.PRN_frenchfoldcovers__c=q.PRN_frenchfoldcovers__c;
                    o.Sequential_Foil_Numbering__c=q.Sequential_Foil_Numbering__c;
                    o.Shrink_Wrapping__c=q.Shrink_Wrapping__c;
                    o.Split_Shipping__c=q.Split_Shipping__c;
                    o.Split_Shipping_Details__c=q.Split_Shipping_Details__c;
                    o.Diamond_Order_Information__c=q.Diamond_Order_Information__c;
                    o.Fulfillment_Package__c=q.Fulfillment_Package__c;
                    o.Fulfillment_Quantity__c=q.Fulfillment_Quantity__c;
                    o.Prepress_Method__c=q.Prepress_Method__c;
                    o.Specialty_Options_Book__c=q.Specialty_Options_Book__c;
                    o.Ribbon_Color__c=q.Ribbon_Color__c;
                    o.PrePress_Dust_Jacket_Flap_Width__c=q.Dust_Jacket_Flap_Width__c;
                    o.Prepress_Dust_Jacket_Spine__c=q.Dust_Jacket_Spine_Width__c;
                    o.Prepress_French_Fold_Flap_Width__c=q.French_Fold_Flap_Width__c;
                    o.ISBN__c=q.ISBN__c;
                    o.Metallic_Ink_Color__c=q.Metallic_Ink_Color__c;
                    o.Number_of_Spot_Colors__c=q.Number_of_Spot_Colors__c;
                    o.PrePress_Spine__c=q.Spine_Width__c;
                    
                }
          
                if(q.Use_to_Calculate_ROW_1__c=='Yes')
                {
                     o.Int_l_Vendor__c=q.Int_l_Vendor_1__c;
                     o.Total_Quantity__c=q.Total_Quantity_1__c;
                     o.Expedited_Quantity__c=q.Expedited_Quantity_1__c;
                     o.Quoted_Product_Purchase_Cost__c=q.Product_Purchase_Cost1__c;
                     o.Quoted_Product_Purchase_Markup__c=q.Product_Purchase_Markup1__c;
                     o.Quoted_Product_Price__c=q.Product_i_Price1__c;
                     o.Quoted_Ocean_Freight_Cost__c=q.Ocean_Freight_1__c;
                     o.Quoted_Ocean_Freight_Markup__c=q.Ocean_Freight_Markup_i1__c;
                     o.Quoted_Ocean_Freight__c=q.Ocean_Freight_Price1__c;
                     o.Quoted_International_Product_Price__c=q.Product_Price_1__c;
                     o.Quoted_Tax__c=q.Tax;
                     o.Quoted_Ground_Freight_Cost__c=q.Grd_Freight_1__c;
                     o.Quoted_Ground_Freight_Markup__c=q.Ground_Freight_Markup_i1__c;
                     o.Quoted_Ground_Freight__c=q.Ground_Freight_Price1__c;
                     o.Quoted_Expedited_Freight_Cost__c=q.Expedited_Freight_1__c;
                     o.Quoted_Expedited_Freight_Markup__c=q.Expedited_Freight_Markup_i1__c;
                     o.Quoted_Expedited_Freight__c=q.Expedited_Freight_Price1__c;
                     o.Quoted_Discount_Reason__c=q.Discount_Reason_1__c;
                     o.Additional_Charges_s_IQ__c=q.Add_On_Price_1__c;
                     o.Quantity_1__c=q.Total_Quantity_1__c;
                     o.Tax_I__c=q.Tax;
                     o.Total_Selling_Int__c=q.International_Grand_Total_1__c;
                     o.Additional_Charge_s_IA__c=q.Add_On_Price_1__c;
                     o.Additional_Charges_s_IQ__c=q.Add_On_Price_1__c;
                }
                if(q.Use_to_Calculate_ROW_2__c=='Yes')
                {
                      o.Int_l_Vendor__c=q.Int_l_Vendor_2__c;
                      o.Total_Quantity__c=q.Total_Quantity_2__c;
                      o.Expedited_Quantity__c=q.Expedited_Quantity_2__c;
                      o.Quoted_Product_Purchase_Cost__c=q.Product_Purchase_Cost2__c;
                      o.Quoted_Product_Purchase_Markup__c=q.Product_Purchase_Markup2__c;
                      o.Quoted_Product_Price__c=q.Product_i_Price2__c;
                      o.Quoted_Ocean_Freight_Cost__c=q.Ocean_Freight_2__c;                       
                      o.Quoted_Ocean_Freight_Markup__c=q.Ocean_Freight_Markup_i2__c;
                      o.Quoted_Ocean_Freight__c=q.Ocean_Freight_Price2__c;
                      o.Quoted_International_Product_Price__c=q.Product_Price_2__c;
                      o.Quoted_Tax__c=q.Tax_2__c;
                      o.Quoted_Ground_Freight_Cost__c=q.Grd_Freight_2__c;
                      o.Quoted_Ground_Freight_Markup__c=q.Ground_Freight_Markup_i2__c;
                      o.Quoted_Ground_Freight__c=q.Ground_Freight_Price2__c;
                      o.Quoted_Expedited_Freight_Cost__c=q.Expedited_Freight_2__c;
                      o.Quoted_Expedited_Freight_Markup__c=q.Expedited_Freight_Markup_i2__c;
                      o.Quoted_Expedited_Freight__c=q.Expedited_Freight_Price2__c;
                      o.Quoted_Discount_Reason__c=q.Discount_Reason_2__c;
                      o.Additional_Charges_s_IQ__c=q.Add_On_Price_2__c;
                      o.Quantity_1__c=q.Total_Quantity_2__c;
                      o.Tax_I__c=q.Tax_2__c;
                      o.Total_Selling_Int__c=q.International_Grand_Total_2__c;
                      o.Additional_Charge_s_IA__c=q.Add_On_Price_2__c; 
                      o.Additional_Charges_s_IQ__c=q.Add_On_Price_2__c;
                }
                if(q.Use_to_Calculate_ROW_3__c=='Yes')
                {
                      o.Int_l_Vendor__c=q.Int_l_Vendor_3__c;
                      o.Total_Quantity__c=q.Total_Quantity_3__c;
                      o.Expedited_Quantity__c=q.Expedited_Quantity_3__c;
                      o.Quoted_Product_Purchase_Cost__c=q.Product_Purchase_Cost3__c;
                      o.Quoted_Product_Purchase_Markup__c=q.Product_Purchase_Markup3__c;
                      o.Quoted_Product_Price__c=q.Product_i_Price3__c;
                      o.Quoted_Ocean_Freight_Cost__c=q.Ocean_Freight_3__c;
                      o.Quoted_Ocean_Freight_Markup__c=q.Ocean_Freight_Markup_i3__c;
                      o.Quoted_Ocean_Freight__c=q.Ocean_Freight_Price3__c;
                      o.Quoted_International_Product_Price__c=q.Product_Price_3__c;
                      o.Quoted_Tax__c=q.Tax_3__c;
                      o.Quoted_Ground_Freight_Cost__c=q.Grd_Freight_3__c;
                      o.Quoted_Ground_Freight_Markup__c=q.Ground_Freight_Markup_i3__c;
                      o.Quoted_Ground_Freight__c=q.Ground_Freight_Price3__c;
                      o.Quoted_Expedited_Freight_Cost__c=q.Expedited_Freight_3__c;
                      o.Quoted_Expedited_Freight_Markup__c=q.Expedited_Freight_Markup_i3__c;
                      o.Quoted_Expedited_Freight__c=q.Expedited_Freight_Price3__c;
                      o.Quoted_Discount_Reason__c=q.Discount_Reason_3__c;
                      o.Additional_Charges_s_IQ__c=q.Add_On_Price_3__c;
                      o.Quantity_1__c=q.Total_Quantity_3__c;
                      o.Tax_I__c=q.Tax_3__c;
                      o.Total_Selling_Int__c=q.International_Grand_Total_3__c;
                      o.Additional_Charge_s_IA__c=q.Add_On_Price_3__c;
                      o.Additional_Charges_s_IQ__c=q.Add_On_Price_3__c;
                }
                if(q.Use_to_Calculate_ROW_4__c=='Yes')
                {
                     o.Int_l_Vendor__c=q.Int_l_Vendor_4__c;
                     o.Total_Quantity__c=q.Total_Quantity_4__c;
                     o.Expedited_Quantity__c=q.Expedited_Quantity_4__c;
                     o.Quoted_Product_Purchase_Cost__c=q.Product_Purchase_Cost4__c;
                     o.Quoted_Product_Purchase_Markup__c=q.Product_Purchase_Markup4__c;
                     o.Quoted_Product_Price__c=q.Product_i_Price4__c;
                     o.Quoted_Ocean_Freight_Cost__c=q.Ocean_Freight_4__c;
                     o.Quoted_Ocean_Freight_Markup__c=q.Ocean_Freight_Markup_i4__c;
                     o.Quoted_Ocean_Freight__c=q.Ocean_Freight_Price4__c;
                     o.Quoted_International_Product_Price__c=q.Product_Price_4__c;
                     o.Quoted_Tax__c=q.Tax_4__c;
                     o.Quoted_Ground_Freight_Cost__c=q.Grd_Freight_4__c;
                     o.Quoted_Ground_Freight_Markup__c=q.Ground_Freight_Markup_i4__c;
                     o.Quoted_Ground_Freight__c=q.Ground_Freight_Price4__c;
                     o.Quoted_Expedited_Freight_Cost__c=q.Expedited_Freight_4__c;
                     o.Quoted_Expedited_Freight_Markup__c=q.Expedited_Freight_Markup_i4__c;
                     o.Quoted_Expedited_Freight__c=q.Expedited_Freight_Price4__c;
                     o.Quoted_Discount_Reason__c=q.Discount_Reason_4__c;
                     o.Additional_Charges_s_IQ__c=q.Add_On_Price_4__c;
                     o.Quantity_1__c=q.Total_Quantity_4__c;
                     o.Tax_I__c=q.Tax_4__c;
                     o.Total_Selling_Int__c=q.International_Grand_Total_4__c;
                     o.Additional_Charge_s_IA__c=q.Add_On_Price_4__c;
                     o.Additional_Charges_s_IQ__c=q.Add_On_Price_4__c;
                }
                
                if((q.Use_to_Calculate_ROW_11__c=='Yes') || (q.Use_to_Calculate_ROW_12__c=='Yes') || (q.Use_to_Calculate_ROW_13__c=='Yes') || (q.Use_to_Calculate_ROW_14__c=='Yes'))
                {
                     o.Opportunity_Vendor__c='Domestic';
                    // o.Quantity_1__c=null;
                    // o.Tax_I__c=null;
                    // o.Total_Selling_Int__c=null; 
                    // o.Quoted_Product_Price__c=null;
                    // o.Quoted_Ocean_Freight__c=null;
                    // o.Quoted_Ground_Freight__c=null;
                     //o.Quoted_Tax__c=null;
                     //o.Additional_Charges_s_IQ__c=null;
                     //o.Quoted_Expedited_Freight__c=null;
                o.PRN_AS_Warehousing_Interest__c=q.PRN_AS_Warehousing_Interest__c;
                o.PRN_AS_Fulfillment_Interest__c=q.PRN_AS_Fulfillment_Interest__c;
                o.PRN_AS_Pick_And_Pack_Interest__c=q.PRN_AS_Pick_And_Pack_Interest__c;
                o.PRN_headtailbands__c=q.PRN_headtailbands__c;
                }
                if(q.Use_to_Calculate_ROW_11__c=='Yes')
                {
                     o.Quantity_2__c=q.Total_Quantity_11__c;
                     o.Tax_D__c=q.Tax_11__c;
                     o.Actual_Pur_Cost_D__c=q.Dom_Purch_Price_11__c;
                     o.Actual_Ground_Shipping_Cost_D__c=q.Domestic_Freight_Charge_11__c;
                     o.Total_Selling_D__c=q.Domestic_Grand_Total_11__c;
                     o.Actual_Ground_Shipping_Cost_D__c=q.Domestic_Freight_Charge_11__c;
                     o.Additional_Charges_s_AD__c=q.Additional_charge_s_11__c;
                     o.Total_Selling_D__c=q.Domestic_Grand_Total_11__c;  
                }
                if(q.Use_to_Calculate_ROW_12__c=='Yes')
                {
                     o.Quantity_2__c=q.Total_Quantity_12__c;
                     o.Tax_D__c=q.Tax_12__c;
                     o.Actual_Pur_Cost_D__c=q.Dom_Purch_Price_12__c;
                     o.Actual_Ground_Shipping_Cost_D__c=q.Domestic_Freight_Charge_12__c;
                     o.Total_Selling_D__c=q.Domestic_Grand_Total_12__c;
                     o.Actual_Ground_Shipping_Cost_D__c=q.Domestic_Freight_Charge_12__c;
                     o.Additional_Charges_s_AD__c=q.Additional_charge_s_12__c;
                     o.Total_Selling_D__c=q.Domestic_Grand_Total_12__c;  
                }
                if(q.Use_to_Calculate_ROW_13__c=='Yes')
                {
                    o.Quantity_2__c=q.Total_Quantity_13__c;
                     o.Tax_D__c=q.Tax_13__c;
                     o.Actual_Pur_Cost_D__c=q.Dom_Purch_Price_13__c;
                     o.Actual_Ground_Shipping_Cost_D__c=q.Domestic_Freight_Charge_13__c;
                     o.Total_Selling_D__c=q.Domestic_Grand_Total_13__c;
                     o.Actual_Ground_Shipping_Cost_D__c=q.Domestic_Freight_Charge_13__c;
                     o.Additional_Charges_s_AD__c=q.Additional_charge_s_13__c;
                     o.Total_Selling_D__c=q.Domestic_Grand_Total_13__c;  
                }
                if(q.Use_to_Calculate_ROW_14__c=='Yes')
                {
                    o.Quantity_2__c=q.Total_Quantity_14__c;
                     o.Tax_D__c=q.Tax_14__c;
                     o.Actual_Pur_Cost_D__c=q.Dom_Purch_Price_14__c;
                     o.Actual_Ground_Shipping_Cost_D__c=q.Domestic_Freight_Charge_14__c;
                     o.Total_Selling_D__c=q.Domestic_Grand_Total_14__c;
                     o.Actual_Ground_Shipping_Cost_D__c=q.Domestic_Freight_Charge_14__c;
                     o.Additional_Charges_s_AD__c=q.Additional_charge_s_14__c;
                     o.Total_Selling_D__c=q.Domestic_Grand_Total_14__c;  
                }
            }
        }
          for(Quote q:quoteList)
          {
            // Check for other  fields as well.
            if((o.StageName=='Closed Won' || o.StageName=='Reprint' || o.StageName=='Proof Won' || o.StageName=='Proposal/ Custom Quote' || o.StageName=='Proposal/ Online Blind Quote' || o.StageName=='Order Cancelled' || o.StageName=='Closed Lost') && ((q.Use_to_Calculate_ROW_1__c=='Yes') || (q.Use_to_Calculate_ROW_2__c=='Yes') || (q.Use_to_Calculate_ROW_3__c=='Yes') || (q.Use_to_Calculate_ROW_4__c=='Yes') || (q.Use_to_Calculate_ROW_11__c=='Yes') || (q.Use_to_Calculate_ROW_12__c=='Yes') || (q.Use_to_Calculate_ROW_13__c=='Yes') || (q.Use_to_Calculate_ROW_14__c=='Yes')))
            {
            o.PRN_additionalinfo__c=q.PRN_additionalinfo__c;
            //o.PRN_basicembossdeboss__c=q.PRN_basicembossdeboss__c;//PG 02/16/2023 - removed per direction from Jeff
            //o.PRN_basicfoilstamping__c=q.PRN_basicfoilstamping__c;//PG 02/16/2023 - removed per direction from Jeff
            o.PRN_bindingtype__c=q.PRN_bindingtype__c;
            o.PRN_corners__c=q.PRN_corners__c;
            o.PRN_coverpapercoating__c=q.PRN_coverpapercoating__c;
            o.PRN_coverpaperfinishstyle__c=q.PRN_coverpaperfinishstyle__c;
            o.PRN_coverpaperfinishtype__c=q.PRN_coverpaperfinishtype__c;
            o.PRN_coverpaperweight__c=q.PRN_coverpaperweight__c;
            o.PRN_dustjacket__c=q.PRN_dustjacket__c;
            o.PRN_dustjacketfinishstyle__c=q.PRN_dustjacketfinishstyle__c;
            o.PRN_endsheets__c=q.PRN_endsheets__c;
            o.PRN_height__c=q.PRN_height__c;
            o.PRN_insidepagecount__c=q.PRN_insidepagecount__c;
            o.PRN_insidepapercoating__c=q.PRN_insidepapercoating__c;
            o.PRN_insidepaperweight__c=q.PRN_insidepaperweight__c;
            o.PRN_printingcolor__c=q.PRN_printingcolor__c;
            o.PRN_printoninsidecoversendsheets__c=q.PRN_printoninsidecoversendsheets__c;
            o.PRN_proofing__c=q.PRN_proofing__c;
            //o.PRN_spotuv__c=q.PRN_spotuv__c;//PG 02/16/2023 - removed per direction from Jeff
            o.PRN_width__c=q.PRN_width__c;
            o.newshipping_liftgate__c=q.newshipping_liftgate__c;
            o.Foil_Stamp_Color__c=q.Foil_Stamp_Color__c;
            o.Faux_Leather_Cover_Options__c=q.Faux_Leather_Cover_Options__c;
            o.Fabric_Cover_Options__c=q.Fabric_Cover_Options__c;
            o.Texture_Options__c=q.Texture_Options__c;
    
            }
            if((o.StageName=='Closed Won' || o.StageName=='Reprint') && ((q.Use_to_Calculate_ROW_1__c=='Yes') || (q.Use_to_Calculate_ROW_2__c=='Yes') || (q.Use_to_Calculate_ROW_3__c=='Yes') || (q.Use_to_Calculate_ROW_4__c=='Yes') || (q.Use_to_Calculate_ROW_11__c=='Yes') || (q.Use_to_Calculate_ROW_12__c=='Yes') || (q.Use_to_Calculate_ROW_13__c=='Yes') || (q.Use_to_Calculate_ROW_14__c=='Yes')))
            {
            o.Display_Quantity__c=q.Order_Quantity_Marked_For_ROW__c;

            }
        }
        
    }

}