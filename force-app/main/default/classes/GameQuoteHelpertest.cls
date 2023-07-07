@isTest(seeAllData=true)
public class GameQuoteHelpertest{
    public static testMethod void testGameQuotehelper(){
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
    
        Game_Quote__c q=new Game_Quote__c(
            Name='gamequote',
            Use_to_Calculate_ROW_1__c='Yes',
            Opportunity__c=opp.id,
            gq_shiptostreet__c='123 Penny Lane',
            gq_shiptocity__c='Skevanston',
            gq_shiptostate__c='IL',
            gq_shiptozip__c='60201',
            gq_shiptocountry__c='USA',
            newshipping_residential__c='Yes',
            Assembly_Cost_1__c=0,
            Quote_From_Calculator__c = FALSE,
            Total_Quantity_1__c=12,
            Expedited_Quantity_1__c=16,
            Product_Purchase_Markup1__c=24,
            Ocean_Freight_1__c=2093,
            Ocean_Freight_Markup_i1__c=293,
            Tax_1__c=23940,
            Grd_Freight_1__c=233,
            Ground_Freight_Markup_i1__c=390,
            Expedited_Freight_1__c=2409,
            Expedited_Freight_Markup_i1__c=20,
            Additional_charge_s_1__c=2093,
            Prototyping_Cost_1__c=293.00,
            Assembly_Cost_2__c=0,
            Total_Quantity_2__c=12,
            Expedited_Quantity_2__c=16,
            Product_Purchase_Markup2__c=24,
            Ocean_Freight_2__c=2093,
            Ocean_Freight_Markup_i2__c=293,
            Tax_2__c=23940,
            Grd_Freight_2__c=233,
            Ground_Freight_Markup_i2__c=390,
            Expedited_Freight_2__c=2409,
            Expedited_Freight_Markup_i2__c=20,
            Additional_charge_s_2__c=2093,
            Prototyping_Cost_2__c=293.00
            
        );
        
        insert q;    
        
        Game_Quote__c r=new Game_Quote__c(
            Name='secondgamequote',
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