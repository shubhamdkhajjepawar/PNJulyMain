trigger CheckCalRowTrigger on Quote (before insert,before update) {
    Quote[] quotes=Trigger.new;
    Integer utcrCount=0;
    for(Quote q:quotes){    
        if(q.Use_to_Calculate_ROW_1__c=='Yes')
        {
            utcrCount++;    
        }
        if(q.Use_to_Calculate_ROW_2__c=='Yes')
        {
            utcrCount++;    
        }
        if(q.Use_to_Calculate_ROW_3__c=='Yes')
        {
            utcrCount++;    
        }
        if(q.Use_to_Calculate_ROW_4__c=='Yes')
        {
            utcrCount++;    
        }
        if(q.Use_to_Calculate_ROW_11__c=='Yes')
        {
            utcrCount++;    
        }
        if(q.Use_to_Calculate_ROW_12__c=='Yes')
        {
            utcrCount++;    
        }
        if(q.Use_to_Calculate_ROW_13__c=='Yes')
        {
            utcrCount++;    
        }
        if(q.Use_to_Calculate_ROW_14__c=='Yes')
        {
            utcrCount++;    
        }
        if(utcrCount>1){
            q.addError('Only one quote combination can be used to calculate ROW');
        }
            
    }
}