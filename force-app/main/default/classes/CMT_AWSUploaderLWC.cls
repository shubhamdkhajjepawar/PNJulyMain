/**
 * @description       : 
 * @author            : Ashwani Soni
 * @group             : 
 * @last modified on  : 07-30-2021
 * @last modified by  : Ashwani Soni
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   07-02-2021   Ashwani Soni   Initial Version
**/
public with sharing class CMT_AWSUploaderLWC 
{
    @auraenabled
    public static List<UploadInfo> getAttachmentData() 
    {
        String query = 'SELECT Id, ContentType, ParentId, CreatedDate, Name, OwnerId, Owner.isActive, BodyLength FROM Attachment '+(!Test.isRunningTest() ? ('WHERE BodyLength > '+CMT_AWSUtil.MAX_FILE_SIZE) : '');
        List<UploadInfo> uploadList = new List<UploadInfo>();

        List<Attachment> attList = Database.query(query);
        Set<String> attachmentIds = new Set<String>();
        Map<String,String> attachmentIdMap = new Map<String, String>();
        for(Attachment attRecord : attList)
        {
            if(String.valueOf(attRecord.ParentId).startsWith('00T'))
            {
                attachmentIdMap.put(attRecord.Id,attRecord.ParentId);
            }
            attachmentIds.add(attRecord.Id);
        }

        Map<Id,Task> taskWithTaskIds = new Map<Id, Task>();
        for(Task taskRecord : [SELECT id, WhoId, WhatId, Subject FROM Task WHERE Id IN:attachmentIdMap.values()])
        {
            taskWithTaskIds.put(taskRecord.Id, taskRecord);
        }

        Map<String,AWS_File__c> attIdWithAWSFileId = new Map<String,AWS_File__c>();

        for(AWS_File__c awsFile : [SELECT Id, Name, Old_File_ID__c FROM AWS_File__c WHERE Old_File_ID__c IN:attachmentIds])
        {
            attIdWithAWSFileId.put(awsFile.Old_File_ID__c, awsFile);
        }
        for(Attachment attRecord : attList)
        {
            UploadInfo upload = new UploadInfo();
            upload.attRecord = attRecord;
            upload.fileSize = attRecord.BodyLength/1024/1024;
            upload.attId = '/'+attRecord.Id;
            upload.fileURL = CMT_AWSUtil.generateFilePath(attRecord.ParentId, attRecord.Name, taskWithTaskIds.get(attRecord.ParentId));
            if(attIdWithAWSFileId.containsKey(attRecord.Id))
            {
                upload.status = 'Uploaded';
                upload.awsFile = attIdWithAWSFileId.get(attRecord.Id);
                upload.awsFileId = '/'+upload.awsFile.Id;
                upload.isFilePresent = true;
                upload.hideRow = true;
            }
            uploadList.add(upload);
        }

        return uploadList;
    }

    @AuraEnabled
    public static Map<String, String> getUploadConfiguration()
    {
        Map<String, String> configuration = new Map<String, String>();
        configuration.put('host', CMT_AWSUtil.HOST);
        configuration.put('bucket', CMT_AWSUtil.BUCKET_NAME);
        configuration.put('secret', CMT_AWSUtil.AWS_SECRET);
        configuration.put('key', CMT_AWSUtil.AWS_KEY);
        configuration.put('region', CMT_AWSUtil.REGION);

        return configuration;
    }

    @AuraEnabled
    public static Boolean uploadFile(String attachmentId)
    {
        List<Attachment> attRecordList = [SELECT Id, ContentType, ParentId, CreatedDate, Name, OwnerId, Owner.isActive, BodyLength FROM Attachment WHERE Id=:attachmentID];

        CMT_AWSUploadAndSyncBatch batch = new CMT_AWSUploadAndSyncBatch();
        batch.executeAttachmentLogic(attRecordList,'TEST UPLOAD ATT');

        return true;
    }

    @AuraEnabled
    public static String createLogicalLink(String attRecordId, String taskRecordId, String fileUrl)
    {
        System.debug(' ATTRECORD: '+attRecordId);
        Attachment attRecord = [SELECT Id, ContentType, ParentId, CreatedDate, Name, OwnerId, Owner.isActive, BodyLength FROM Attachment WHERE ID =: attRecordId LIMIT 1];
        
        String recordId = CMT_AWSUtil.createAWSFileRecord(attRecord, null, fileURL);
        return recordId;
    }

    public class UploadInfo
    {
        @auraenabled
        public Attachment attRecord {get;set;}
        @auraenabled
        public AWS_File__c awsFile {get;set;}
        @auraenabled
        public String awsFileId {get;set;}
        @auraenabled
        public String attId {get;set;}
        @auraenabled
        public String fileName {get;set;}
        @auraenabled
        public String fileType {get;set;}
        @auraenabled
        public Object fileObj {get;set;}
        @auraenabled
        public String status {get;set;}
        @auraenabled
        public Integer progress {get;set;}
        @auraenabled
        public Integer fileSize {get;set;}
        @auraenabled
        public String statusText {get;set;}
        @auraenabled
        public String fileURL {get;set;}
        @auraenabled
        public Boolean isFilePresent {get;set;}
        @auraenabled
        public Boolean hideRow {get;set;}
        @auraenabled
        public Boolean showSpinner {get;set;}
        
        public UploadInfo()
        {
            this.status = 'Not Uploaded';
            this.progress = 30;
            this.isFilePresent = false;
            this.showSpinner = false;
            this.hideRow = false;
        }
    }
}