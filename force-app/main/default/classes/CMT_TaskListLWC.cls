/**
 * @description       : 
 * @author            : Ashwani Soni
 * @group             : 
 * @last modified on  : 07-19-2021
 * @last modified by  : Ashwani Soni
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   06-29-2021   Ashwani Soni   Initial Version
**/
public with sharing class CMT_TaskListLWC 
{
    @AuraEnabled
    public static List<AWS_File__c> getTaskFileData(String recordId)
    {
        return [SELECT Id, File_Name__c, Task_Record_Name__c, External_ID__c, Task_Record_ID__c, View__c, CreatedDate FROM AWS_File__c WHERE Task_Record_ID__c =:recordId];
    }

}