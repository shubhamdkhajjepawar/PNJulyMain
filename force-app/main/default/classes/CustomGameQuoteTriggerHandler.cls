public with sharing class CustomGameQuoteTriggerHandler {
    /**
     * Method called on before insert
     */
    public static void onBeforeInsert(list<Custom_Game_Quote__c> newRecords) {
        //Iterate Quote
        map<string, list<Custom_Game_Quote__c>> oppQuoteMap = new map<string, list<Custom_Game_Quote__c>>();
        for(Custom_Game_Quote__c quote: newRecords){
        	if(quote.OpportunityId__c != null){
	            oppQuoteMap.put(quote.OpportunityId__c, new list<Custom_Game_Quote__c>());
        	}
        }
        
        for(Custom_Game_Quote__c cgq: [SELECT OpportunityId__c, Use_to_Calculate_ROW_1__c, Use_to_Calculate_ROW_2__c, Use_to_Calculate_ROW_3__c, Use_to_Calculate_ROW_4__c FROM Custom_Game_Quote__c WHERE OpportunityId__c IN: oppQuoteMap.keySet()]){
        	oppQuoteMap.get(cgq.OpportunityId__c).add(cgq);
        }
        
        //Re-Iterate Quote
        for(Custom_Game_Quote__c quote: newRecords){
            Integer existingCount = (oppQuoteMap.containsKey(quote.OpportunityId__c) ? calRowExistingQuote(oppQuoteMap.get(quote.OpportunityId__c)) : 0);
            Integer currentCount = calRowCurrentQuote(quote);
            Integer totalCount = existingCount + currentCount;
            if(totalCount > 1){
                quote.addError('Only one quote combination can be used to calculate ROW for each Opportunity');
            }
            quote.Is_Used_To_Calculate_Row__c = (currentCount == 1 ? true : false);
            
            if(quote.Quote_From_Calculator__c != TRUE){
                quote.Ground_Freight_Cost_1__c = null;
                quote.Ground_Freight_Cost_2__c = null;
                quote.Ground_Freight_Cost_3__c = null;
                quote.Ground_Freight_Cost_4__c = null;
                quote.Ground_Freight_Markup_1__c =null;
                quote.Ground_Freight_Markup_2__c =null;
                quote.Ground_Freight_Markup_3__c =null;
                quote.Ground_Freight_Markup_4__c =null;
                quote.Tax_1__c = null;
                quote.Tax_2__c = null;
                quote.Tax_3__c = null;
                quote.Tax_4__c = null;
                quote.Ocean_Freight_Cost_1__c = null;
                quote.Ocean_Freight_Cost_2__c = null;
                quote.Ocean_Freight_Cost_3__c = null;
                quote.Ocean_Freight_Cost_4__c = null;
                quote.Ocean_Freight_Markup_1__c = null;
                quote.Ocean_Freight_Markup_2__c = null;
                quote.Ocean_Freight_Markup_3__c = null;
                quote.Ocean_Freight_Markup_4__c = null;
                quote.Expedited_Freight_Cost_1__c = null;
                quote.Expedited_Freight_Cost_2__c = null;
                quote.Expedited_Freight_Cost_3__c = null;
                quote.Expedited_Freight_Cost_4__c = null;
                quote.Expedited_Freight_Markup_1__c = null;
                quote.Expedited_Freight_Markup_2__c = null;
                quote.Expedited_Freight_Markup_3__c = null;
                quote.Expedited_Freight_Markup_4__c = null;
            } 
        }
    }
    
    /**
     * Method called on before update
     */
    public static void onBeforeUpdate(list<Custom_Game_Quote__c> newRecords, map<Id, Custom_Game_Quote__c> oldRecordMap) {        
        //Iterate Quote
        set<string> setCurrentQuoteIds = new set<string>();
        map<string, list<Custom_Game_Quote__c>> oppQuoteMap = new map<string, list<Custom_Game_Quote__c>>();
        for(Custom_Game_Quote__c quote: newRecords){
        	if(quote.OpportunityId__c != null){
	            setCurrentQuoteIds.add(quote.Id);
	            oppQuoteMap.put(quote.OpportunityId__c, new list<Custom_Game_Quote__c>());
        	}
        }
        
        for(Custom_Game_Quote__c cgq: [SELECT OpportunityId__c, Use_to_Calculate_ROW_1__c, Use_to_Calculate_ROW_2__c, Use_to_Calculate_ROW_3__c, Use_to_Calculate_ROW_4__c FROM Custom_Game_Quote__c WHERE Id NOT IN: setCurrentQuoteIds AND OpportunityId__c IN: oppQuoteMap.keySet()]){
        	oppQuoteMap.get(cgq.OpportunityId__c).add(cgq);
        }
        
        //Re-Iterate Quote
        for(Custom_Game_Quote__c quote: newRecords){
        	Integer existingCount = (oppQuoteMap.containsKey(quote.OpportunityId__c) ? calRowExistingQuote(oppQuoteMap.get(quote.OpportunityId__c)) : 0);
            Integer currentCount = calRowCurrentQuote(quote);
            Integer totalCount = existingCount + currentCount;
            if(totalCount > 1){
                quote.addError('Only one quote combination can be used to calculate ROW for each Opportunity');
            }
            quote.Is_Used_To_Calculate_Row__c = (currentCount == 1 ? true : false); 
        }
    }
    
    //Method to calculate Row Existing Quote
    public static integer calRowExistingQuote(list<Custom_Game_Quote__c> existingQuote){
        Integer countSet =  0;
        for(Custom_Game_Quote__c quote: existingQuote){
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
        }
        return countSet;
    }
    
    //Method to calculate Row Current Quote
    public static integer calRowCurrentQuote(Custom_Game_Quote__c quote){
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
        return countSet;
    }
}