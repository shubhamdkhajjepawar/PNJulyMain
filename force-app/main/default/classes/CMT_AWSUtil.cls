/**
 * @description       : 
 * @author            : Ashwani Soni
 * @group             : 
 * @last modified on  : 07-08-2021
 * @last modified by  : Ashwani Soni
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   06-24-2021   Ashwani Soni   Initial Version
**/
public with sharing class CMT_AWSUtil 
{
    public static AWS_Configuration__c awsConfig = AWS_Configuration__c.getInstance();
    
    public static String AWS_KEY = awsConfig.Access_Key__c;
    public static String AWS_SECRET = awsConfig.AWS_Secret_Key__c;
    public static String BUCKET_NAME = awsConfig.Bucket_Name__c;
    public static String REGION = awsConfig.Region__c;
    public static String HOST = 's3.'+REGION+'.amazonaws.com';

    public static Integer MAX_FILE_SIZE = Integer.valueOf(awsConfig.Max_File_Size_Bytes__c);
    public static Boolean ALLOW_DELETE = awsConfig.Delete_after_Sync__c;

    // https://printninjauat.s3.us-west-1.amazonaws.com/Contact/0030p00000PERzQAAX/Task/00T0p00000FxjLnEAJ/file.pdf
    public static String endpointStr = 'https://'+BUCKET_NAME+'.'+HOST; 
    
    public static HTTPResponse upload(Blob content, String fileName, string fileType)
    {
        if(awsConfig.Enable_Sync__c == true)
        {
            String attachmentBody = EncodingUtil.base64Encode(content);
            String formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
            String key = AWS_KEY; //AWS key
            String secret = AWS_SECRET; //AWS Secret key
            String bucketname = BUCKET_NAME; //AWS bucket name
            String host = HOST;
            String method = 'PUT';

            HttpRequest req = new HttpRequest();
            req.setMethod(method);
            req.setEndpoint(endpointStr + '/'+fileName);
            req.setHeader('Host', bucketname + '.' + host);
            req.setHeader('Content-Length', String.valueOf(attachmentBody.length()));
            req.setHeader('Content-Encoding', 'UTF-8');
            req.setHeader('Content-type', fileType);
            req.setHeader('Connection', 'keep-alive');
            req.setHeader('Date', formattedDateString);
            req.setHeader('ACL', 'public-read-write');
            req.setBodyAsBlob(content);

            String stringToSign = 'PUT\n\n' + fileType + '\n' + formattedDateString + '\n' + '/' + bucketname + '/' + fileName;
            String encodedStringToSign = EncodingUtil.urlEncode(stringToSign, 'UTF-8');
            Blob mac = Crypto.generateMac('HMACSHA1', blob.valueof(stringToSign),blob.valueof(secret));
            String signedKey  = EncodingUtil.base64Encode(mac);
            String authHeader = 'AWS' + ' ' + key + ':' + signedKey ;

            req.setHeader('Authorization',authHeader);

            String decoded = EncodingUtil.urlDecode(encodedStringToSign , 'UTF-8');

            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug(' Res: '+res.getBody());
            return res;
        }
        else 
        {
            return null;    
        }
    }

    public static string getSignedURL(String file) 
    {
        String filename = EncodingUtil.urlDecode(file, 'UTF-8');
 
         
        String AccessKey = AWS_KEY  ; //AWS key
        String SecretKey = AWS_SECRET  ; //AWS Secret key
        String BucketName = BUCKET_NAME  ; //AWS bucket name
        String host = HOST  ;
        
        
        Datetime now = DateTime.now();
        Datetime expireson = now.AddSeconds(360); // Lifespan of the link
        Long Lexpires = expireson.getTime()/1000;
        
        String stringtosign = 'GET\n\n\n'+Lexpires+'\n/'+BucketName+'/'+filename;
        System.debug('redirectToS3Key stringstosign: ' + stringtosign);
        
        String signingKey = EncodingUtil.base64Encode(Blob.valueOf(SecretKey));
        Blob mac = Crypto.generateMac('HMacSHA1', blob.valueof(stringtosign),blob.valueof(SecretKey)); 
        String signed= EncodingUtil.base64Encode(mac);     
        String codedsigned = EncodingUtil.urlEncode(signed,'UTF-8');
        String url = 'https://'+BucketName+'.'+host+'/'+filename+'?AWSAccessKeyId='+AccessKey+
                     '&Expires='+Lexpires+'&Signature='+EncodingUtil.urlEncode(signed,'UTF-8');
                
        return url;
    }

    public static String generateFilePath(Id parentId, String fileName, Task taskRecord)
    {
        String filePath = '';

        System.debug('AWS taskRecord '+taskRecord);
        if(taskRecord != null && (''+parentId).startsWith('00T'))
        {
            Id whoId = taskRecord.WhoId;
            if(whoId != null)
            {
                filePath += whoId.getSobjectType()+'/'+whoId;
                filePath += '/';
            }
            filePath += 'Task/'+taskRecord.Id;
        }
        else 
        {
            filePath += parentId.getSobjectType()+'/'+parentId;
        }
        
        filePath = ''+filePath+'/'+fileName.replaceAll(' ','_');

        System.debug('AWS FilePath '+filePath);

        return filePath;
    }

    public static Id createAWSFileRecord(Attachment attachmentRecord, Task taskRecord, String fileURL)
    {
        AWS_File__c fileRecord = new AWS_File__c();
        fileRecord.Name = attachmentRecord.Name.left(80);
        fileRecord.File_Name__c = attachmentRecord.Name;
        fileRecord.File_Url__c = CMT_AWSUtil.endpointStr+'/'+fileURL;
        fileRecord.External_ID__c = fileURL;
        if(attachmentRecord.Owner.isActive)
        {
            fileRecord.OwnerId = attachmentRecord.OwnerId;
        }
        fileRecord.Old_File_ID__c = attachmentRecord.Id;

        Id parentId = String.valueOf(attachmentRecord.ParentId);

        System.debug('AWS taskRecord '+taskRecord);
        if(taskRecord != null && (''+parentId).startsWith('00T'))
        {
            fileRecord.Task_Record_ID__c = parentId;
            fileRecord.Task_Record_Name__c = taskRecord.Subject;
            
            Id whoId = taskRecord.WhoId;

            if(whoId != null)
            {
                String fieldAPIName = whoId.getSobjectType()+'__c';
                fileRecord.put(fieldAPIName,whoId);
            }

            if(taskRecord.WhatId != null)
            {
                Id whatId = taskRecord.WhatId;
                String fieldAPINameWhatId = whatId.getSobjectType()+'__c';

                fileRecord.put(fieldAPINameWhatId,whatId);
            }
        }
        else if((''+parentId.getSobjectType()) == 'Task')
        {
            fileRecord.put('Task_Record_ID__c',parentId);
        }
        else 
        {
            String fieldAPIName = parentId.getSobjectType()+'__c';
            fileRecord.put(fieldAPIName,parentId);
        }

        upsert fileRecord External_ID__c;

        return fileRecord.Id;
    }
}