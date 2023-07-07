public class uploadCSVcontroller {

    public Blob contentFile { get; set; }
    public String nameFile { get; set; }
    public Integer rowCount { get; set; }
    public Integer colCount { get; set; }
    public String queryresult{ get; set; }
    OpportunityHelper obj=new OpportunityHelper();
    public Blob contentFileUPS { get; set; }
    public String nameFileUPS { get; set; }
    public String OrderMsg{get;set;}
    public String OrderUPSMsg{get;set;}
    List<List<String>> parsedCSV = new List<List<String>>();
 
      public uploadCSVcontroller(ApexPages.StandardController stdController)
      {
       OrderMsg='';
       OrderUPSMsg='';
      }
     public PageReference UpdateOppor() 
     {
        try
        {
            rowCount = 0;
            colCount = 0;
            if (contentFile != null)
            {
            String fileString = contentFile.toString();
           // queryresult=fileString;
            parsedCSV = parseCSV(fileString, true);
            rowCount = parsedCSV.size();
            
            for (List<String> row : parsedCSV){
            //queryresult=JSON.serialize(row);
            Opportunity op= new OpportunityHelper().getByJobNumber(row[4].trim());
            if(op!=NULL)
            {
                  if(String.isNotEmpty(row[14]))
                  {
                     try
                     {
                         date mydate1 = date.parse(row[14].trim());
                         op.Order_Completion_Date__c=mydate1 ;
                     }
                     catch(Exception e)
                     {}
                  }
                  if(String.isNotEmpty(row[29]))
                  {
                     op.Actual_Pur_Cost_I__c=decimal.valueOf(row[29].removeStart('\'').removeStart('$').remove('\''));
                  }
                  if(String.isNotEmpty(row[32]))
                  {
                     op.Actual_Ground_Shipping_Cost_I__c=decimal.valueOf(row[32].removeStart('\'').removeStart('$').remove('\''));
                  }
                  if(String.isNotEmpty(row[31]))
                  {
                     op.Actual_Ocean_Shipping_Cost_I__c=decimal.valueOf(row[31].removeStart('\'').removeStart('$').remove('\''));
                  }
                  if(String.isNotEmpty(row[33]))
                  {
                     op.Actual_Expedited_Shipping_Cost__c=decimal.valueOf(row[33].removeStart('\'').removeStart('$').remove('\''));
                  }
                  if(String.isNotEmpty(row[28]))
                  {
                     op.Buying_UP__c=decimal.valueOf(row[28].removeStart('\'').removeStart('$').remove('\''));
                  }
                       
                       
                    if(row[25]=='Air Express')
                       {
                           if(row[11].contains('In-Transit(Ocean)') || row[11].contains('In-Transit(Domestic)') ||row[11].contains('Delivered'))
                           {
                             op.Shipping_Status_Expedited__c=row[11];
                           }
                           //if( op.Shipping_Company_E__c!=row[26])
                          // {
                           // op.Shipping_Company_E__c=row[26];
                          // }
                         
                           if(String.isNotEmpty(row[15]))
                           {
                               try
                               {
                                   date mydate2 = date.parse(row[15].trim());
                                   op.EXW_Date_E__c=mydate2 ;
                               }
                               catch(Exception e)
                               {}
                              
                           }
                          
                           if(String.isNotEmpty(row[18]))
                           {
                           try
                           {
                           date mydate3 = date.parse(row[18].trim());
                           op.ETA_Customer_E__c=mydate3 ;
                           }
                          catch(Exception e)
                           {}
                          
                            }
                          if(String.isNotEmpty(row[19]))
                           {
                            try{
                           date mydate4 = date.parse(row[19].trim());
                           op.Actual_Arrival_Date_E__c=mydate4 ;
                           }
                          catch(Exception e)
                           {}
                          
                           }
                           if(String.isNotEmpty(row[20]))
                           {
                             try{
                           date mydate5 = date.parse(row[20].trim());
                           op.Customer_Expected_Delivery_Date_E__c=mydate5 ;
                           }
                          catch(Exception e)
                           {}
                           
                           }
                           // if(op.Shipping_Company_E__c!=row[26])
                           //{
                           //op.Shipping_Company_E__c=row[26];
                           //}
                         
                          
                           if(op.Express_KG__c!=decimal.valueOf(row[30].removeStart('\'').removeStart('$').remove('\'')))
                           {
                           op.Express_KG__c=decimal.valueOf(row[30].removeStart('\'').removeStart('$').remove('\''));
                           }
                            if(String.isNotEmpty(row[24]) )
                           {
                               if(op.Tracking_No_E__c==NULL || op.Tracking_No_E__c=='')
                               {
                               op.Tracking_No_E__c=row[24];
                               op.Recent_Tracking_No_E__c=row[24];
                                update op;
                               SendEmailUsingTemplate(op.Contact__c,op.Id,op.Owner.Name);
                            
                               }
                               else if(op.Tracking_No_E__c!=NULL && !op.Tracking_No_E__c.contains(row[24]))
                               {
                                op.Tracking_No_E__c=op.Tracking_No_E__c+','+row[24];
                                 op.Recent_Tracking_No_E__c=row[24];
                                  update op;
                               SendEmailUsingTemplate(op.Contact__c,op.Id,op.Owner.Name);
                             
                                }
                              
                           }
                            update op;
                       }
                       else
                       {
                             if(row[11].contains('In-Transit(Ocean)') || row[11].contains('In-Transit(Domestic)') ||row[11].contains('Delivered'))
                           {
                           op.Shipping_Status_Standard__c=row[11];
                           }
                        
                           if(String.isNotEmpty(row[15]))
                           {
                            try{
                           date mydate6 = date.parse(row[15].trim());
                           op.EXW_Date__c=mydate6 ;
                           }
                          catch(Exception e)
                           {}
                              
                           }
                           if(String.isNotEmpty(row[16]))
                           {
                            try{
                           date mydate7 = date.parse(row[16].trim());
                           op.ETD_Port__c=mydate7 ;
                           }
                          catch(Exception e)
                           {}
                              
                           }
                           if(String.isNotEmpty(row[17]))
                           {
                            try{
                           date mydate8 = date.parse(row[17].trim());
                           op.ETA_Port__c=mydate8 ;
                           }
                          catch(Exception e)
                           {}
                             
                           }
                          
                           if(String.isNotEmpty(row[18]))
                           {
                           try{
                           date mydate9 = date.parse(row[18].trim());
                           op.ETA_Customer__c=mydate9 ;
                           }
                          catch(Exception e)
                           {}
                              
                           }
                           if(String.isNotEmpty(row[19]))
                           {
                            try{
                           date mydate10 = date.parse(row[19].trim());
                           op.Actual_Arrival_Date__c=mydate10 ;
                           }
                          catch(Exception e)
                           {}
                              
                           }
                           if(String.isNotEmpty(row[20]))
                           {
                           try{
                           date mydate11 = date.parse(row[20].trim());
                           op.Customer_Expected_Delivery_Date__c=mydate11 ;
                           }
                          catch(Exception e)
                           {}
                              
                           }
                         
                           if(op.Ocean_CBM__c!=decimal.valueOf(row[30].removeStart('\'').removeStart('$').remove('\'')))
                           {
                           op.Ocean_CBM__c=decimal.valueOf(row[30].removeStart('\'').removeStart('$').remove('\''));
                           }
                          // if(op.Shipping_Company__c!=row[26])
                          // {
                          // op.Shipping_Company__c=row[26];
                         //  }
                           
                            if(String.isNotEmpty(row[24]) )
                           {
                               if(op.Tracking_No__c==NULL || op.Tracking_No__c=='')
                               {
                               op.Tracking_No__c=row[24];
                               op.Recent_Tracking_No_E__c=row[24];
                                update op;
                              SendEmailUsingTemplate(op.Contact__c,op.Id,op.Owner.Name);
                              
                               }
                               else if(op.Tracking_No__c!=NULL && !op.Tracking_No__c.contains(row[24]))
                               {
                                op.Tracking_No__c=op.Tracking_No__c+','+row[24];
                                 op.Recent_Tracking_No_E__c=row[24];
                                  update op;
                                SendEmailUsingTemplate(op.Contact__c,op.Id,op.Owner.Name);
                               
                                }
                              
                           }
                            update op;
                       }
                      
                   }
                    if (row.size() > colCount){
                        colCount = row.size();
                    }
            }
            OrderMsg='File Uploaded Successfully.';
            OrderUPSMsg='';
        }
         } catch(Exception ex){
            ApexPages.addMessages(ex);
        }
        return null;
    }
    public List<List<String>> getResults() {
        return parsedCSV;
    }
   
    public PageReference UpdateOpporByUPS() {
      try
        {
         rowCount = 0;
         colCount = 0;
       
        List<List<String>> parsedCSVUPS = new List<List<String>>();
            if (contentFileUPS != null)
            {
             nameFile=nameFileUPS;
                String fileString = contentFileUPS.toString();
                parsedCSVUPS = parseCSV(fileString, true);
                parsedCSV=parsedCSVUPS;
                rowCount = parsedCSVUPS.size();
                for (List<String> row : parsedCSVUPS)
                {
                Opportunity op= new OpportunityHelper().getByJobNumber(row[15].trim());
                    if(op!=NULL)
                       {
                        if(String.isNotEmpty(row[13]) )
                           {
                           if(op.Tracking_No__c==NULL || op.Tracking_No__c=='')
                               {
                               op.Tracking_No__c=row[13];
                                op.Recent_Tracking_No_E__c=row[13];
                                update op;
                              SendEmailUsingTemplate(op.Contact__c,op.Id,op.Owner.Name);
                              
                               }
                               else if(op.Tracking_No__c!=NULL && !op.Tracking_No__c.contains(row[13]))
                               {
                                op.Tracking_No__c=op.Tracking_No__c+','+row[13];
                                op.Recent_Tracking_No_E__c=row[13];
                                  update op;
                              SendEmailUsingTemplate(op.Contact__c,op.Id,op.Owner.Name);
                              
                                }
                              
                           }
                        
                         
                     
                       }
                        if (row.size() > colCount){
                            colCount = row.size();
                        } 
                }
                OrderUPSMsg='File Uploaded Successfully.';
                OrderMsg='';
            }
        } catch(Exception ex){
            ApexPages.addMessages(ex);
        }
        return null;
    }
    
    public void SendEmail(string toEmail,string toName,string fromEmail,string fromName,string order_no,string shipping_comp)
    {
        String[] toaddress = new String[]{};
        toaddress.add(toEmail);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toaddress);
        mail.setsubject('Order Tracking Information');
        mail.setReplyTo(fromEmail);
        mail.setSenderDisplayName(fromName);
        String s =  '<body>'
                         +'Dear '+toName+','+ 
                               '<br /><br />' +
                               'Order No:'+order_no+
                               '<br/>'+
                              'Shipping Company:'+shipping_comp+
                               '<br/><br/>'+
                               'Thank You';
        mail.setHtmlBody(s);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
     public void SendEmailUsingTemplate(ID contactId,ID oppId,string sendername)
        {
       
        EmailTemplate et=[Select id from EmailTemplate where developerName=:'OrderTrackingEmailTemplate'];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTargetObjectId(contactId);
        mail.setWhatId(oppId);
        mail.setSenderDisplayName(sendername);
        mail.setTemplateId(et.id);
        mail.setSaveAsActivity(false);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
       
    
    /* 
    Credit to 
    http://wiki.developerforce.com/index.php/Code_Samples#Parse_a_CSV_with_APEX
    */
    public static List<List<String>> parseCSV(String contents,Boolean skipHeaders) {
   
        List<List<String>> allFields = new List<List<String>>();
    
        // replace instances where a double quote begins a field containing a comma
        // in this case you get a double quote followed by a doubled double quote
        // do this for beginning and end of a field
        contents = contents.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');
        // now replace all remaining double quotes - we do this so that we can reconstruct
        // fields with commas inside assuming they begin and end with a double quote
        contents = contents.replaceAll('""','DBLQT');
        // we are not attempting to handle fields with a newline inside of them
        // so, split on newline to get the spreadsheet rows
        List<String> lines = new List<String>();
        try {
            //lines = contents.split('\n'); //correction: this only accomodates windows files
            lines = contents.split('\r'); // using carriage return accomodates windows, unix, and mac files
            //http://www.maxi-pedia.com/Line+termination+line+feed+versus+carriage+return+0d0a
        } catch (System.ListException e) {
            System.debug('Limits exceeded?' + e.getMessage());
        }
        Integer num = 0;
        for(String line: lines) {
            // check for blank CSV lines (only commas)
            if (line.replaceAll(',','').trim().length() == 0) break;
            
            List<String> fields = line.split(',');  
            List<String> cleanFields = new List<String>();
            String compositeField;
            Boolean makeCompositeField = false;
            for(String field: fields) {
                if (field.startsWith('"') && field.endsWith('"')) {
                    cleanFields.add(field.replaceAll('DBLQT','"').unescapeCsv().remove('"'));
                } else if (field.startsWith('"')) {
                    makeCompositeField = true;
                    compositeField = field;
                } else if (field.endsWith('"')) {
                    compositeField += ',' + field;
                    cleanFields.add(compositeField.replaceAll('DBLQT','"').unescapeCsv().remove('"'));
                    makeCompositeField = false;
                } else if (makeCompositeField) {
                    compositeField +=  ',' + field;
                } else {
                    cleanFields.add(field.replaceAll('DBLQT','"').unescapeCsv().remove('"'));
                }
            }
            
            allFields.add(cleanFields);
        }
        if (skipHeaders) allFields.remove(0);
       // allFields.remove(0);
        return allFields;       
    }
   
   

}