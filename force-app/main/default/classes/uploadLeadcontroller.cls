public class uploadLeadcontroller {
     /* Variables */
     public string QueryString{get;set;}
    public Blob contentFile { get; set; }
    public String nameFile { get; set; }
    public Integer rowCount { get; set; }
    public Integer colCount { get; set; }
    public Integer duplicateLeadcount=0;
    List<List<String>> parsedCSV = new List<List<String>>();
   List<Lead> uploadedLead;
   List<CampaignMember> memberList= new List<CampaignMember>();
   public List<string> msg;
   Map<String,String> leadCampaign=new Map<String,String>();
    public uploadLeadcontroller() {
    msg=new List<string>();
    }

    /* Constructor */
    public uploadLeadcontroller(ApexPages.StandardController stdController)
    {
       
    }
    public PageReference CreateLead() 
    {
     List<Lead> tList = new List<Lead>();
     uploadedLead=new List<Lead>();
        try
        {
            rowCount = 0;
            colCount = 0;
                if (contentFile != null)
                {
                String fileString = contentFile.toString();
                parsedCSV = parseCSV(fileString, true);
                rowCount = parsedCSV.size();
                Set<String> leadEmails = new Set<String>();
                Set<String> UserNamesSet= new Set<String>();
                Set<String> CampaignsName= new Set<String>();
                 for (List<String> row : parsedCSV)
                 {
                   if(row.size()>=25)
                   {
                 // QueryString+=' '+row.size()+' ';
                 leadEmails.add(row[7].trim().removeStartIgnoreCase('null').remove('\n').removeStart(','));
                 UserNamesSet.add(row[24].trim());
                 CampaignsName.add(row[15].trim());
                 }
                 }
               //  QueryString=Json.Serialize(UserNamesSet);
                 List<User> usrList=[Select Username,ID from User Where Username in :UserNamesSet];
                 Map<String, User> ownersMap = new Map<String, User>();
                 for(User u:usrList)
                 {
                 ownersMap.put(u.Username,u);
                 }
                 List<Lead> leadList=[Select Email,ID from Lead Where Email in :leadEmails];
                 Map<String, Lead> leadsMap= new Map<String, Lead>();
                 for(Lead l:leadList)
                 {
                 leadsMap.put(l.Email,l);
                 }
                 List<Campaign> campList=[Select Name,ID from Campaign Where Name in :CampaignsName];
                 Map<String, Campaign> campaignsMap = new Map<String, Campaign>();
                 for(Campaign c:campList)
                 {
                 campaignsMap.put(c.Name,c);
                 }
                    for (List<String> row : parsedCSV){
                    if(row.size()>=25)
                    {
                    Integer count=0;                   
                    if(String.isNotEmpty(row[7]))
                    {
                      String emaill='';
                      if(leadsMap.get(row[7].trim().removeStartIgnoreCase('null').remove('\n').removeStart(','))!=null)
                      {
                      emaill=leadsMap.get(row[7].trim().removeStartIgnoreCase('null').remove('\n').removeStart(',')).Email;
                      }
                      if(emaill!='' && emaill!=null)
                      {
                      count=1;
                      }
                    }
                    else
                    {
                   
                    }
                     
                   if(count==0)
                   {
                   String OwnerId='';
                   //User uu=ownersMap.get(row[24].trim());
                    if(ownersMap.get(row[24].trim())!=null)
                    {
                   OwnerId=ownersMap.get(row[24].trim()).Id;
                   }
                    //String OwnerId=LeadTriggerHelper.GetUserIdByUserName(row[24].trim());
                        if(OwnerId!='' && OwnerId!=null)
                        {
                            Lead l=new Lead();
                            l.LeadSource=row[0].trim().removeStartIgnoreCase('null').remove('\n').removeStart(',');
                            if(String.isNotEmpty(row[1]))
                            {
                            l.Company=row[1].trim();
                            }
                            else
                            {
                            l.Company='CompanyName';
                            }
                            if(String.isNotEmpty(row[2]))
                            {
                            l.FirstName=row[2].trim();
                            }
                            if(row[3]!=null && row[3]!='')
                            {
                            l.LastName=row[3].trim();
                            }
                            else
                            {
                             l.LastName='Default';
                            }
                     
                           if(String.isNotEmpty(row[4]))
                           {
                            l.Title=row[4].trim();
                           }
                           if(String.isNotEmpty(row[5]))
                           {
                           l.Phone=row[5].trim();
                           }
                           if(String.isNotEmpty(row[6]))
                          {
                          l.Extension__c=row[6].trim();
                          }
                          if(String.isNotEmpty(row[7].trim().removeStartIgnoreCase('null').remove('\n').removeStart(',')))
                          {
                          l.Email=row[7].trim().removeStartIgnoreCase('null').remove('\n').removeStart(',');
                          }
                          if(String.isNotEmpty(row[8]))
                          {
                          l.Fax=row[8].trim();
                          }
                          if(String.isNotEmpty(row[9]))
                          {
                          l.Website=row[9].trim();
                          }
                          if(String.isNotEmpty(row[10]))
                          {
                          l.Shipping_Street__c=row[10].trim();
                          }
                          if(String.isNotEmpty(row[11]))
                          {
                          l.Shipping_City__c=row[11].trim();
                          }
                          if(String.isNotEmpty(row[12]))
                          {
                          l.Shipping_State_Province__c=row[12].trim();
                          }
                          if(String.isNotEmpty(row[13]))
                          {
                          l.Shipping_Zip_Postal_Code__c=row[13].trim();
                          }
                          if(String.isNotEmpty(row[14]))
                          {
                          l.Shipping_Country__c=row[14].trim();
                          }
                        // row[15] mapping is not there
                          if(String.isNotEmpty(row[16]))
                          {
                          l.AOM_Source__c=row[16].trim();
                          }
                          if(String.isNotEmpty(row[17]))
                          {
                          l.Bid_List__c=row[17].trim();
                          }
                          if(String.isNotEmpty(row[18]))
                          {
                          l.Bid_Website__c=row[18].trim();
                          }
                          if(String.isNotEmpty(row[19]))
                          {
                          l.Website_Login__c=row[19].trim();
                          }
                          if(String.isNotEmpty(row[20]))
                          {
                          l.Website_Password__c=row[20].trim();
                          }
                         if(String.isNotEmpty(row[21]))
                         {
                            try{
                                 date mydate = date.parse(row[21].trim());
                                 l.Added_to_Bid_List__c=mydate ;
                               }
                           catch(Exception e)
                           {}
                         }
                         if(String.isNotEmpty(row[22]))
                         {
                            try{
                                 date mydate = date.parse(row[22].trim());
                                 l.Updated_Bid_List_Entry__c=mydate ;
                               }
                               catch(Exception ex)
                               {}
                        }
                        if(String.isNotEmpty(row[23]))
                        {
                            try{
                            date mydate = date.parse(row[23].trim());
                                  l.Last_Checked__c=mydate;
                               }
                               catch(Exception ex)
                               {}
                        }
                           l.OwnerId=OwnerId;

                          Campaign c=campaignsMap.get(row[15].trim().removeStartIgnoreCase('null').remove('\n').removeStart(','));
                      
                         if(c!=null)
                         {
                         l.Primary_Campaign_ID__c=c.Id;
                          }
                          else
                          {
                          l.Primary_Campaign_ID__c='';
                          }
                          if(row.Size()>=26)
                          {
                          l.Description=row[25];
                          }
                          if(row.size()>=27)
                          {
                          if(string.isNotEmpty(row[26]))
                          {
                          try{
                          l.Student_Population__c=integer.valueOf(row[26].trim());
                          }catch(Exception e)
                          {}
                          }
                          }
                          if(row.size()>=28)
                          {
                          l.Academic_Search_Term__c=row[27].trim();
                          }
                          if(row.size()>=29)
                          {
                          l.Forms_URL__c=row[28].trim();
                          }
                          if(row.size()>=30)
                          {
                            l.Alt_Contact_Info__c=row[29].trim();
                          }
                          if(row.size()>=31)
                          {
                           try{
                          l.Muni_Population__c=integer.valueOf(row[30].trim());
                          }catch(Exception e)
                          {}
                         
                          }
                          if(row.size()>=32)
                          {
                            l.Industry=row[31].trim();
                          }
                          if(row.size()>=33)
                          {
                            l.Product_interest__c=row[32].trim();
                          }
                            tList.add(l);
                           uploadedLead.Add(l);
                  }
               }
                else
                {
                duplicateLeadcount+=1;
                msg.add(row[7].trim().removeStartIgnoreCase('null').remove('\n').removeStart(','));
                }
                       }
                    }
                      try
                           {
                           List<Database.SaveResult> MySaveResult= Database.insert(tList);
                         
                           List<CampaignMember> insertedCampaign=new List<CampaignMember>();
                           for(Lead lead:tList)
                           {
                           if(lead.Primary_Campaign_ID__c!='' && lead.Primary_Campaign_ID__c!=null)
                           {
                            CampaignMember mem = new CampaignMember(campaignid=lead.Primary_Campaign_ID__c,leadId=lead.Id);
                            insertedCampaign.add(mem);
                            }
                           }
                          
                            Database.insert(insertedCampaign);
                          
                            uploadedLead=tList;
                           
                           }
                           catch(System.DmlException e)
                           {
                           String error='';
                           for (Integer i = 0; i < e.getNumDml(); i++) 
                           {
                           error+=e.getDmlMessage(i);

                           }
                            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured. Please check the template '+error);
                            ApexPages.addMessage(errormsg);
                           }
                           
                }
        }
        catch(Exception ex)
        {
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured. Please check the template or try again later  '+ex.getMessage());
            ApexPages.addMessage(errormsg);
        }
    return null;
    }
    
   public List<string> getmsg()
   {
       if(msg!=NULL)
          if (msg.size() > 0)
                    return msg;
                else
                    return null;            
        else
            return null;
   }
   public Integer getduplicateLeadcount()
   {
   return duplicateLeadcount;
   }
    public List<Lead> getuploadedLead()
    {
        if (uploadedLead!= NULL)
            if (uploadedLead.size() > 0)
                return uploadedLead;
            else
                return null;                  
        else
            return null;
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
        //allFields.remove(0);
        return allFields;       
    }
    public static testMethod void testCreateLead(){
    test.startTest();
    Account acc=new Account(
            Name='Doom',
            AccountSource='Advertisement'
        );
        insert acc;
     String accountId=acc.Id;
      Boolean isManager=false;
      String username='xcvmn@xcv.com';
      String lastName='hjklmnop';
       String profileName =  'System Administrator';

        String alias = username.split('@').get(0);
        
        Profile profile = [
           select Id from Profile where Name=:profileName
        ];
        
        Contact contact = new Contact(
            AccountId = accountId, 
            LastName = lastName
        );
        insert contact;
         User user = new User(
            Username = username,
            Email = username,
            LastName = lastName,
            Alias = alias,
            ProfileID = profile.Id,
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey='UTF-8'
        );
        insert user;
        Campaign cp = new Campaign();
        cp.Name = 'Test';
        insert cp;
    Lead ld = new Lead (Firstname='testfn', Lastname='testln', 
                    Company='ABC Comp.', Status='Open', LeadSource='Site Sample Packet Request',Email='test@xcv.com'
                    ); 
        
        insert ld;
       uploadLeadcontroller obj=new uploadLeadcontroller();
        String s='Lead Source,Company,FirstName,LastName,Title,Phone,Extension,Email,fax,Website,Shipping Street,Shipping City,Shipping State/Province,Shipping Zip/Postal Code,Shipping Country,AOM Campaign,AOM Lead Source,Bid List,Bid Website URL,Login,Password,Added to Bid List,Updated Bid List Entry,Last Checked,Lead Owner,Description,StudentPopulation,Acedmic,Forms,Alternate,Muni.Pop,Industry,ProductInterest'+'\r'+
       'AOM PrintNinja,Howard Community College,Elizabeth,Moss,,443-518-4448,,bcv@xcv.com,,http://www.howardcc.edu/business_services/purchasing/,10901 Little Patuxent Parkway,Columbia,MD,21044,USA,'+cp.Name+',Press List,yes,http://www.howardcc.edu/business_services/purchasing/bid_requests.html,,,1/15/13,1/15/13,1/15/13,'+user.Username+',gf,34,fgh,fgh,fff,234,Industry,ProductInterest'+'\r'+
       'AOM PrintNinja,Howard Community College,Elizabeth,Moss,,443-518-4448,,'+ld.Email+',,http://www.howardcc.edu/business_services/purchasing/,10901 Little Patuxent Parkway,Columbia,MD,21044,USA,'+cp.Name+',Press List,yes,http://www.howardcc.edu/business_services/purchasing/bid_requests.html,,,1/15/13,1/15/13,1/15/13,'+user.Username+',gf,34,fgh,fgh,fff,23,Industry,ProductInterest'+'\r'+
       'AOM PrintNinja,Howard Community College,Elizabeth,Moss,,443-518-4448,,'+ld.Email+',,http://www.howardcc.edu/business_services/purchasing/,10901 Little Patuxent Parkway,Columbia,MD,21044,USA,'+cp.Name+',Press List,yes,http://www.howardcc.edu/business_services/purchasing/bid_requests.html,,,1/15/13,1/15/13,1/15/13,'+user.Username+',fg,34,fgh,fgh,fff,45,Industry,ProductInterest'+''; 

        Blob myBlob = Blob.valueof(s);
        obj.contentFile=myBlob;   

        obj.CreateLead();
       
        obj.getmsg();
        obj.getduplicateLeadcount();
        obj.getuploadedLead();
      
     test.stopTest();
    }
}