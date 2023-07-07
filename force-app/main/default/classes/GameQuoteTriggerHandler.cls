public with sharing class GameQuoteTriggerHandler {
    /**
    * Method called on before insert
    */
    public static void onBeforeInsert(list<Game_Quote__c> newRecords) {
        //Iterate Quote
        map<string, list<Game_Quote__c>> oppQuoteMap = new map<string, list<Game_Quote__c>>();
        for(Game_Quote__c quote: newRecords){
        	if(quote.OpportunityId__c != null){
	            oppQuoteMap.put(quote.OpportunityId__c, new list<Game_Quote__c>());
        	}
        }
        
        for(Game_Quote__c cgq: [SELECT OpportunityId__c, Use_to_Calculate_ROW_1__c, Use_to_Calculate_ROW_2__c FROM Game_Quote__c WHERE OpportunityId__c IN: oppQuoteMap.keySet()]){
        	oppQuoteMap.get(cgq.OpportunityId__c).add(cgq);
        }
        
        //Re-Iterate Quote
        for(Game_Quote__c quote: newRecords){
            Integer existingCount = (oppQuoteMap.containsKey(quote.OpportunityId__c) ? calRowExistingQuote(oppQuoteMap.get(quote.OpportunityId__c)) : 0);
            Integer currentCount = calRowCurrentQuote(quote);
            Integer totalCount = existingCount + currentCount;
            if(totalCount > 1){
                quote.addError('Only one quote combination can be used to calculate ROW for each Opportunity');
            }
            quote.Is_Used_To_Calculate_Row__c = (currentCount == 1 ? true : false); 
            
            if(quote.Quote_From_Calculator__c != TRUE){
                quote.Grd_Freight_1__c=null;
                quote.Grd_Freight_2__c=null;
                quote.Ground_Freight_Markup_i1__c=null;
                quote.Ground_Freight_Markup_i2__c=null;
                quote.Ocean_Freight_1__c=null;
                quote.Ocean_Freight_2__c=null;
                quote.Ocean_Freight_Markup_i1__c=null;
                quote.Ocean_Freight_Markup_i2__c=null;
                quote.Expedited_Freight_1__c=null;
                quote.Expedited_Freight_1__c=null;
                quote.Expedited_Freight_Markup_i1__c=null;
                quote.Expedited_Freight_Markup_i2__c=null;
            }
        }
    }
    
    /**
    * Method called on before update
    */
    public static void onBeforeUpdate(list<Game_Quote__c> newRecords, map<Id, Game_Quote__c> oldRecordMap) {
        //Iterate Quote
        set<string> setCurrentQuoteIds = new set<string>();
        map<string, list<Game_Quote__c>> oppQuoteMap = new map<string, list<Game_Quote__c>>();
        for(Game_Quote__c quote: newRecords){
        	if(quote.OpportunityId__c != null){
	            setCurrentQuoteIds.add(quote.Id);
	            oppQuoteMap.put(quote.OpportunityId__c, new list<Game_Quote__c>());
        	}
        }
        
        for(Game_Quote__c cgq: [SELECT OpportunityId__c, Use_to_Calculate_ROW_1__c, Use_to_Calculate_ROW_2__c FROM Game_Quote__c WHERE Id NOT IN: setCurrentQuoteIds AND OpportunityId__c IN: oppQuoteMap.keySet()]){
        	oppQuoteMap.get(cgq.OpportunityId__c).add(cgq);
        }
        
        //Re-Iterate Quote
        for(Game_Quote__c quote: newRecords){
        	Integer existingCount = (oppQuoteMap.containsKey(quote.OpportunityId__c) ? calRowExistingQuote(oppQuoteMap.get(quote.OpportunityId__c)) : 0);
            Integer currentCount = calRowCurrentQuote(quote);
            Integer totalCount = existingCount + currentCount;
            if(totalCount > 1){
                quote.addError('Only one quote combination can be used to calculate ROW for each Opportunity');
            }
            quote.Is_Used_To_Calculate_Row__c = (currentCount == 1 ? true : false); 
            
            if (quote.gq_2pcbox_selectedforquote_1__c==FALSE){
                quote.gq_2pcbox_componentpurchasecost_q1_1__c=null;
                quote.gq_2pcbox_componentpurchasecost_q2_1__c=null;
            }
            if (quote.gq_obi_selectedforquote_1__c==FALSE){
                quote.gq_obi_componentpurchasecost_q1_1__c=null;
                quote.gq_obi_componentpurchasecost_q2_1__c=null;
            }
            if (quote.gq_cards_selectedforquote_1__c==FALSE){
                quote.gq_cards_componentpurchasecost_q1_1__c=null;
                quote.gq_cards_componentpurchasecost_q2_1__c=null;
            }
            if (quote.gq_cards_selectedforquote_2__c==FALSE){
                quote.gq_cards_componentpurchasecost_q1_2__c=null;
                quote.gq_cards_componentpurchasecost_q2_2__c=null;
            }
            if (quote.gq_cards_selectedforquote_3__c==FALSE){
                quote.gq_cards_componentpurchasecost_q1_3__c=null;
                quote.gq_cards_componentpurchasecost_q2_3__c=null;
            }
            if (quote.gq_cards_selectedforquote_4__c==FALSE){
                quote.gq_cards_componentpurchasecost_q1_4__c=null;
                quote.gq_cards_componentpurchasecost_q2_4__c=null;
            }
            if (quote.gq_ib_selectedforquote_1__c==FALSE){
                quote.gq_ib_componentpurchasecost_q1_1__c=null;
                quote.gq_ib_componentpurchasecost_q2_1__c=null;
            }
            if (quote.gq_pp_selectedforquote_1__c==FALSE){
                quote.gq_pp_componentpurchasecost_q1_1__c=null;
                quote.gq_pp_componentpurchasecost_q2_1__c=null;
            }
            if (quote.gq_gb_selectedforquote_1__c==FALSE){
                quote.gq_gb_componentpurchasecost_q1_1__c=null;
                quote.gq_gb_componentpurchasecost_q2_1__c=null;
            }
            if (quote.gq_rp_selectedforquote_1__c==FALSE){
                quote.gq_rp_componentpurchasecost_q1_1__c=null;
                quote.gq_rp_componentpurchasecost_q2_1__c=null;
            }
            if (quote.gq_cmts_selectedforquote_1__c==FALSE){
                quote.gq_cmts_componentpurchasecost_q1_1__c=null;
                quote.gq_cmts_componentpurchasecost_q2_1__c=null;
            }
            if (quote.gq_cmts_selectedforquote_2__c==FALSE){
                quote.gq_cmts_componentpurchasecost_q1_2__c=null;
                quote.gq_cmts_componentpurchasecost_q2_2__c=null;
            }
            if (quote.gq_cpo_selectedforquote_1__c==FALSE){
                quote.gq_cpo_componentpurchasecost_q1_1__c=null;
                quote.gq_cpo_componentpurchasecost_q2_1__c=null;
            }
            if (quote.gq_cpo_selectedforquote_2__c==FALSE){
                quote.gq_cpo_componentpurchasecost_q1_2__c=null;
                quote.gq_cpo_componentpurchasecost_q2_2__c=null;
            }
            if (quote.gq_premadepcs_selectedforquote_1__c==FALSE){
                quote.gq_premadepcs_componentpurchasecost_q1_1__c=null;
                quote.gq_premadepcs_componentpurchasecost_q2_1__c=null;
            }
            if (quote.gq_premadepcs_selectedforquote_2__c==FALSE){
                quote.gq_premadepcs_componentpurchasecost_q1_2__c=null;
                quote.gq_premadepcs_componentpurchasecost_q2_2__c=null;
            }
            if (quote.gq_premadepcs_selectedforquote_3__c==FALSE){
                quote.gq_premadepcs_componentpurchasecost_q1_3__c=null;
                quote.gq_premadepcs_componentpurchasecost_q2_3__c=null;
            }
            if (quote.gq_cmrpcs_selectedforquote_1__c==FALSE){
                quote.gq_cmrpcs_componentpurchasecost_q1_1__c=null;
                quote.gq_cmrpcs_componentpurchasecost_q2_1__c=null;
            }
            if (quote.gq_dice_selectedforquote_1__c==FALSE){
                quote.gq_dice_componentpurchasecost_q1_1__c=null;
                quote.gq_dice_componentpurchasecost_q2_1__c=null;
            }
            if (quote.gq_dice_selectedforquote_2__c==FALSE){
                quote.gq_dice_componentpurchasecost_q1_2__c=null;
                quote.gq_dice_componentpurchasecost_q2_2__c=null;
            }
            if (quote.gq_dice_selectedforquote_3__c==FALSE){
                quote.gq_dice_componentpurchasecost_q1_3__c=null;
                quote.gq_dice_componentpurchasecost_q2_3__c=null;
            }
            if (quote.gq_dice_selectedforquote_4__c==FALSE){
                quote.gq_dice_componentpurchasecost_q1_4__c=null;
                quote.gq_dice_componentpurchasecost_q2_4__c=null;
            }
            if(quote.gq_bags_selectedforquote_1__c==FALSE){
                quote.gq_bags_componentpurchasecost_q1_1__c=null;
                quote.gq_bags_componentpurchasecost_q2_1__c=null;
            }
            if (quote.gq_misc_selectedforquote_1__c==FALSE){
                quote.gq_misc_componentpurchasecost_q1_1__c=null;
                quote.gq_misc_componentpurchasecost_q2_1__c=null;
            }
        }
    }
    
    //Method to calculate Row Existing Quote
    public static integer calRowExistingQuote(list<Game_Quote__c> existingQuote){
        Integer countSet =  0;
        for(Game_Quote__c quote: existingQuote){
	        if(quote.Use_to_Calculate_ROW_1__c == 'Yes'){
	            countSet++;
	        }
	        if(quote.Use_to_Calculate_ROW_2__c == 'Yes'){
	            countSet++;
	        }
        }
        return countSet;
    }
    
    //Method to calculate Row Current Quote
    public static integer calRowCurrentQuote(Game_Quote__c quote){
        Integer countSet =  0;
        if(quote.Use_to_Calculate_ROW_1__c == 'Yes'){
            countSet++;
        }
        if(quote.Use_to_Calculate_ROW_2__c == 'Yes'){
            countSet++;
        }
        return countSet;
    }
}