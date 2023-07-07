@isTest(SeeAllData=true)
public class ExportReport_SchedularTest {
    @isTest static void unitTest() {
        Test.startTest();
            String hour = String.valueOf(Datetime.now().hour());
            String min = String.valueOf(Datetime.now().minute()); 
            String ss = String.valueOf(Datetime.now().second());
            
            //parse to cron expression
            String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';
            System.schedule('Job Started At', nextFireTime, new ExportReport_Schedular());
        Test.stopTest();
    }
}