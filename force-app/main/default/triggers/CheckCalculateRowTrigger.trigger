trigger CheckCalculateRowTrigger on Quote (before insert,before update) {
    Quote[] quotes=Trigger.new;
    Integer utcrCount=0;
    Integer countSet=0;
    for(Quote q:quotes){    
    QuoteHelper qHelper=new QuoteHelper();
    List<Quote> qList=qHelper.getQuotesByOpportunityID(q.OpportunityId);
    for(Quote qq:qList)
    {
    
    // In Case Of Insert
       if(qq.Use_to_Calculate_ROW_1__c=='Yes' && qq.ID!=q.ID)
        {
            utcrCount++;    
        }
        if(qq.Use_to_Calculate_ROW_2__c=='Yes' && qq.ID!=q.ID)
        {
            utcrCount++;    
        }
        if(qq.Use_to_Calculate_ROW_3__c=='Yes' && qq.ID!=q.ID)
        {
            utcrCount++;    
        }
        if(qq.Use_to_Calculate_ROW_4__c=='Yes' && qq.ID!=q.ID)
        {
            utcrCount++;    
        }
        if(qq.Use_to_Calculate_ROW_11__c=='Yes' && qq.ID!=q.ID)
        {
            utcrCount++;    
        }
        if(qq.Use_to_Calculate_ROW_12__c=='Yes' && qq.ID!=q.ID)
        {
            utcrCount++;    
        }
        if(qq.Use_to_Calculate_ROW_13__c=='Yes' && qq.ID!=q.ID)
        {
            utcrCount++;    
        }
        if(qq.Use_to_Calculate_ROW_14__c=='Yes' && qq.ID!=q.ID)
        {
            utcrCount++;    
        }
      }
    
   
        if(q.Use_to_Calculate_ROW_1__c=='Yes')
        {
            utcrCount++; 
            countSet++;  
            
        }
        if(q.Use_to_Calculate_ROW_2__c=='Yes')
        {
            utcrCount++; 
            countSet++; 
             
        }
        if(q.Use_to_Calculate_ROW_3__c=='Yes')
        {
            utcrCount++; 
            countSet++;
             
        }
        if(q.Use_to_Calculate_ROW_4__c=='Yes')
        {
            utcrCount++;  
            countSet++;
            
        }
        if(q.Use_to_Calculate_ROW_11__c=='Yes')
        {
            utcrCount++;  
            countSet++;
            
        }
        if(q.Use_to_Calculate_ROW_12__c=='Yes')
        {
            utcrCount++; 
            countSet++;   
            
        }
        if(q.Use_to_Calculate_ROW_13__c=='Yes')
        {
            utcrCount++;  
            countSet++;  
            
        }
        if(q.Use_to_Calculate_ROW_14__c=='Yes')
        {
            utcrCount++; 
            countSet++;  
             
        }
       
        // if(utcrCount>1){
        //     q.addError('Only one quote combination can be used to calculate ROW for each Opportunity');
        // }
        if(countSet==1)
        {
        q.Is_Used_To_Calculate_Row__c=true; 
        }
        else
        {
        q.Is_Used_To_Calculate_Row__c=false; 
        }
        
        
            
    }
}