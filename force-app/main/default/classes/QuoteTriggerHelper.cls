/**
 * @description       : 
 * @author            : Ashwani Soni
 * @group             : 
 * @last modified on  : 08-02-2021
 * @last modified by  : Ashwani Soni
**/
public with sharing class QuoteTriggerHelper 
{
    public static void afterInsert(List<Quote> newQuotes)
    {
        try 
        {
            Map<Id, Quote> opportunityIdSet = new Map<Id, Quote>();

            for(Quote quoteRecord : newQuotes)
            {
                opportunityIdSet.put(quoteRecord.OpportunityId, quoteRecord);
            }

            List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
            for(Opportunity oppRecord : [SELECT id FROM Opportunity WHERE Id IN:opportunityIdSet.keySet()])
            {
                oppRecord.Grand_Total__c = opportunityIdSet.get(oppRecord.Id).GrandTotal;
                oppRecord.Quote_Date__c = opportunityIdSet.get(oppRecord.Id).CreatedDate.date();
                oppRecord.Product_Name__c = opportunityIdSet.get(oppRecord.Id).Product__c;
                opportunitiesToUpdate.add(oppRecord);
            }

            update opportunitiesToUpdate;   
        } 
        catch (Exception ex) 
        {
            System.debug(' Opportunity Sync failed because: '+ex.getMessage()+'\n'+ex.getStackTraceString()) ;   
        }
    }   
}