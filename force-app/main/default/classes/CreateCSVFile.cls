public with sharing class CreateCSVFile {

     public static String seperator = ',';
     public static String newLine = '\n';
     
     public static List<String> listCCEmailAddresses = new List<String>();
     private static String SAMPLE_PACKET_EMAIL_RECEIVER_CONTACT_ID_KEY = 'Sample Packet Email Receiver Contact ID';
     private static String SAMPLE_PACKET_EMAIL_TEMPLATE_ID_KEY = 'Sample Packet Email Template ID';
     private static String SAMPLE_PACKET_CC_EMAIL_ADDRESS = 'Sample Packet CC Email Address';
     public static  String SAMPLE_PACKET_EMAIL_RECEIVER_CONTACT_ID = null;
     public static  String SAMPLE_PACKET_EMAIL_TEMPLATE_ID = null;
    
     //method to return blank string if value is null
     private static String getString(String val){
         return (val == null ? '' : validateString(String.valueOf(val)));
     }
     
     private static String validateString(String strInputValue) {
         
         String strOutputValue = strInputValue.replace(strInputValue, '"' + strInputValue + '"');
         return strOutputValue;
     }
     
     public static String generateCSVFile(List<Lead> listLead) {
         
         String headerRow = 'Firstname,Lastname,Street Address 1,Street Address 2,State,Postal Code,Country';
         
         //data row content
         String dataRows = headerRow;
         
         //loop over records to generate row content
         for(Lead l : listLead){
             dataRows = dataRows + (newLine + getString(l.Firstname) + seperator + getString(l.Lastname) + seperator
                             + getString(l.Street) + seperator + getString(l.Street_Address2__c) + seperator + getString(l.State)
                             + seperator + getString(l.PostalCode) + seperator + (l.Country != Label.Country_United_States ? getString(l.Country) : '')
                            );
         }
         
         return dataRows;
     }
     
     //method to get CSV Email Receiver Contact ID
     public static void setSamplePacketCSVEmailParams(){
        
        for(Organization_Configuration_Manager__c config : [Select Id, Parameter_Key__c, Parameter_Value__c 
                                                      From Organization_Configuration_Manager__c 
                                                      where Parameter_Key__c =: SAMPLE_PACKET_EMAIL_RECEIVER_CONTACT_ID_KEY 
                                                      OR Parameter_Key__c =: SAMPLE_PACKET_EMAIL_TEMPLATE_ID_KEY
                                                      OR Parameter_Key__c =: SAMPLE_PACKET_CC_EMAIL_ADDRESS
                                                      ]) {
            
                if(config.Parameter_Key__c == SAMPLE_PACKET_EMAIL_RECEIVER_CONTACT_ID_KEY) {
                    SAMPLE_PACKET_EMAIL_RECEIVER_CONTACT_ID = config.Parameter_Value__c; 
                }
                else if(config.Parameter_Key__c == SAMPLE_PACKET_EMAIL_TEMPLATE_ID_KEY){
                    SAMPLE_PACKET_EMAIL_TEMPLATE_ID = config.Parameter_Value__c;
                }
                else {
                    if(config.Parameter_Value__c != null && config.Parameter_Value__c.trim().length() > 0)
                        listCCEmailAddresses.add(config.Parameter_Value__c);
                }
             
        }
        
     }  
     
}