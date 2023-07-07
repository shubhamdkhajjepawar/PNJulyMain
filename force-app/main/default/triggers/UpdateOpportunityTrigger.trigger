trigger UpdateOpportunityTrigger on Quote (after insert,after update) {
    Quote[] quotes=Trigger.new;
    OpportunityHelper op=new OpportunityHelper();
    for(Quote q:quotes){    
        Opportunity opp=op.getByOpportunity(q.OpportunityId);
        if(q.Use_to_Calculate_ROW_1__c=='Yes')
        {
             opp.New_ROW__c=q.International_Grand_Total_1__c;
             opp.PRN_Remark__c=q.Remark_1__c;
             
        }
        if(q.Use_to_Calculate_ROW_2__c=='Yes')
        {
             opp.New_ROW__c=q.International_Grand_Total_2__c;
             opp.PRN_Remark__c=q.Remark_2__c;
             
        }
        if(q.Use_to_Calculate_ROW_3__c=='Yes')
        {
             opp.New_ROW__c=q.International_Grand_Total_3__c;
             opp.PRN_Remark__c=q.Remark_3__c;
             
        }
        if(q.Use_to_Calculate_ROW_4__c=='Yes')
        {
             opp.New_ROW__c=q.International_Grand_Total_4__c;
             opp.PRN_Remark__c=q.Remark_4__c;
             
        }
        if(q.Use_to_Calculate_ROW_11__c=='Yes')
        {
             opp.New_ROW__c=q.Domestic_Grand_Total_11__c;
             
        }
        if(q.Use_to_Calculate_ROW_12__c=='Yes')
        {
            opp.New_ROW__c=q.Domestic_Grand_Total_12__c;
            
        }
        if(q.Use_to_Calculate_ROW_13__c=='Yes')
        {
            opp.New_ROW__c=q.Domestic_Grand_Total_13__c;
            
        }
        if(q.Use_to_Calculate_ROW_14__c=='Yes')
        {
            opp.New_ROW__c=q.Domestic_Grand_Total_14__c;
            
        }
        update opp;
            
    }
}