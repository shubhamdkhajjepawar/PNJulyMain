/*
 * Test class for Lead batch class which is used to generate CSV file.
 */
@isTest( seeAllData = true)
private class BatchGenerateSamplePacketCSV_Test {
    // Test method for 'BatchGenerateSamplePacketCSV' batch class to generate CSV:
    private static testMethod void testGeneratreSamplePacketCSVBatch() {
        // Insert lead records first:
        List<Lead> leadsList = createtestData();
        insert leadsList;
        
        Test.startTest();
            BatchGenerateSamplePacketCSV.runJob();
        Test.stopTest();
        
        // For testing purpose:
        // Get the ducuments under folder 'Sample Packets'. There should be a created in it.
        List<Document> docsList = [ SELECT Id FROM Document WHERE FolderId =: [SELECT Id FROM Folder WHERE Name = 'Sample Packets' LIMIT 1] ];
        System.assert( docsList.size() > 0 );
    }
    
    // Create test data. Method returns a list for instances od Lead to create
    private static List<Lead> createTestData() {
        // Lead records list
        List<Lead> leadsList = new List<Lead>();
        for( Integer i = 0; i < 10; i++ ) {
            // Add a Lead to list:
            Lead newLead = new Lead( FirstName = 'Test',
                                     LastName = 'Lead', 
                                     Company = 'Test Company', 
                                     Status = 'Open', 
                                     State = 'Test State', 
                                     Include_In_SamplePacketCSV__c = true, 
                                     LeadSource = Constants.Lead_Source_Site_Sample_Packet_Request, 
                                     Street_Address1__c = 'Street Address 1', 
                                     Street_Address2__c = 'Street Address 2', 
                                     PostalCode = '123456789', 
                                     Country = 'US'
                                    );
        leadsList.add( newLead );
        }
        
        return leadsList;
    }
}