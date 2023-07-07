public with sharing class UtilityController {
    public static list<sObject> returnQuoteListRecords(string objectAPIName, string filterFieldAPIName, set<string> filterIds){
        string allFields = '';
        set<string> ignoreFields = new set<string>{'LastReferencedDate', 'LastViewedDate'};
        
        map<String, Schema.SObjectField> fieldObjMap = Schema.getGlobalDescribe().get(objectAPIName).getDescribe().fields.getMap();
        for(Schema.SObjectField s : fieldObjMap.values()){
        	if(!ignoreFields.contains(s.getDescribe().getName())){
            	allFields += (allFields == ''? '' : ',') + s.getDescribe().getName();
        	}
        }
        
        String soql_query = 'SELECT ' + allFields + ' FROM ' + objectAPIName + ' WHERE ' + filterFieldAPIName + ' IN : filterIds';
        
        if(objectAPIName == 'Quote'){
        	soql_query += ' AND (Use_to_Calculate_ROW_1__c = \'Yes\' OR Use_to_Calculate_ROW_2__c = \'Yes\' OR Use_to_Calculate_ROW_3__c = \'Yes\' OR Use_to_Calculate_ROW_4__c = \'Yes\' OR Use_to_Calculate_ROW_11__c = \'Yes\' OR Use_to_Calculate_ROW_12__c = \'Yes\' OR Use_to_Calculate_ROW_13__c = \'Yes\' OR Use_to_Calculate_ROW_14__c = \'Yes\')';
        }else if(objectAPIName == 'Game_Quote__c'){
        	soql_query += ' AND (Use_to_Calculate_ROW_1__c = \'Yes\' OR Use_to_Calculate_ROW_2__c = \'Yes\')';
        }else if(objectAPIName == 'Custom_Game_Quote__c'){
        	soql_query += ' AND (Use_to_Calculate_ROW_1__c = \'Yes\' OR Use_to_Calculate_ROW_2__c = \'Yes\' OR Use_to_Calculate_ROW_3__c = \'Yes\' OR Use_to_Calculate_ROW_4__c = \'Yes\')';
        }
        
        list<sObject> listSobject = Database.query(soql_query);
        return listSobject;
    }
}