public class QuoteDetails {
    @AuraEnabled
    public static String getQuoteDetails(string oppId){
        set<String> stages = new set<String>{
            'Closed Won', 'Reprint', 'Proof Won', 'Proposal/ Custom Quote',
            'Proposal/ Online Blind Quote', 'Order Cancelled', 'Closed Lost'
        };
        string quoteId = '';
        for(Quote qu: [SELECT Id FROM Quote WHERE OpportunityId = :oppId AND Opportunity.StageName IN :stages AND (Use_to_Calculate_ROW_1__c = 'Yes' OR Use_to_Calculate_ROW_2__c = 'Yes' OR Use_to_Calculate_ROW_3__c = 'Yes' OR Use_to_Calculate_ROW_4__c = 'Yes' OR Use_to_Calculate_ROW_11__c = 'Yes' OR Use_to_Calculate_ROW_12__c = 'Yes' OR Use_to_Calculate_ROW_13__c = 'Yes' OR Use_to_Calculate_ROW_14__c = 'Yes')]){
            quoteId = qu.Id;
        }
        return quoteId;
    }
}