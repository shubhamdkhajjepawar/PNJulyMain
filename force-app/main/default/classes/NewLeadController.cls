public class NewLeadController{
    
    private Lead lead;
    public Convert_Lead__c convert_Lead;
    private List<SelectOption> AccountItems;
    public String accnt;
    public String hidden_account;
    public String hidden_convert_status;
    public String email;
    
    public NewLeadController(){
        this.convert_Lead=new Convert_Lead__c();
        this.lead=[select Id,Name,Company from Lead where Id= :ApexPages.currentPage().getParameters().get('id')]; 
        this.convert_Lead.User__c= UserInfo.getUserId();
        this.convert_Lead.Reminder_Date__c=System.now().date();
        this.convert_Lead.Opportunity_Name__c=lead.Company+'-';
        AccountItems=new List<SelectOption>();
        AccountItems.add(new SelectOption('000000000000000','Create New Account:'+lead.Company));
        accnt='000000000000000';
        hidden_account=accnt;
        hidden_convert_status='1';
        
    }
    public Convert_Lead__c  getConvert_Lead(){
        return convert_Lead;
    }
    
    public Lead getLead(){
        return lead;
    }
    
    public PageReference convertLead(){
        try{
            this.lead=[select Id,Name,Email,LeadSource,Graphics__c,Product_interest__c,FirstName,LastName,Description,Company,Billing_Street__c,Billing_City__c,Billing_Country__c,Billing_State_Province__c,Billing_Zip_Postal_Code__c,Shipping_Street__c,Shipping_City__c,Shipping_Country__c,Shipping_State_Province__c,Shipping_Zip_Postal_Code__c,Extension__c,Question_from_website__c,Quote_Request_from_website__c,Contact_Preference__c,Last_Visited_Pages__c,Bid_List__c,Bid_Website__c,Last_Checked__c,Added_to_Bid_List__c,Sample_Packet_Required__c,Updated_Bid_List_Entry__c,AOM_Source__c,Website_Login__c,Website_Password__c,Student_Population__c,Academic_Search_Term__c,Forms_URL__c,Alt_Contact_Info__c,Muni_Population__c from Lead where Id= :ApexPages.currentPage().getParameters().get('id')]; 
            
            Account account;
            if(hidden_account!=accnt){
                account=[select Id from Account where Id= :hidden_account];
            }
            User user=[select Id from User where Id= :convert_Lead.User__c];
            Database.LeadConvert leadConvert=new Database.LeadConvert();
            leadConvert.setLeadId(lead.id);
            leadConvert.setOwnerId(user.id);
            if(account!=null){
                leadConvert.setAccountID(account.id);
            }
            
            LeadStatus[] convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true];
            Integer i=Integer.valueof(hidden_convert_status);
            leadConvert.setConvertedStatus(convertStatus[i-1].MasterLabel);
            leadConvert.setSendNotificationEmail(convert_Lead.Email_To_Owner__c);
            leadConvert.setDoNotCreateOpportunity(convert_Lead.Can_Create_Opportunity__c);
            if(convert_Lead.Can_Create_Opportunity__c!=true){
                leadConvert.setOpportunityName(convert_Lead.Opportunity_Name__c);
            }
            Database.LeadConvertResult lcr = Database.convertLead(leadConvert);
            
            
            
            if(hidden_account==accnt){
                //updating account details which is created in convert lead process
                Account createdAccount=[select Id,AccountSource,Email__c,Description,Contact_Name__c,BillingStreet,BillingCity,BillingCountry,BillingState,BillingPostalCode,ShippingStreet,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode from Account where Id= :lcr.getAccountId()];             
                createdAccount.BillingStreet=lead.Billing_Street__c;
                createdAccount.BillingCity=lead.Billing_City__c;
                createdAccount.BillingState=lead.Billing_State_Province__c;
                createdAccount.BillingPostalCode=lead.Billing_Zip_Postal_Code__c;
                createdAccount.BillingCountry=lead.Billing_Country__c;
                createdAccount.ShippingStreet=lead.Shipping_Street__c;
                createdAccount.ShippingCity=lead.Shipping_City__c;
                createdAccount.ShippingState=lead.Shipping_State_Province__c;
                createdAccount.ShippingPostalCode=lead.Shipping_Zip_Postal_Code__c;
                createdAccount.ShippingCountry=lead.Shipping_Country__c;
                createdAccount.Contact_Name__c=lead.FirstName+' '+lead.LastName;
                createdAccount.Email__c=lead.Email;
                createdAccount.AccountSource=lead.LeadSource;
                createdAccount.Description=lead.Description;
                createdAccount.Graphics__c=lead.Graphics__c;
                createdAccount.Product_Interest__c=lead.Product_interest__c;
                createdAccount.Extension__c=lead.Extension__c;
                createdAccount.Quote_Request_from_website__c=lead.Quote_Request_from_website__c;
                createdAccount.Question_from_website__c=lead.Question_from_website__c;
                createdAccount.Contact_Preference__c=lead.Contact_Preference__c;
                createdAccount.Last_Visited_Pages__c=lead.Last_Visited_Pages__c;
                // These fields Added On 2nd April 2012 By Pankaj
                createdAccount.Bid_List__c=lead.Bid_List__c;
                createdAccount.Bid_Website__c=lead.Bid_Website__c;
                createdAccount.Last_Checked__c=lead.Last_Checked__c;
                createdAccount.Added_to_Bid_List__c=lead.Added_to_Bid_List__c;
                createdAccount.Sample_Packet_Required__c=lead.Sample_Packet_Required__c;
                createdAccount.Updated_Bid_List_Entry__c=lead.Updated_Bid_List_Entry__c;
                createdAccount.Website_Password__c=lead.Website_Password__c;
                createdAccount.Website_Login__c=lead.Website_Login__c;
                createdAccount.AOM_Source__c=lead.AOM_Source__c;
                createdAccount.Student_Population__c=lead.Student_Population__c;
                createdAccount.Academic_Search_Term__c=lead.Academic_Search_Term__c;
                createdAccount.Forms_URL__c=lead.Forms_URL__c;
                createdAccount.Alt_Contact_Info__c=lead.Alt_Contact_Info__c;
                createdAccount.Muni_Population__c=lead.Muni_Population__c;
                update createdAccount;
            }
            //updating contact details which is created in convert lead process
            Contact contact=[select Id,MailingStreet,Description,MailingCity,MailingCountry,MailingState,MailingPostalCode,OtherStreet,OtherCity,OtherCountry,OtherState,OtherPostalCode from Contact where Id= :lcr.getContactId()];
            contact.MailingStreet=lead.Shipping_Street__c;
            contact.MailingCity=lead.Shipping_City__c;
            contact.MailingCountry=lead.Shipping_Country__c;
            contact.MailingState=lead.Shipping_State_Province__c;
            contact.MailingPostalCode=lead.Shipping_Zip_Postal_Code__c;
            contact.OtherStreet=lead.Billing_Street__c;
            contact.OtherCity=lead.Billing_City__c;
            contact.OtherCountry=lead.Billing_Country__c;
            contact.OtherState=lead.Billing_State_Province__c;
            contact.OtherPostalCode=lead.Billing_Zip_Postal_Code__c;
            contact.Description='';
            contact.Extension__c=lead.Extension__c;
            contact.Contact_Preference__c=lead.Contact_Preference__c;
            contact.Is_Primary__c=true;
            update contact;
            
            if(convert_Lead.Can_Create_Opportunity__c!=true){
                //updating opportunities which is created in convert lead process
                Opportunity opportunity=[select Id,Contact__c,AccountId,Product__c,Opportunity_Source__c from Opportunity where Id= :lcr.getOpportunityId()];
                opportunity.Contact__c=lcr.getContactId();
                opportunity.Opportunity_Source__c=lead.LeadSource;
                opportunity.Product__c=lead.Product_interest__c;
                opportunity.CloseDate=Date.today().addDays(30);
                update opportunity;
            }
            
            //creating 
            if(convert_Lead.Subject__c != null){
                Task newTask = new Task(Description = convert_Lead.Comment__c,
                                        Priority = convert_Lead.Priority__c, 
                                        Status = convert_Lead.Status__c, 
                                        Subject = convert_Lead.Subject__c, 
                                        IsReminderSet = convert_Lead.Reminder__c, 
                                        ReminderDateTime = DateTime.parse(convert_Lead.Reminder_Date__c.format()+' '+convert_Lead.Reminder_Time__c), 
                                        WhoId = lcr.getContactId(),
                                        WhatId=lcr.getAccountId()
                                       );             
                insert newTask;
            }
            PageReference p=new PageReference('/'+String.valueof(lcr.getAccountId()));
            p.setRedirect(true);
            return p;
            
        }
        catch(System.DmlException ex){
            ApexPages.addMessages(ex);
        }
        return null;
    }
    
    
    
    public String getHidden_Account(){
        return hidden_account;
    }
    
    public void setHidden_Account(String hid_acc){
        this.hidden_account=hid_acc;
    }
    
    public String getHidden_Convert_Status(){
        return hidden_convert_status;
    }
    
    public void setHidden_Convert_Status(String hid_cs){
        this.hidden_convert_status=hid_cs;
    }
}