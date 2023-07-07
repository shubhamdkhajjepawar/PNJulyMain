trigger ProductionStatusResetter on Opportunity (before update) {

    for (Opportunity o : Trigger.new){
            //Set Production Status Clone field to act as a type of history field for Production Status
        if (o.Production_Status__c == 'Hardcopy Proof Approved'){
            o.Production_Status_Clone__c = 'Hardcopy Proof Approved';
        }
        if (o.Production_Status__c == 'Approved for production'){
            o.Production_Status_Clone__c = 'Approved for production';
        }
        if (o.Production_Status__c == 'In-Production'){
            o.Production_Status_Clone__c = 'In-Production';
        }
        if (o.Production_Status__c == 'Production Hold'){
            o.Production_Status_Clone__c = 'Production Hold';
        }
        if (o.Production_Status__c == 'Production Resumed'){
            o.Production_Status_Clone__c = 'Production Resumed';
        }
        if (o.Production_Status__c == 'Off-Press'){
            o.Production_Status_Clone__c = 'Off-Press';
        }
        if (o.Production_Status__c == 'In-Transit'){
            o.Production_Status_Clone__c = 'In-Transit';
        }
            //When Production Status is advanced past hardcopy proof approved, always set the status back to the Clone when artwork is uploaded
        if (o.Production_Status__c == 'Ready for Proofing' && o.Production_Status_Clone__c == 'Hardcopy Proof Approved' && o.Approval_Date__c != null ){
            o.Production_Status__c = 'Hardcopy Proof Approved';
        }
        if (o.Production_Status__c == 'Ready for Proofing' && o.Production_Status_Clone__c == 'Approved for production' && o.Approval_Date__c != null ){
            o.Production_Status__c = 'Approved for production';
        }
        if (o.Production_Status__c == 'Ready for Proofing' && o.Production_Status_Clone__c == 'In-Production' && o.Approval_Date__c != null ){
            o.Production_Status__c = 'In-Production';
        }
        if (o.Production_Status__c == 'Ready for Proofing' && o.Production_Status_Clone__c == 'Production Hold' && o.Approval_Date__c != null ){
            o.Production_Status__c = 'Production Hold';
        }
        if (o.Production_Status__c == 'Ready for Proofing' && o.Production_Status_Clone__c == 'Production Resumed' && o.Approval_Date__c != null ){
            o.Production_Status__c = 'Production Resumed';
        }
        if (o.Production_Status__c == 'Ready for Proofing' && o.Production_Status_Clone__c == 'Off-Press' && o.Approval_Date__c != null ){
            o.Production_Status__c = 'Off-Press';
        }
        if (o.Production_Status__c == 'Ready for Proofing' && o.Production_Status_Clone__c == 'In-Transit' && o.Approval_Date__c != null ){
            o.Production_Status__c = 'In-Transit';
        }
    }
}