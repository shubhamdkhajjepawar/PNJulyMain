trigger CalcLeadAssignmentRule on Lead (after insert) {
    List<Lead> ls = new List<Lead>();
    
    for(Lead l:Trigger.new){
        if ((l.LeadSource == 'PRN Site Blind Quote') || (l.LeadSource == 'PRN Site Freight Quote') || (l.LeadSource == 'PRN Card Game Print Quote Request') || (l.LeadSource == 'PRN Board Game Print Quote Request') || (l.LeadSource == 'PRN Card Game Blind Order') || (l.LeadSource == 'PRN Card Game Blind Quote') || (l.LeadSource == 'PRN Board Game Blind Order') || (l.LeadSource == 'PRN Board Game Blind Quote') || (l.LeadSource == 'PRN Custom Card Game Quote Form') || (l.LeadSource == 'PRN Custom Board Game Quote Form') || (l.LeadSource == 'PRN Blind Order')){
            ls.add(new Lead(id = l.id));    
        }
    }
    Database.DMLOptions dmo = new Database.DMLOptions();
    dmo.assignmentRuleHeader.useDefaultRule= true;
    Database.update(ls, dmo);
}