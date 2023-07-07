@isTest(seeAllData=false)
public class QuoteHelpertest{
/*    public static testMethod void testQuotehelper(){
    test.startTest();
        Account acc=new Account(
            Name='Doom'
        );
        insert acc;
        
        Contact c=new Contact(
         LastName='Marial',
         AccountId=acc.Id
   
        );
        insert c;
        Opportunity opp=new Opportunity(
         Name='Doomstone',
         CloseDate=Date.today(),
         Opportunity_Vendor__c='International',
         StageName='Draft',
         AccountId=acc.Id,
         Probability=0
         
        );
          
        insert opp; 
    
        Quote q=new Quote(
            Name='quoteNaem',
            Quoted_Created__c=Date.today(),
            Quote_Source__c='International',
            OpportunityId=opp.Id,
            Use_to_Calculate_ROW_1__c='Yes'
            
            
        );
        
        insert q;    
       
        q.Use_to_Calculate_ROW_1__c='No';
        q.Use_to_Calculate_ROW_2__c='Yes';
       
 //         q.Quote_Source__c='Domestic';
           update q;
         update opp;
        q.Use_to_Calculate_ROW_1__c='No';
        q.Use_to_Calculate_ROW_2__c='No';
        q.Use_to_Calculate_ROW_3__c='Yes';
       
//                 opp.StageName='Closed Won';
//                  opp.Opportunity_Vendor__c='Domestic';
//                  opp.Production_Status__c='Waiting for Artwork';
//                   q.Quote_Source__c='Domestic';
          update q;
//         update opp;
        q.Use_to_Calculate_ROW_4__c='Yes';
        q.Use_to_Calculate_ROW_3__c='No';
       
//                  opp.StageName='Closed Won';
//                   opp.Opportunity_Vendor__c='Domestic';
//                   opp.Production_Status__c='Waiting for Artwork';
//                   q.Quote_Source__c='Domestic';
           update q;
         update opp;
        q.Use_to_Calculate_ROW_4__c='No';
        q.Use_to_Calculate_ROW_11__c='Yes';
        q.Total_Quantity_12__c=null;
         q.Dom_Purch_Price_11__c=0;
        q.Dom_Vendor_s_Freight_Charge_11__c=0;
        q.Domestic_Markup_11__c=q.Domestic_Markup_11__c=0;
         q.Tax_11__c=0;
       
                  opp.StageName='Closed Won';
                   opp.Opportunity_Vendor__c='Domestic';
                   opp.Production_Status__c='Waiting for Artwork';
                   q.Quote_Source__c='Domestic';
           update q;
         update opp;
        
        q.Use_to_Calculate_ROW_11__c='No';
         q.Use_to_Calculate_ROW_12__c='Yes';
                 q.Total_Quantity_12__c=1;
          q.Dom_Purch_Price_12__c=0;
        q.Dom_Vendor_s_Freight_Charge_12__c=0;
        q.Domestic_Markup_12__c=q.Domestic_Markup_12__c=0;
         q.Tax_12__c=0;
       
                  opp.StageName='Closed Won';
                   opp.Opportunity_Vendor__c='Domestic';
                   opp.Production_Status__c='Waiting for Artwork';
                   q.Quote_Source__c='Domestic';
           update q;
         update opp;
         q.Use_to_Calculate_ROW_12__c='No';
         q.Use_to_Calculate_ROW_13__c='Yes';
                 q.Total_Quantity_13__c=1;
          q.Dom_Purch_Price_13__c=0;
        q.Dom_Vendor_s_Freight_Charge_13__c=0;
        q.Domestic_Markup_13__c=q.Domestic_Markup_13__c=0;
         q.Tax_13__c=0;
       
                  opp.StageName='Closed Won';
                   opp.Opportunity_Vendor__c='Domestic';
                   opp.Production_Status__c='Waiting for Artwork';
                   q.Quote_Source__c='Domestic';
           update q;
         update opp;
          q.Use_to_Calculate_ROW_13__c='No';
         q.Use_to_Calculate_ROW_14__c='Yes';
                 q.Total_Quantity_14__c=1;
          q.Dom_Purch_Price_14__c=0;
        q.Dom_Vendor_s_Freight_Charge_14__c=0;
        q.Domestic_Markup_14__c=q.Domestic_Markup_14__c=0;
         q.Tax_14__c=0;
       
                  opp.StageName='Closed Won';
                   opp.Opportunity_Vendor__c='Domestic';
                   opp.Production_Status__c='Waiting for Artwork';
                   opp.Probability=0;
                   q.Quote_Source__c='Domestic';
           update q;
         update opp;
        
         Quote quote=new QuoteHelper().getByOpportunity(opp.Id);
         List<Quote> quote_list=new Quotehelper().getQuotesByOpportunityID(opp.Id);
        
         Opportunity opp1=new Opportunity(
         Name='Doomstone',
         CloseDate=Date.today(),
         Opportunity_Vendor__c='International',
         StageName='Closed Won',
         AccountId=acc.Id,
        Production_Status__c='Waiting for Artwork'
         
        );
          
        insert opp1; 
    
        Quote q1=new Quote(
            Name='quoteNaem',
            Quoted_Created__c=Date.today(),
            Quote_Source__c='International',
            OpportunityId=opp1.Id,
            Use_to_Calculate_ROW_1__c='Yes'
            
            
        );
        
        insert q1;  
        opp1.Name='Dfghgj'; 
        update opp1;
        q1.Use_to_Calculate_ROW_1__c='No';
        q1.Use_to_Calculate_ROW_2__c='Yes';
        update q1;
        update opp1;
         
        test.stopTest();
    }
   */ 
    public static testMethod void testOpportunityHelper(){
        test.startTest();
         Account acc=new Account(
            Name='Doom'
        );
        insert acc;
        
        Contact c=new Contact(
         LastName='Marial',
         AccountId=acc.Id
   
        );
        insert c;
        Opportunity opp=new Opportunity(
         Name='Doomstone',
         CloseDate=Date.today(),
         Opportunity_Vendor__c='International',
         StageName='Draft',
         AccountId=acc.Id
         
        );
          
        insert opp; 
       
       
        
        Opportunity quote=new OpportunityHelper().getByOpportunity(opp.Id);
        Opportunity opp11=new OpportunityHelper().getByJobNumber(''+quote.Job_Number1__c);
       // new OpportunityHelper().setTaskByOppStage(opp11.Id,'Draft');
        //new OpportunityHelper().setTaskByOppStage(opp11.Id,'Quoted by China');
        //new OpportunityHelper().setTaskByOppStage(opp11.Id,'Proposal/ Custom Quote');
       // new OpportunityHelper().setTaskByOppStage(opp11.Id,'Proposal/ Online Blind Quote');
       // opp11.StageName='Draft';
       // update opp11;
       // opp11.StageName='Quoted by China';
       // update opp11;
       // opp11.StageName='Proposal/ Custom Quote';
       // update opp11;
        
       // opp11.StageName='Proposal/ Online Blind Quote';
       // update opp11;
        test.stopTest();
    }
    
    public static testMethod void testContactHelper(){
        test.startTest();
         Account acc=new Account(
            Name='Doom'
        );
        insert acc;
        
        Contact c=new Contact(
         LastName='Marial',
         AccountId=acc.Id,
          Is_Primary__c=true
   
        );
        
        Contact c1=new Contact(
         LastName='Marial12',
         AccountId=acc.Id
        
        );
        insert c;
        insert c1;
        Contact quote=ContactHelper.getPrimaryContactByAccount(acc.Id);
        test.stopTest();
    }
    
}