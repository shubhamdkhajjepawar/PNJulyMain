global with sharing class ExportReport_Schedular implements Schedulable, Database.Batchable<sObject>, Database.AllowsCallouts{ 
    //Schedule Execute Metod
    global void execute(SchedulableContext sc){
        Database.executeBatch(this, 200);
    }
    
    //Start Batch
    global Database.QueryLocator start(Database.BatchableContext BC){
        string reportQuery = 'SELECT Id, Name FROM Report WHERE FolderName = \'Export Report\'';
        if(Test.isRunningTest()){
            reportQuery = 'SELECT Id, Name FROM Report LIMIT 1';
        }
        return Database.getQueryLocator(reportQuery);
    }
    
    //Execute Batch
    global void execute(Database.BatchableContext BC, list<Report> scope){
        //Report attachment
        list<Messaging.EmailFileAttachment> attachments = new list<Messaging.EmailFileAttachment>();
        for(Report rp: scope){
            ApexPages.PageReference objPage = new ApexPages.PageReference('/'+rp.Id+'?csv=1');
            Messaging.EmailFileAttachment objMsgEmailAttach = new Messaging.EmailFileAttachment();
            objMsgEmailAttach.setFileName(rp.Name+'.csv');
            if(!Test.isRunningTest()){
                objMsgEmailAttach.setBody(objPage.getContent());
            }else{
                objMsgEmailAttach.setBody(Blob.valueof('Test'));
            }
            objMsgEmailAttach.setContentType('text/csv');
            
            attachments.add(objMsgEmailAttach);
        }
        
        // Send the email
        list<string> toEmails = new list<string>(); 
        toEmails = Label.ExportReportReceiver.split(','); 
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
        mail.setToAddresses(toEmails);
        mail.setSubject('Backup files - ' + Datetime.now().format('dd/MM/yyyy'));
        mail.setHtmlBody('Please find attached files.');
        mail.setFileAttachments(attachments); 
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    //Finish Batch
    global void finish(Database.BatchableContext BC){
        
    }  
}