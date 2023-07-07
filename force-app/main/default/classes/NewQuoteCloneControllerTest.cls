@isTest(seeAllData=false)
public class NewQuoteCloneControllerTest{
       
public static testMethod void testNewQuoteCloneController(){

        PageReference pageRef = Page.QuoteClone;
        Test.setCurrentPage(pageRef);
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
    
        Quote q=new Quote(
            Name='quoteNaem',
            Quoted_Created__c=Date.today(),
            Quote_Source__c='International',
            OpportunityId=opp.Id,
            Use_to_Calculate_ROW_1__c='Yes'
            
            
        );
        
        insert q;    
        ApexPages.StandardController qq=new ApexPages.StandardController(q);
        ApexPages.currentPage().getParameters().put('id',q.Id);
        NewQuoteCloneController controller=new NewQuoteCloneController(qq);
        
        
        
        PageReference pref=controller.autoRun();
        //String nextPage = controller.convertLead().getUrl();

        // Verify that the success page displays
        //System.assertEquals('/apex/success', nextPage);
        test.stopTest();
        

    }
}