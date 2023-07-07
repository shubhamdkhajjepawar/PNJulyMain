public with sharing class GameComponentsTriggerHandler{
    /**
     * Method called on after insert
     */
    public static void onAfterInsert(list<Game_Components__c> newRecords) {
        /*set<string> setGcId = new set<string>();
        for(Game_Components__c gc: newRecords){
            if(gc.Custom_Game_Quote__c != null && gc.Component_Purchase_Cost_1__c != null){
                setGcId.add(gc.Custom_Game_Quote__c);
            }
        }
        
        if(setGcId.size() > 0){
            list<Custom_Game_Quote__c> customGameQuotes = new list<Custom_Game_Quote__c>();
            for(Custom_Game_Quote__c cgq: [SELECT Id, Product_Purchase_Cost1__c, (SELECT Component_Purchase_Cost_1__c FROM Game_Components__r) FROM Custom_Game_Quote__c WHERE Id IN: setGcId]){
                decimal newPurchaseCost = 0;
                for(Game_Components__c gc: cgq.Game_Components__r){
                    newPurchaseCost = newPurchaseCost + gc.Component_Purchase_Cost_1__c;
                }
                cgq.Product_Purchase_Cost1__c = newPurchaseCost;
                customGameQuotes.add(cgq);
            }
            if(customGameQuotes.size() > 0){
                update customGameQuotes;
            }
        }*/
    }
    
    /**
     * Method called on after update
     */
    public static void onAfterUpdate(list<Game_Components__c> newRecords, map<Id, Game_Components__c> oldRecordMap) {
        /*set<string> setGcId = new set<string>();
        for(Game_Components__c gc: newRecords){
            if(gc.Custom_Game_Quote__c != null && gc.Component_Purchase_Cost_1__c != null && gc.Component_Purchase_Cost_1__c != oldRecordMap.get(gc.Id).Component_Purchase_Cost_1__c){
                setGcId.add(gc.Custom_Game_Quote__c);
            }
        }
        
        if(setGcId.size() > 0){
            list<Custom_Game_Quote__c> customGameQuotes = new list<Custom_Game_Quote__c>();
            for(Custom_Game_Quote__c cgq: [SELECT Id, Product_Purchase_Cost1__c, (SELECT Component_Purchase_Cost_1__c FROM Game_Components__r) FROM Custom_Game_Quote__c WHERE Id IN: setGcId]){
                decimal newPurchaseCost = 0;
                for(Game_Components__c gc: cgq.Game_Components__r){
                    newPurchaseCost = newPurchaseCost + (gc.Component_Purchase_Cost_1__c != null ? gc.Component_Purchase_Cost_1__c : 0);
                }
                cgq.Product_Purchase_Cost1__c = newPurchaseCost;
                customGameQuotes.add(cgq);
            }
            if(customGameQuotes.size() > 0){
                update customGameQuotes;
            }
        }*/
    }
}