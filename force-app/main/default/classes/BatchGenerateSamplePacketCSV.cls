global with sharing class BatchGenerateSamplePacketCSV implements Database.Batchable<sObject>, Database.Stateful {
   
    public String SOQL;
    
    public String csvContent = '';
    
     
    //method to run batch
    public static void runJob(){
         Integer batchSize = 200;
         BatchGenerateSamplePacketCSV batchToGenerateCSV = new BatchGenerateSamplePacketCSV();
         
         //execute batch
         database.executebatch(batchToGenerateCSV, batchSize); 
    }
    
    //get records to be processed by batch          
    global Database.QueryLocator start(Database.BatchableContext BC){
         
    
        if(SOQL == null ||  SOQL.trim().length() == 0) {
            SOQL = 'Select Id, FirstName, LastName, Street, Street_Address1__c, Street_Address2__c, PostalCode, State, Country '+
                        'From Lead Where Include_In_SamplePacketCSV__c = True'; 
        }
        
        if(Test.isRunningTest()) {
            SOQL = SOQL + ' Order BY CreatedDate Desc Limit 1'; 
        }
        return Database.getQueryLocator(SOQL);
    }
     
    //execute batch to generate csv content
    global void execute(Database.BatchableContext BC, List<Lead> scope){
        
            csvContent = CreateCSVFile.generateCSVFile(scope);
            for(Lead l : scope) {
                l.Include_In_SamplePacketCSV__c = false;
            }
            
            update scope;
    } 
    
    //finish method for batch to generate csv documents
    global void finish(Database.BatchableContext BC){
        
        //Create a save point
        SavePoint sp = database.setSavePoint();
        try {
                System.debug('Content : ' + csvContent);
                if(csvContent.length() > 0) {
                    //Get SamplePacket folder 
                    Folder folder = [Select Id From Folder where Name =: 'Sample Packets'];
                    
                    List<Document> listDocument = new List<Document>();
                    Blob b = Blob.valueOf(csvContent);
                    //new document with csv content
                    Document document = new Document(Body = b, name = 'Sample Packets_' + String.valueOf(Datetime.now()) + '.csv',
                                        FolderId = folder.Id, description = 'Sample Packets ' + String.valueOf(Datetime.now()));
                    listDocument.add(document);
                    
                    //insert document
                    insert listDocument;
                     
                   // sendEmail(listDocument); 
                }
        }
        catch(Exception e) {
            
            //rollback transaction
            database.rollback(sp);
            
            throw e;
        }
                       
    } 
    
    //method to send email with csv as attachement
   // private void sendEmail(List<Document> listDocument) {
         
         //list of attachments
        // List<Messaging.EmailFileAttachment> listMEFA = new List<Messaging.EmailFileAttachment>();
         
         //loop over dcuments to be attached with mail
        // for(Document d : listDocument){
         //   Blob body = d.body;
            //Sets up the new attachment, invents a filename
         //   Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
         //  efa.setFileName(d.Name);
         //   efa.setBody(body );
            //add to list
          //  listMEFA.add(efa);
          
        // }
          
         //SingleEmailMessage instance
       //  Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
         
         //if has attachment then only send mail
        // if(listMEFA.size() > 0){
             
           //  CreateCSVFile.setSamplePacketCSVEmailParams();
             //get from configuration
            // Id contactId = CreateCSVFile.SAMPLE_PACKET_EMAIL_RECEIVER_CONTACT_ID;
            // Id templateID = CreateCSVFile.SAMPLE_PACKET_EMAIL_TEMPLATE_ID;
             
            // mail.setFileAttachments(listMEFA);
             
            // mail.setTemplateId(templateID);
            // mail.settargetobjectid(Id.valueOf(contactId));
             
             //get list of email address to be in CC
            // List<String> ccAddresses = CreateCSVFile.listCCEmailAddresses;
             
            // if(ccAddresses != null && ccAddresses.size() > 0) {
              //  mail.setCcAddresses(ccAddresses);
            // }
           //  Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
       // }
    //} 
   
}