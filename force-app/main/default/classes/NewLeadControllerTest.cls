@isTest(seeAllData=false)
public class NewLeadControllerTest{
    public static testMethod void testNewLeadController(){
        list<AutoNumberConfiguration__c> acs = new list<AutoNumberConfiguration__c>();
        acs.add(new AutoNumberConfiguration__c(Name = 'Others', Last_Generated_Number__c = 0));
        insert acs;
        
        PageReference pageRef = Page.Convert_Lead;
        Test.setCurrentPage(pageRef);
        test.startTest();        
        Lead ld = new Lead (Firstname='testfn', Lastname='testln', Company='ABC Comp.', Status='Open', LeadSource='Site Sample Packet Request'); 
        insert ld;
        
        ApexPages.currentPage().getParameters().put('id',ld.Id);
        NewLeadController controller=new NewLeadController();        
        controller.hidden_convert_status='1';
        controller.convert_Lead=new Convert_Lead__c();
        controller.convert_Lead.User__c= UserInfo.getUserId();
        controller.convert_Lead.Reminder_Date__c=System.now().date();
        controller.convert_Lead.Reminder_Time__c='07:00 AM';
        controller.convert_Lead.Opportunity_Name__c='Doomstone';
        controller.hidden_account='000000000000000';
        controller.accnt='000000000000000';
        PageReference pref=controller.convertLead();
        //String nextPage = controller.convertLead().getUrl();
        
        // Verify that the success page displays
        //System.assertEquals('/apex/success', nextPage);
        test.stopTest();        
    }
}