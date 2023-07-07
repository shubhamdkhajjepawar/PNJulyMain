trigger ClearCustomGameQuotePricing on Custom_Game_Quote__c (before insert) {
for (Custom_Game_Quote__c gq: Trigger.new){
        if(gq.Quote_From_Calculator__c != TRUE){
            gq.Ground_Freight_Cost_1__c=null;
            gq.Ground_Freight_Cost_2__c=null;
            gq.Ground_Freight_Cost_3__c=null;
            gq.Ground_Freight_Cost_4__c=null;
            gq.Ground_Freight_Markup_1__c =null;
            gq.Ground_Freight_Markup_2__c =null;
            gq.Ground_Freight_Markup_3__c =null;
            gq.Ground_Freight_Markup_4__c =null;
            gq.Tax_1__c=null;
            gq.Tax_2__c=null;
            gq.Tax_3__c=null;
            gq.Tax_4__c=null;
            gq.Ocean_Freight_Cost_1__c=null;
            gq.Ocean_Freight_Cost_2__c=null;
            gq.Ocean_Freight_Cost_3__c=null;
            gq.Ocean_Freight_Cost_4__c=null;
            gq.Ocean_Freight_Markup_1__c=null;
            gq.Ocean_Freight_Markup_2__c=null;
            gq.Ocean_Freight_Markup_3__c=null;
            gq.Ocean_Freight_Markup_4__c=null;
            gq.Expedited_Freight_Cost_1__c=null;
            gq.Expedited_Freight_Cost_2__c=null;
            gq.Expedited_Freight_Cost_3__c=null;
            gq.Expedited_Freight_Cost_4__c=null;
            gq.Expedited_Freight_Markup_1__c=null;
            gq.Expedited_Freight_Markup_2__c=null;
            gq.Expedited_Freight_Markup_3__c=null;
            gq.Expedited_Freight_Markup_4__c=null;
/*          gq.Additional_charges_1__c=null;
            gq.Additional_charges_2__c=null;
            gq.Additional_charges_3__c=null;
            gq.Additional_charges_4__c=null;
            gq.Assembly_Cost_1__c=null;
            gq.Assembly_Cost_2__c=null;  
            gq.Assembly_Cost_3__c=null;
            gq.Assembly_Cost_4__c=null;
            gq.Prototyping_Cost_1__c=null;
            gq.Prototyping_Cost_2__c=null;
            gq.Prototyping_Cost_3__c=null;
            gq.Prototyping_Cost_4__c=null;
*/      }
    }
}