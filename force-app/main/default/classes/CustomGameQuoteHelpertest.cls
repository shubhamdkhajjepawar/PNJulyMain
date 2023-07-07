@isTest(seeAllData=true)
public class CustomGameQuoteHelpertest{
    public static testMethod void testCustomGameQuotehelper(){
    test.startTest();
        Account acc=new Account(
            Name='Wally'
        );
        insert acc;
        
        Contact c=new Contact(
         LastName='West',
         AccountId=acc.Id
   
        );
        insert c;
        Opportunity opp=new Opportunity(
         Name='Rebirth',
         CloseDate=Date.today(),
         Opportunity_Vendor__c='International',
         StageName='Draft',
         AccountId=acc.Id,
         Probability=0
         
        );
          
        insert opp; 
    
        Custom_Game_Quote__c q=new Custom_Game_Quote__c(
            Name='bestgameever',
            Use_to_Calculate_ROW_1__c='Yes',
            Opportunity__c=opp.id,
            Ship_To_Street__c='123 Flash St',
            Ship_To_City__c='Keystone City',
            Ship_To_State_Province__c='KS',
            Ship_To_Zip_Postal_Code__c='67003',
            Ship_To_Country__c='United States',
            Residential_Address__c='Yes',
            Assembly_Cost_1__c=0,
            Quote_From_Calculator__c = FALSE,
            Order_Quantity_1__c=12,
            Expedited_Quantity_1__c=16,
            Ocean_Freight_Cost_1__c=2093,
            Tax_1__c=23940,
            Ground_Freight_Cost_1__c=233,
            Expedited_Freight_Cost_1__c=2409,
            Additional_charges_1__c=2093,
            Prototyping_Cost_1__c=293.00,
            Assembly_Cost_2__c=0,
            Order_Quantity_2__c=12,
            Expedited_Quantity_2__c=16,
            Ocean_Freight_Cost_2__c=2093,
            Tax_2__c=23940,
            Ground_Freight_Cost_2__c=233,
            Expedited_Freight_Cost_2__c=2409,
            Additional_charges_2__c=2093,
            Prototyping_Cost_2__c=293.00
            
        );
        
        insert q;    
        
        Custom_Game_Quote__c r=new Custom_Game_Quote__c(
            Name='anokaygame',
            Opportunity__c=opp.id
            
            
        );
        
        insert r;  
       
        q.Use_to_Calculate_ROW_1__c='No';
        q.Use_to_Calculate_ROW_2__c='Yes';
       
           update q;
         update opp;
        q.Use_to_Calculate_ROW_1__c='Yes';
        q.Use_to_Calculate_ROW_2__c='No';
       
           update q;
        
        opp.StageName='Closed Won';
        opp.Production_Status__c='Waiting For Artwork';
         update opp;
        
        q.Use_to_Calculate_ROW_1__c='No';
        q.Use_to_Calculate_ROW_2__c='Yes';
       
           update q;
        
        opp.StageName='Closed Won';
        opp.Production_Status__c='Ready For Proofing';
         update opp;
         
        test.stopTest();
    }
    
    public static testMethod void testOpportunityHelper(){
        test.startTest();
         Account acc=new Account(
            Name='Wally'
        );
        insert acc;
        
        Contact c=new Contact(
         LastName='West',
         AccountId=acc.Id
   
        );
        insert c;
        Opportunity opp=new Opportunity(
         Name='Rebirth',
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
            Name='Wally'
        );
        insert acc;
        
        Contact c=new Contact(
         LastName='West',
         AccountId=acc.Id,
          Is_Primary__c=true
   
        );
        
        Contact c1=new Contact(
         LastName='West12',
         AccountId=acc.Id
        
        );
        insert c;
        insert c1;
        Contact quote=ContactHelper.getPrimaryContactByAccount(acc.Id);
        test.stopTest();
    }
    
}