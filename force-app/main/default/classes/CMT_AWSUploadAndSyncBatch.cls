/**
 * @description       : 
 * @author            : Ashwani Soni
 * @group             : 
 * @last modified on  : 07-25-2021
 * @last modified by  : Ashwani Soni
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   06-24-2021   Ashwani Soni   Initial Version
**/
public with sharing class CMT_AWSUploadAndSyncBatch implements Database.Batchable<Sobject>, Database.AllowsCallouts, Schedulable
{
    public String query = 'SELECT Id, ContentType, ParentId, Name, OwnerId, Owner.isActive FROM Attachment WHERE BodyLength <= '+CMT_AWSUtil.MAX_FILE_SIZE;
    public String mode = 'SYNC';

    public List<AWS_Integeration_Log__c> integerationLog = new List<AWS_Integeration_Log__c>();
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(this.query);
    }

    public void execute(Database.BatchableContext BC, List<Attachment> scope)
    {
        if(this.mode == 'SYNC')
        {
            executeAttachmentLogic(scope,BC.getJobId());
        }
        else if(this.mode == 'DELETE')
        {
            this.deleteAttRecord(scope);
        }
    }

    public void execute(SchedulableContext sc)
    {
        CMT_AWSUploadAndSyncBatch aws = new CMT_AWSUploadAndSyncBatch();
        Database.executeBatch(aws, 1);
    }

    public void finish(Database.BatchableContext info)
    {     
    }

    public void executeAttachmentLogic(List<Attachment> scope, String jobID)
    {
        AWS_Integeration_Log__c awsLogMain = new AWS_Integeration_Log__c(Job_ID__c = jobid);
        Boolean allowDelete = CMT_AWSUtil.ALLOW_DELETE;
        try 
        {
            Map<Id, AWS_File__c> awsIdWithRecord = new Map<Id, AWS_File__c>();
            Set<Id> oldFileIds = new Set<Id>();
            Map<String,String> attachmentIdMap = new Map<String, String>();
            for(Attachment attRecord : scope)
            {
                oldFileIds.add(attRecord.Id);
                System.debug(' ATT MAP Match' +String.valueOf(attRecord.ParentId));
                if(String.valueOf(attRecord.ParentId).startsWith('00T'))
                {
                    attachmentIdMap.put(attRecord.Id,attRecord.ParentId);
                }
            }
            System.debug(' ATT MAP' +attachmentIdMap);
            for(AWS_File__c awsFile : [SELECT id, File_Name__c, File_URL__c, Old_File_ID__c FROM AWS_File__c WHERE Old_File_ID__c IN:oldFileIds])
            {
                awsIdWithRecord.put(awsFile.Old_File_ID__c, awsFile);
            }

            Map<Id,Task> taskWithTaskIds = new Map<Id, Task>();
            Map<Id,ActivityHistory> activityWithTaskIds = new Map<Id, ActivityHistory>();
            if(attachmentIdMap.size() > 0)
            {
                for(Task taskRecord : [SELECT id, WhoId, WhatId, Subject FROM Task WHERE Id IN:attachmentIdMap.values()])
                {
                    taskWithTaskIds.put(taskRecord.Id, taskRecord);
                }
            }

            System.debug(' TASK MAP' +taskWithTaskIds);
            for(Attachment attRecord : scope)
            {
                AWS_Integeration_Log__c awsLog = new AWS_Integeration_Log__c(SFDC_File_ID__c=attRecord.Id, Job_ID__c = jobid);
                integerationLog.add(awsLog);

                try 
                {
                    if(!awsIdWithRecord.containsKey(attRecord.Id))
                    {
                        Id taskID = attachmentIdMap.get(attRecord.Id);

                        String filePath = CMT_AWSUtil.generateFilePath(attRecord.parentId, attRecord.Name, taskWithTaskIds.get(taskID));
                        awsLog.Request_Endpoint__c = (CMT_AWSUtil.endpointStr+'/'+filePath).left(255);
                        Blob content = [SELECT Body FROM Attachment WHERE Id=:attRecord.Id LIMIT 1].body;

                        String contentType = attRecord.ContentType;
                        if(String.isBlank(contentType))
                        {
                            contentType = 'application/'+filePath.right(3);
                        }

                        HTTPResponse res = CMT_AWSUtil.upload(content, filePath, contentType);

                        if(res.getStatusCode() == 200)
                        {
                            System.debug('UPLOAD IS SUCCESSFUL');
                            awsLog.File_Uploaded__c = true;
                            
                            Id recordCreated = CMT_AWSUtil.createAWSFileRecord(attRecord, taskWithTaskIds.get(taskID), filePath);

                            if(recordCreated != null)
                            {
                                awsLog.Logical_Link_Created__c = true;
                                awsLog.AWS_File__c = recordCreated;

                                try 
                                {
                                    if(allowDelete == true)
                                    {
                                        deleteAttRecord(new List<Attachment>{attRecord});
                                        awsLog.Content_Deleted_from_SFDC__c = 'Yes';
                                    }
                                    else 
                                    {
                                        awsLog.Content_Deleted_from_SFDC__c = 'Not Applicable';
                                    }
                                }
                                catch(Exception ex)
                                {
                                    awsLog.Content_Deleted_from_SFDC__c = 'No';
                                    awsLog.Database_Error__c = ex.getMessage()+'\n'+ex.getStackTraceString();

                                    System.debug('-->'+ex.getMessage());
                                }
                            }
                        }
                        else 
                        {
                            awsLog.File_Uploaded__c = false;
                            if(res.getBody() != null)
                            {
                                awsLog.Integration_Error__c = res+'\n\n'+res.getBody();
                            }
                            System.debug('--> File Upload Failed '+res);
                        }
                    }
                    else 
                    {
                        awsLog.Other_Errors__c = 'Logical Link already exist. Upload aborted.\n'+awsIdWithRecord.get(attRecord.Id);
                        System.debug('--> Logical Link already exit '+awsIdWithRecord.get(attRecord.Id));
                    }
                }
                catch(DMLException ex)
                {
                    awsLog.Logical_Link_Created__c = false;
                    awsLog.Database_Error__c = ex.getMessage()+'\n'+ex.getStackTraceString();
                    System.debug('DMLException-->'+ex.getMessage());
                }
                catch(CalloutException ex)
                {
                    awsLog.Logical_Link_Created__c = false;
                    awsLog.Integration_Error__c = ex.getMessage()+'\n'+ex.getStackTraceString();
                    System.debug('CalloutException-->'+ex.getMessage());
                }
                catch (Exception ex) 
                {
                    awsLog.Other_Errors__c = ex.getMessage()+'\n'+ex.getStackTraceString();
                    System.debug('Exception-->'+ex.getMessage());
                }                
            }
        } 
        catch (Exception ex) 
        {
            awsLogMain.Other_Errors__c = ex.getMessage()+'\n'+ex.getStackTraceString();
            integerationLog.add(awsLogMain);
            System.debug('-->'+ex.getMessage());
        }

        insert integerationLog;
    }

    private void deleteAttRecord(List<Attachment> attRecordList)
    {
        Set<String> attIdSet = new Set<String>();
        for(Attachment attRecord : attRecordList)
        {
            attIdSet.add(attRecord.Id);
        }

        Set<String> attToDelete = new Set<String>();
        for(AWS_File__c awsFile : [SELECT id, Old_File_ID__c FROM AWS_File__c WHERE Old_File_ID__c IN:attIdSet AND Old_File_ID__c != null])
        {
            attToDelete.add(awsFile.Old_File_ID__c);
        }
        delete [SELECT id FROM Attachment WHERE Id IN:attToDelete];
    }
}