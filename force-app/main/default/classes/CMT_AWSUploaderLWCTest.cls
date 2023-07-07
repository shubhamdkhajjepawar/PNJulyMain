/**
 * @description       : 
 * @author            : Ashwani Soni
 * @group             : 
 * @last modified on  : 07-19-2021
 * @last modified by  : Ashwani Soni
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   07-19-2021   Ashwani Soni   Initial Version
**/
@isTest
public with sharing class CMT_AWSUploaderLWCTest {
    
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

    public static testmethod void testUpload() 
    {
        List<CMT_AWSUploaderLWC.UploadInfo> uploadInfo = CMT_AWSUploaderLWC.getAttachmentData();
        CMT_AWSUploaderLWC.getUploadConfiguration();
        CMT_AWSUploaderLWC.createLogicalLink(uploadInfo[0].attRecord.Id, null, 'fileUrl');
        CMT_AWSUploaderLWC.getAttachmentData();
    }
}