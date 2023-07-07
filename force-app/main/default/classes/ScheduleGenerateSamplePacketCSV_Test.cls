/*
 * Test class for 'ScheduleGenerateSamplePacketCSV' schedule class.
 */
@isTest
private class ScheduleGenerateSamplePacketCSV_Test {

    private static testMethod void testInit() {
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        
        Test.startTest();
        String jobId = System.schedule( 'testGenerateSamplePacketCSV',
                                        CRON_EXP, 
                                        new ScheduleGenerateSamplePacketCSV()
                                       );
        
        CronTrigger ct = [ SELECT Id, CronExpression FROM CronTrigger WHERE id =: jobId ];

        // Verify the cron expressions are the same    
        System.assertEquals( CRON_EXP, ct.CronExpression );
        
        Test.stopTest();    
    }
}