@isTest
public class QuoteTriggerTest{
    public static testMethod void unitTest01(){
        list<CustomMarkupConfiguration__c> cmcList = new list<CustomMarkupConfiguration__c>();
        cmcList.add(new CustomMarkupConfiguration__c(Name='1', Cost_Low__c = 0, Cost_Max__c = 200, Saddle_Perfect_Binding_Printing_Cost_Mar__c = 10, Add_On_Cost_Markup__c = 100));
        cmcList.add(new CustomMarkupConfiguration__c(Name='2', Cost_Low__c = 0, Cost_Max__c = 200, Case_Binding_Printing_Cost_Markup__c = 10, Add_On_Cost_Markup__c = 100));
        cmcList.add(new CustomMarkupConfiguration__c(Name='3', Cost_Low__c = 0, Cost_Max__c = 200, Board_Book_Printing_Cost_Markup__c = 10, Add_On_Cost_Markup__c = 100));
        cmcList.add(new CustomMarkupConfiguration__c(Name='4', Cost_Low__c = 0, Cost_Max__c = 200, Wire_Spiral_Binding_Cost_Markup__c = 10, Add_On_Cost_Markup__c = 100));
        insert cmcList;
        
        Account acc=new Account(
            Name='Doom',
            AccountSource='Advertisement'
        );
        insert acc;
        
        Contact c=new Contact(
            LastName='Marial',
            AccountId=acc.Id,
            Is_Primary__c=true,
            MailingCity='India',
            MailingState='India',
            MailingCountry='India',
            MailingPostalCode='201206',
            MailingStreet='India'
        );
        insert c;
        
        Opportunity opp=new Opportunity(
            Name='Doomstone',
            CloseDate=Date.today(),
            Opportunity_Vendor__c='International',
            StageName='Closed Won',
            AccountId=acc.Id,
            Production_Status__c='Updated'
        );
        
        insert opp; 
        Quote q=new Quote(
            Name='quoteNaem',
            Quoted_Created__c=Date.today(),
            Quote_Source__c='International',
            OpportunityId=opp.Id,
            Use_to_Calculate_ROW_1__c='Yes',
            Total_Quantity_1__c=10,
            Additional_Charge_s_1__c=10,
            Total_Quantity_2__c=10,
            Additional_Charge_s_2__c=10,
            Total_Quantity_3__c=10,
            Additional_Charge_s_3__c=10,
            Total_Quantity_4__c=10,
            Additional_Charge_s_4__c=10,
            Product_Price_1__c = 10,
            Product_Price_2__c = 10,
            Product_Price_3__c = 10,
            Product_Price_4__c = 10,
            PRN_bindingtype__c = 'Saddle stitching',
            Product_Purchase_Cost1__c = 120
        );
        insert q;
        
        Quote q2=new Quote(
            Name='quoteNaem',
            Quoted_Created__c=Date.today(),
            Quote_Source__c='International',
            OpportunityId=opp.Id,
            Use_to_Calculate_ROW_2__c='Yes',
            Total_Quantity_1__c=10,
            Additional_Charge_s_1__c=10,
            Total_Quantity_2__c=10,
            Additional_Charge_s_2__c=10,
            Total_Quantity_3__c=10,
            Additional_Charge_s_3__c=10,
            Total_Quantity_4__c=10,
            Additional_Charge_s_4__c=10,
            PRN_bindingtype__c = 'Case (Hardcover)',
            Product_Purchase_Cost1__c = 120
        );
        try{
            insert q2;
        }catch(Exception e){}
        test.startTest();      
        
        update q;
        
        test.stopTest();
    }
    
    public static testMethod void unitTest02(){
        list<CustomMarkupConfiguration__c> cmcList = new list<CustomMarkupConfiguration__c>();
        cmcList.add(new CustomMarkupConfiguration__c(Name='1', Cost_Low__c = 0, Cost_Max__c = 200, Saddle_Perfect_Binding_Printing_Cost_Mar__c = 10, Add_On_Cost_Markup__c = 100));
        cmcList.add(new CustomMarkupConfiguration__c(Name='2', Cost_Low__c = 0, Cost_Max__c = 200, Case_Binding_Printing_Cost_Markup__c = 10, Add_On_Cost_Markup__c = 100));
        cmcList.add(new CustomMarkupConfiguration__c(Name='3', Cost_Low__c = 0, Cost_Max__c = 200, Board_Book_Printing_Cost_Markup__c = 10, Add_On_Cost_Markup__c = 100));
        cmcList.add(new CustomMarkupConfiguration__c(Name='4', Cost_Low__c = 0, Cost_Max__c = 200, Wire_Spiral_Binding_Cost_Markup__c = 10, Add_On_Cost_Markup__c = 100));
        insert cmcList;
        
        Account acc=new Account(
            Name='Doom',
            AccountSource='Advertisement'
        );
        insert acc;
        
        Contact c=new Contact(
            LastName='Marial',
            AccountId=acc.Id,
            Is_Primary__c=true,
            MailingCity='India',
            MailingState='India',
            MailingCountry='India',
            MailingPostalCode='201206',
            MailingStreet='India'
        );
        insert c;
        
        Opportunity opp=new Opportunity(
            Name='Doomstone',
            CloseDate=Date.today(),
            Opportunity_Vendor__c='International',
            StageName='Closed Won',
            AccountId=acc.Id,
            Production_Status__c='Updated'
        );
        
        insert opp; 
        Quote q=new Quote(
            Name='quoteNaem',
            Quoted_Created__c=Date.today(),
            Quote_Source__c='International',
            OpportunityId=opp.Id,
            Use_to_Calculate_ROW_1__c='Yes',
            Total_Quantity_1__c=10,
            Additional_Charge_s_1__c=10,
            Total_Quantity_2__c=10,
            Additional_Charge_s_2__c=10,
            Total_Quantity_3__c=10,
            Additional_Charge_s_3__c=10,
            Total_Quantity_4__c=10,
            Additional_Charge_s_4__c=10,
            PRN_bindingtype__c = 'Board Book',
            Product_Purchase_Cost1__c = 120
        );
        insert q;
        
        
        test.startTest();      
        
        Quote q2=new Quote(
            Name='quoteNaem',
            Quoted_Created__c=Date.today(),
            Quote_Source__c='International',
            OpportunityId=opp.Id,
            Use_to_Calculate_ROW_2__c='Yes',
            Total_Quantity_1__c=10,
            Additional_Charge_s_1__c=10,
            Total_Quantity_2__c=10,
            Additional_Charge_s_2__c=10,
            Total_Quantity_3__c=10,
            Additional_Charge_s_3__c=10,
            Total_Quantity_4__c=10,
            Additional_Charge_s_4__c=10,
            Product_Price_1__c = 10,
            Product_Price_2__c = 10,
            Product_Price_3__c = 10,
            Product_Price_4__c = 10,
            PRN_bindingtype__c = 'Wire binding',
            Product_Purchase_Cost1__c = 120
        );
        try{
            insert q2;
        }catch(Exception e){}
        
        test.stopTest();
    }
}