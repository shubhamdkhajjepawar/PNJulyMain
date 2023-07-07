trigger CheckCalculateRowTriggerCustomGameQuotes on Custom_Game_Quote__c (before insert, before update) {
    Custom_Game_Quote__c[] quotes=Trigger.new;
    Integer utcrCount=0;
    Integer countSet=0;
    for(Custom_Game_Quote__c q:quotes){    
    CustomGameQuoteHelper qHelper=new CustomGameQuoteHelper();
    List<Custom_Game_Quote__c> qList=qHelper.getQuotesByOpportunityID(q.OpportunityId__c);
    for(Custom_Game_Quote__c qq:qList)
    {
    
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
        
       
        if(utcrCount>1){
            q.addError('Only one quote combination can be used to calculate ROW for each Opportunity');
        }
        if(countSet==1)
        {
        q.Is_Used_To_Calculate_ROW__c=true; 
        }
        else
        {
        q.Is_Used_To_Calculate_ROW__c=false; 
        }
        
        
            
}
}