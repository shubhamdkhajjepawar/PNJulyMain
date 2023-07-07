/**
 * @description       : 
 * @author            : Ashwani Soni
 * @group             : 
 * @last modified on  : 07-19-2021
 * @last modified by  : Ashwani Soni
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   06-27-2021   Ashwani Soni   Initial Version
**/
@isTest
public with sharing class CMT_AWSUploadAndSyncBatchTest 
{
    @TestSetup
    static void makeData()
    {
        AWS_Configuration__c awsConfig = new AWS_Configuration__c();
        awsConfig.Enable_Sync__c = true;
        awsConfig.AWS_Secret_Key__c = 'VVV/erTYD';
        awsConfig.Access_Key__c = 'XXCDFRTFFF';
        awsConfig.Bucket_Name__c = 'printninjauat';
        awsConfig.Region__c = 'WERTHYGFD';
        awsConfig.Max_File_Size_Bytes__c = 50000;
        awsConfig.Delete_after_Sync__c = true;
        insert awsConfig;

        Account acc = new Account(Name='Some Account Pvt Ltd');
        insert acc;

        Contact con = new Contact(LastName='Some Contact', FirstName='User', AccountId=acc.Id);
        insert con;

        Task taskRecord = new Task(Subject='Herer Subject', WhatId=acc.Id, WhoId=con.id, OwnerId=UserInfo.getUserId(), Status='Not Started', Priority='Normal');
        insert taskRecord;

        Attachment attRecord = new Attachment();
        attRecord.Name = 'Some File Name.txt';
        attRecord.ContentType = 'plain/text';
        attRecord.ParentId = taskRecord.Id;
        attRecord.Body = Blob.valueOf('abcdarea');
        insert attRecord;
    }
    public static testMethod void uploadSuccess() 
    {
        CMT_AWSMockHTTP httpMock = new CMT_AWSMockHTTP();

        Attachment attRecord = [SELECT id, Name, ParentId, Body, ContentType FROM Attachment LIMIT 1];
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, httpMock);
            CMT_AWSUploadAndSyncBatch batch = new CMT_AWSUploadAndSyncBatch();
            Database.executeBatch(batch,1);
        Test.stopTest();
    }

    public static testMethod void uploadFail() 
    {
        CMT_AWSMockHTTP httpMock = new CMT_AWSMockHTTP();
        CMT_AWSMockHTTP.state = 2;

        Attachment attRecord = [SELECT id, Name, ParentId, Body, ContentType FROM Attachment LIMIT 1];
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, httpMock);
            CMT_AWSUploadAndSyncBatch batch = new CMT_AWSUploadAndSyncBatch();
            Database.executeBatch(batch,1);
        Test.stopTest();
    }

    public static testMethod void uploadSuccessNoDelete() 
    {
        CMT_AWSMockHTTP httpMock = new CMT_AWSMockHTTP();

        AWS_Configuration__c awsConfig = [SELECT id FROM AWS_Configuration__c LIMIT 1];
        awsConfig.Delete_after_Sync__c = false;
        update awsConfig;

        Attachment attRecord = [SELECT id, Name, ParentId, Body, ContentType FROM Attachment LIMIT 1];
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, httpMock);
            CMT_AWSUploadAndSyncBatch batch = new CMT_AWSUploadAndSyncBatch();
            Database.executeBatch(batch,1);
        Test.stopTest();
    }

    public static testMethod void uploadSuccessNoDeleteSchedule() 
    {
        CMT_AWSMockHTTP httpMock = new CMT_AWSMockHTTP();

        AWS_Configuration__c awsConfig = [SELECT id FROM AWS_Configuration__c LIMIT 1];
        awsConfig.Delete_after_Sync__c = false;
        update awsConfig;

        Attachment attRecord = [SELECT id, Name, ParentId, Body, ContentType FROM Attachment LIMIT 1];
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, httpMock);
            CMT_AWSUploadAndSyncBatch schedulable = new CMT_AWSUploadAndSyncBatch();
            System.schedule('jobNameNEVERREPEAT004', '0 0 0 3 9 ? 2022', schedulable);
        Test.stopTest();
    }

    public static testMethod void deleteOnly() 
    {
        AWS_Configuration__c awsConfig = [SELECT id FROM AWS_Configuration__c LIMIT 1];
        awsConfig.Delete_after_Sync__c = false;
        update awsConfig;

        Attachment attRecord = [SELECT id, Name, ParentId, Body, ContentType FROM Attachment LIMIT 1];
        Test.startTest();
            CMT_AWSUploadAndSyncBatch batch = new CMT_AWSUploadAndSyncBatch();
            batch.mode = 'DELETE';
            Database.executeBatch(batch,1);
        Test.stopTest();
    }
}