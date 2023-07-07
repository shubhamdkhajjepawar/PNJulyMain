/**
 * @description       : 
 * @author            : Ashwani Soni
 * @group             : 
 * @last modified on  : 06-27-2021
 * @last modified by  : Ashwani Soni
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   06-27-2021   Ashwani Soni   Initial Version
**/
@isTest
public with sharing class CMT_FileViewLWCTest 
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
        
        AWS_File__c fileRecord = new AWS_File__c();
        fileRecord.Name = 'Test';
        fileRecord.File_Name__c = 'Test.jpg';
        fileRecord.File_Url__c = CMT_AWSUtil.endpointStr+'/abc.jpg';
        fileRecord.External_ID__c = fileRecord.File_Url__c;
        fileRecord.OwnerId = UserInfo.getUserId();

        insert fileRecord;
    }

    public static testMethod void generateURL() 
    {
        CMT_FileViewLWC.generateFilePreview(CMT_AWSUtil.endpointStr+'/abc.jpg');
    }

}