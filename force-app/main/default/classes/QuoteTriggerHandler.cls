public with sharing class QuoteTriggerHandler {
    /**
     * Method called on before insert
     */
    public static void onBeforeInsert(list<Quote> newRecords) {
        //Iterate Quote
        set<string> opportunityIds = new set<string>();
        map<string, list<Quote>> oppQuoteMap = new map<string, list<Quote>>();
        for(Quote quote: newRecords){
            if(quote.ContactId == null || quote.Email == null || quote.Phone == null){
                opportunityIds.add(quote.OpportunityId);
            }
            if(quote.OpportunityId != null){
                oppQuoteMap.put(quote.OpportunityId, new list<Quote>());
            }
        }
        
        map<string, string> opportunityAccountId = new map<string, string>();
        for(Opportunity opp:[SELECT Id, AccountId FROM Opportunity WHERE Id IN: opportunityIds]){
            opportunityAccountId.put(opp.Id, opp.AccountId);
        }
        
        map<string, Contact> accountContactMap = new map<string, Contact>();
        for(Account acc : [SELECT Id, (SELECT Id, Email, Phone FROM Contacts order by Is_Primary__c desc limit 1) FROM Account WHERE Id IN : opportunityAccountId.values()]){
            if(acc.Contacts.size() > 0){
                accountContactMap.put(acc.Id, acc.Contacts.get(0));
            }
        }
        
        for(Quote cgq: [SELECT OpportunityId, Use_to_Calculate_ROW_1__c, Use_to_Calculate_ROW_2__c, Use_to_Calculate_ROW_3__c, Use_to_Calculate_ROW_4__c, Use_to_Calculate_ROW_11__c, Use_to_Calculate_ROW_12__c, Use_to_Calculate_ROW_13__c, Use_to_Calculate_ROW_14__c FROM Quote WHERE OpportunityId IN: oppQuoteMap.keySet()]){
            oppQuoteMap.get(cgq.OpportunityId).add(cgq);
        }
        
        //Markup custom setting data
        map<string, CustomMarkupConfiguration__c> cmcMap = CustomMarkupConfiguration__c.getAll();
        
        //Re-iterate Quote
        for(Quote quote: newRecords){
            Integer existingCount = (oppQuoteMap.containsKey(quote.OpportunityId) ? calRowExistingQuote(oppQuoteMap.get(quote.OpportunityId)) : 0);
            Integer currentCount = calRowCurrentQuote(quote);
            Integer totalCount = existingCount + currentCount;
            if(totalCount > 1){
                quote.addError('Only one quote combination can be used to calculate ROW for each Opportunity');
            }
            quote.Is_Used_To_Calculate_Row__c = (currentCount == 1 ? true : false); 
            
            if(opportunityAccountId.containsKey(quote.OpportunityId) && accountContactMap.containsKey(opportunityAccountId.get(quote.OpportunityId))){
                Contact con = accountContactMap.get(opportunityAccountId.get(quote.OpportunityId));
                if(quote.ContactId == null){
                    quote.ContactId = con.Id;
                }
                if(quote.Email == null){
                    quote.Email = con.Email;
                }
                if(quote.Phone == null){
                    quote.Phone = con.Phone;
                }
            }
            
            if(quote.Product_i_Price1__c != null || quote.Ocean_Freight_Price1__c != null){
                quote.Product_Price_1__c = (quote.Product_i_Price1__c == null?0:quote.Product_i_Price1__c)+(quote.Ocean_Freight_Price1__c == null?0:quote.Ocean_Freight_Price1__c);
            }else{
                quote.Product_Price_1__c = null;
            }
            
            if(quote.Product_i_Price2__c != null || quote.Ocean_Freight_Price2__c != null){
                quote.Product_Price_2__c = (quote.Product_i_Price2__c == null?0:quote.Product_i_Price2__c)+(quote.Ocean_Freight_Price2__c == null?0:quote.Ocean_Freight_Price2__c);
            }else{
                quote.Product_Price_2__c = null;
            }
            
            if(quote.Product_i_Price3__c != null || quote.Ocean_Freight_Price3__c != null){
                quote.Product_Price_3__c = (quote.Product_i_Price3__c == null?0:quote.Product_i_Price3__c)+(quote.Ocean_Freight_Price3__c == null?0:quote.Ocean_Freight_Price3__c);
            }else{
                quote.Product_Price_3__c = null;
            }
            
            if(quote.Product_i_Price4__c != null || quote.Ocean_Freight_Price4__c != null){
                quote.Product_Price_4__c = (quote.Product_i_Price4__c == null?0:quote.Product_i_Price4__c)+(quote.Ocean_Freight_Price4__c == null?0:quote.Ocean_Freight_Price4__c);
            }else{
                quote.Product_Price_4__c = null;
            }
            /*
            if(quote.Ocean_Freight_Markup_i1__c == null){
                quote.Ocean_Freight_Markup_i1__c = 35;
            }
            
            if(quote.Ground_Freight_Markup_i1__c == null){
                quote.Ground_Freight_Markup_i1__c = 35;
            }
            
            if(quote.Expedited_Freight_Markup_i1__c == null){
                quote.Expedited_Freight_Markup_i1__c = 35;
            }
            
            //Markup custom setting data
            if(quote.Product_Purchase_Cost1__c != null){
                for(CustomMarkupConfiguration__c cmc: cmcMap.values()){
                    if(cmc.Cost_Low__c != null && cmc.Cost_Max__c != null){
                        if(quote.Product_Purchase_Cost1__c > cmc.Cost_Low__c && quote.Product_Purchase_Cost1__c <= cmc.Cost_Max__c){
                            if(quote.PRN_bindingtype__c == 'Saddle stitching' || quote.PRN_bindingtype__c == 'Perfect (Softcover)'){
                                quote.Product_Purchase_Markup1__c = cmc.Saddle_Perfect_Binding_Printing_Cost_Mar__c;
                            }else if(quote.PRN_bindingtype__c == 'Case (Hardcover)' || quote.PRN_bindingtype__c == 'Split Perfect / Case'){
                                quote.Product_Purchase_Markup1__c = cmc.Case_Binding_Printing_Cost_Markup__c;
                            }else if(quote.PRN_bindingtype__c == 'Board Book'){
                                quote.Product_Purchase_Markup1__c = cmc.Board_Book_Printing_Cost_Markup__c;
                            }else if(quote.PRN_bindingtype__c == 'Wire binding' || quote.PRN_bindingtype__c == 'Spiral binding'){
                                quote.Product_Purchase_Markup1__c = cmc.Saddle_Perfect_Binding_Printing_Cost_Mar__c;
                            }
                            break;
                        }
                    }
                }
            }//End
            
            //Markup custom setting data
            if(quote.Additional_charge_s_1__c != null){
                for(CustomMarkupConfiguration__c cmc: cmcMap.values()){
                    if(cmc.Cost_Low__c != null && cmc.Cost_Max__c != null){
                        if(quote.Additional_charge_s_1__c > cmc.Cost_Low__c && quote.Additional_charge_s_1__c <= cmc.Cost_Max__c){
                            quote.Add_On_Markup_1__c = cmc.Add_On_Cost_Markup__c;
                            break;
                        }
                    }
                }
            }//End
            */
        }
    }
    
    /**
     * Method called on before update
     */
    public static void onBeforeUpdate(list<Quote> newRecords, map<Id, Quote> oldRecordMap) {
        //Iterate Quote
        set<string> setCurrentQuoteIds = new set<string>();
        map<string, list<Quote>> oppQuoteMap = new map<string, list<Quote>>();
        for(Quote quote: newRecords){
            if(quote.OpportunityId != null){
                setCurrentQuoteIds.add(quote.Id);
                oppQuoteMap.put(quote.OpportunityId, new list<Quote>());
            }
        }
        
        for(Quote cgq: [SELECT OpportunityId, Use_to_Calculate_ROW_1__c, Use_to_Calculate_ROW_2__c, Use_to_Calculate_ROW_3__c, Use_to_Calculate_ROW_4__c, Use_to_Calculate_ROW_11__c, Use_to_Calculate_ROW_12__c, Use_to_Calculate_ROW_13__c, Use_to_Calculate_ROW_14__c FROM Quote WHERE Id NOT IN: setCurrentQuoteIds AND OpportunityId IN: oppQuoteMap.keySet()]){
            oppQuoteMap.get(cgq.OpportunityId).add(cgq);
        }
        
        //Markup custom setting data
        map<string, CustomMarkupConfiguration__c> cmcMap = CustomMarkupConfiguration__c.getAll();
        
        //Re-Iterate Quote
        for(Quote quote: newRecords){
            Integer existingCount = (oppQuoteMap.containsKey(quote.OpportunityId) ? calRowExistingQuote(oppQuoteMap.get(quote.OpportunityId)) : 0);
            Integer currentCount = calRowCurrentQuote(quote);
            Integer totalCount = existingCount + currentCount;
            if(totalCount > 1){
                quote.addError('Only one quote combination can be used to calculate ROW for each Opportunity');
            }
            quote.Is_Used_To_Calculate_Row__c = (currentCount == 1 ? true : false); 
            
            if(quote.Product_i_Price1__c != null || quote.Ocean_Freight_Price1__c != null){
                quote.Product_Price_1__c = (quote.Product_i_Price1__c == null?0:quote.Product_i_Price1__c)+(quote.Ocean_Freight_Price1__c == null?0:quote.Ocean_Freight_Price1__c);
            }else{
                quote.Product_Price_1__c = null;
            }
            
            if(quote.Product_i_Price2__c != null || quote.Ocean_Freight_Price2__c != null){
                quote.Product_Price_2__c = (quote.Product_i_Price2__c == null?0:quote.Product_i_Price2__c)+(quote.Ocean_Freight_Price2__c == null?0:quote.Ocean_Freight_Price2__c);
            }else{
                quote.Product_Price_2__c = null;
            }
            
            if(quote.Product_i_Price3__c != null || quote.Ocean_Freight_Price3__c != null){
                quote.Product_Price_3__c = (quote.Product_i_Price3__c == null?0:quote.Product_i_Price3__c)+(quote.Ocean_Freight_Price3__c == null?0:quote.Ocean_Freight_Price3__c);
            }else{
                quote.Product_Price_3__c = null;
            }
            
            if(quote.Product_i_Price4__c != null || quote.Ocean_Freight_Price4__c != null){
                quote.Product_Price_4__c = (quote.Product_i_Price4__c == null?0:quote.Product_i_Price4__c)+(quote.Ocean_Freight_Price4__c == null?0:quote.Ocean_Freight_Price4__c);
            }else{
                quote.Product_Price_4__c = null;
            }
            
            /*
            if(quote.Ocean_Freight_Markup_i1__c == null){
                quote.Ocean_Freight_Markup_i1__c = 35;
            }
            
            if(quote.Ground_Freight_Markup_i1__c == null){
                quote.Ground_Freight_Markup_i1__c = 35;
            }
            
            if(quote.Expedited_Freight_Markup_i1__c == null){
                quote.Expedited_Freight_Markup_i1__c = 35;
            }
            
            //Markup custom setting data
            if(quote.Product_Purchase_Cost1__c != null){
                for(CustomMarkupConfiguration__c cmc: cmcMap.values()){
                    if(cmc.Cost_Low__c != null && cmc.Cost_Max__c != null){
                        if(quote.Product_Purchase_Cost1__c > cmc.Cost_Low__c && quote.Product_Purchase_Cost1__c <= cmc.Cost_Max__c){
                            if(quote.PRN_bindingtype__c == 'Saddle stitching' || quote.PRN_bindingtype__c == 'Perfect (Softcover)'){
                                quote.Product_Purchase_Markup1__c = cmc.Saddle_Perfect_Binding_Printing_Cost_Mar__c;
                            }else if(quote.PRN_bindingtype__c == 'Case (Hardcover)' || quote.PRN_bindingtype__c == 'Split Perfect / Case'){
                                quote.Product_Purchase_Markup1__c = cmc.Case_Binding_Printing_Cost_Markup__c;
                            }else if(quote.PRN_bindingtype__c == 'Board Book'){
                                quote.Product_Purchase_Markup1__c = cmc.Board_Book_Printing_Cost_Markup__c;
                            }else if(quote.PRN_bindingtype__c == 'Wire binding' || quote.PRN_bindingtype__c == 'Spiral binding'){
                                quote.Product_Purchase_Markup1__c = cmc.Saddle_Perfect_Binding_Printing_Cost_Mar__c;
                            }
                            break;
                        }
                    }
                }
            }//End
            
            //Markup custom setting data
            if(quote.Additional_charge_s_1__c != null){
                for(CustomMarkupConfiguration__c cmc: cmcMap.values()){
                    if(cmc.Cost_Low__c != null && cmc.Cost_Max__c != null){
                        if(quote.Additional_charge_s_1__c > cmc.Cost_Low__c && quote.Additional_charge_s_1__c <= cmc.Cost_Max__c){
                            quote.Add_On_Markup_1__c = cmc.Add_On_Cost_Markup__c;
                            break;
                        }
                    }
                }
            }//End
            */
        }
    }
    
    /**
     * Method called on after insert
     */
    public static void onAfterInsert(list<Quote> newRecords) {
        map<string, Quote> oppQuoteMap = new map<string, Quote>();
        //Iterate Quote
        for(Quote quote: newRecords){
            if(quote.OpportunityId != null){
                oppQuoteMap.put(quote.OpportunityId, quote);
            }
        }
        updateOpportunities(oppQuoteMap);
    }
    
    /**
     * Method called on after update
     */
    public static void onAfterUpdate(list<Quote> newRecords, map<Id, Quote> oldRecordMap) {
        map<string, Quote> oppQuoteMap = new map<string, Quote>();
        //Iterate Quote
        for(Quote quote: newRecords){
            if(quote.OpportunityId != null){
                oppQuoteMap.put(quote.OpportunityId, quote);
            }
        }
        updateOpportunities(oppQuoteMap);
    }
    
    //Method to update quote
    public static void updateOpportunities(map<string, Quote> mapQuotes){
        list<Opportunity> opportunityToUpdate = new list<Opportunity>();
        for(Opportunity opp: [SELECT Id FROM Opportunity WHERE Id IN : mapQuotes.keySet()]){
            if(mapQuotes.containsKey(opp.Id)){
                Quote quote = mapQuotes.get(opp.Id);
                if(quote.Use_to_Calculate_ROW_1__c=='Yes'){
                    opp.New_ROW__c=quote.International_Grand_Total_1__c;
                    opp.PRN_Remark__c=quote.Remark_1__c;
                }
                if(quote.Use_to_Calculate_ROW_2__c=='Yes'){
                    opp.New_ROW__c=quote.International_Grand_Total_2__c;
                    opp.PRN_Remark__c=quote.Remark_2__c;
                }
                if(quote.Use_to_Calculate_ROW_3__c=='Yes'){
                    opp.New_ROW__c=quote.International_Grand_Total_3__c;
                    opp.PRN_Remark__c=quote.Remark_3__c;
                }
                if(quote.Use_to_Calculate_ROW_4__c=='Yes'){
                    opp.New_ROW__c=quote.International_Grand_Total_4__c;
                    opp.PRN_Remark__c=quote.Remark_4__c;
                }
                if(quote.Use_to_Calculate_ROW_11__c=='Yes'){
                    opp.New_ROW__c=quote.Domestic_Grand_Total_11__c;
                }
                if(quote.Use_to_Calculate_ROW_12__c=='Yes'){
                    opp.New_ROW__c=quote.Domestic_Grand_Total_12__c;
                }
                if(quote.Use_to_Calculate_ROW_13__c=='Yes'){
                    opp.New_ROW__c=quote.Domestic_Grand_Total_13__c;
                }
                if(quote.Use_to_Calculate_ROW_14__c=='Yes'){
                    opp.New_ROW__c=quote.Domestic_Grand_Total_14__c;
                }
                opportunityToUpdate.add(opp);
            }
        }
        
        if(opportunityToUpdate.size() > 0){
            update opportunityToUpdate;
        }
    }
    
    //Method to calculate Row Existing Quote
    public static integer calRowExistingQuote(list<Quote> existingQuote){
        Integer countSet =  0;
        for(Quote quote: existingQuote){
            if(quote.Use_to_Calculate_ROW_1__c == 'Yes'){
                countSet++;
            }
            if(quote.Use_to_Calculate_ROW_2__c == 'Yes'){
                countSet++;
            }
            if(quote.Use_to_Calculate_ROW_3__c == 'Yes'){
                countSet++;
            }
            if(quote.Use_to_Calculate_ROW_4__c == 'Yes'){
                countSet++;
            }
            if(quote.Use_to_Calculate_ROW_11__c == 'Yes'){
                countSet++;
            }
            if(quote.Use_to_Calculate_ROW_12__c == 'Yes'){
                countSet++;
            }
            if(quote.Use_to_Calculate_ROW_13__c == 'Yes'){
                countSet++;
            }
            if(quote.Use_to_Calculate_ROW_14__c == 'Yes'){
                countSet++;
            }
        }
        return countSet;
    }
    
    //Method to calculate Row Current Quote
    public static integer calRowCurrentQuote(Quote quote){
        Integer countSet =  0;
        if(quote.Use_to_Calculate_ROW_1__c == 'Yes'){
            countSet++;
        }
        if(quote.Use_to_Calculate_ROW_2__c == 'Yes'){
            countSet++;
        }
        if(quote.Use_to_Calculate_ROW_3__c == 'Yes'){
            countSet++;
        }
        if(quote.Use_to_Calculate_ROW_4__c == 'Yes'){
            countSet++;
        }
        if(quote.Use_to_Calculate_ROW_11__c == 'Yes'){
            countSet++;
        }
        if(quote.Use_to_Calculate_ROW_12__c == 'Yes'){
            countSet++;
        }
        if(quote.Use_to_Calculate_ROW_13__c == 'Yes'){
            countSet++;
        }
        if(quote.Use_to_Calculate_ROW_14__c == 'Yes'){
            countSet++;
        }
        return countSet;
    }
}