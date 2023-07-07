@isTest(seeAllData=false)
public class ReorderButtonControllerTest{
       
public static testMethod void testReorderButtonController(){

        PageReference pageRef = Page.ReorderButton;
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
         AccountId=acc.Id,
         Product__c='Comic Books'
         
        );
          
        insert opp; 
    
        Quote q=new Quote(
            Name='quoteNaem',
            Quoted_Created__c=Date.today(),
            Quote_Source__c='International',
            OpportunityId=opp.Id,
            PRN_additionalinfo__c='Info Goes Here',
            //PRN_basicembossdeboss__c=True,//PG 02/16/2023 - removed per direction from Jeff
            //PRN_basicfoilstamping__c=True,//PG 02/16/2023 - removed per direction from Jeff
            PRN_bindingtype__c='Casebound',
            PRN_corners__c='Square',
            PRN_coverpapercoating__c='Gloss',
            PRN_coverpaperfinishstyle__c='Gloss',
            PRN_coverpaperfinishtype__c='Lamination',
            PRN_coverpaperweight__c='80lb',
            PRN_dustjacket__c=True,
            PRN_dustjacketfinishstyle__c='Gloss',
            PRN_endsheets__c='Separated',
            PRN_headtailbands__c='RedYellow',
            PRN_height__c=8.5,
            PRN_insidepagecount__c=16,
            PRN_insidepapercoating__c='matte',
            PRN_insidepaperweight__c='70lb',
            PRN_printingcolor__c='CMYK',
            PRN_printoninsidecoversendsheets__c=True,
            PRN_proofing__c='Electronic',
            //PRN_spotuv__c=True,//PG 02/16/2023 - removed per direction from Jeff
            PRN_width__c=11,
            Display_Quantity_1__c=1000,
            Use_to_Calculate_ROW_1__c='Yes',
            Expedited_Quantity_1__c=100
            
            
        );
        
        insert q;    
        ApexPages.StandardController qq=new ApexPages.StandardController(opp);
        ApexPages.currentPage().getParameters().put('id',opp.Id);
        ReorderButtonController controller=new ReorderButtonController(qq);
        
        
        
        PageReference pref=controller.autoRun();
        //String nextPage = controller.convertLead().getUrl();

        // Verify that the success page displays
        //System.assertEquals('/apex/success', nextPage);
        test.stopTest();
        

    }
}