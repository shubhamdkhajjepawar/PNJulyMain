public with sharing class OpportunityHelper{
 static String theQuery;     
     public OpportunityHelper(){
        Map<String, Schema.SObjectField> fldObjMap = schema.SObjectType.Opportunity.fields.getMap();
        List<Schema.SObjectField> fldObjMapValues = fldObjMap.values();
        theQuery = 'SELECT ';
        for(Schema.SObjectField s : fldObjMapValues)
        {
           //String theLabel = s.getDescribe().getLabel(); 
           String theName = s.getDescribe().getName();
           //String theType = s.getDescribe().getType(); 
        
           // Continue building your dynamic query string
           theQuery += theName + ',';
        }
        // Trim last comma
        theQuery = theQuery.subString(0, theQuery.length() - 1);
     }
     
     public Opportunity getByOpportunity(ID oppId){
        //theQuery+=' from Opportunity where Id=\''+oppId+'\'';
//        Opportunity oppor=Database.query(theQuery);
         Opportunity  oppor= [SELECT Account.Email__c,Account.Name,Owner.Email,Owner.Name,CreatedById,Express_KG__c,Shipping_Status_Standard__c,IsDeleted,CloseDate,CreatedDate,OwnerId,Product_Type__c,Delivery_Time_E__c,Quantity_1__c,Customer_Expected_Delivery_Date_E__c,Actual_Pur_Cost_D__c,ETD_Port__c,LastModifiedById,Refund__c,Explanation__c,Total_Shipping_I__c,Shipping_Status_Expedited__c,Actual_Arrival_Date_E__c,Actual_Per_Cost_I__c,Ocean_CBM__c,Additional_Charges_s_IQ__c,Tax_I__c,Product__c,EXW_Date__c,Actual_Ocean_Shipping_Cost_I__c,Job_Number1__c,Pipeline_Rev_Value__c,Actual_Ground_Shipping_Cost_D__c,Actual_Expedited_Shipping_Cost__c,Quoted_Product_Price__c,StageName,Job_Note__c,Total_Selling_Int__c,Opportunity_Vendor__c,Delivery_Time__c,Fiscal,Transaction_ID_2__c,Transaction_ID_R__c,SyncedQuoteId,Reason_if_Lost__c,Quoted_Ground_Freight__c,Markup_D__c,Quantity_2__c,LastActivityDate,Amount,Opportunity_Source__c,Production_Status__c,Description,Customer_Expected_Delivery_Date__c,Target_Print_Date__c,Target_Delivery_Date__c,X1Profit_Margin_D__c,Amount_1__c,Quoted_Ocean_Freight__c,Tracking_No_E__c,Tracking_No__c,X3Quantity_D__c,X3Expected_Revenue_D__c,Customer_Feedback__c,Quoted_Actual_Expedited_Freight__c,Total_Selling_D__c,Quoted_Actual_Ground_Freight__c,X4Profit_Margin_D__c,IsClosed,Actual_Arrival_Date__c,ExpectedRevenue,NextStep,HasOpportunityLineItem,X4QuantityD__c,X5QuantityD__c,Profit_Margin__c,Transaction_ID_1__c,LastModifiedDate,Id,X1Quantity_D__c,Name,ETA_Customer__c,Quoted_Expedited_Freight__c,Approved_for_Production__c,Actual_Ground_Shipping_Cost_I__c,AccountId,Sample_Usage__c,Total_Shipping_D__c,Contact__c,ForecastCategory,Additional_Charge_s_IA__c,Actual_Ocean_Shipping_Cost__c,ForecastCategoryName,Quoted_Tax__c,X2Quantity_D__c,Tax_D__c,Amount_2__c,total_Selling_I_and_D__c,Margin_I__c,ETA_Customer_E__c,Order_Completion_Date__c,IsWon,X4Expected_Revenue_D__c,ETD_Port_China__c,IsPrivate,EXW_Date_E__c,New_ROW__c, PRN_additionalinfo__c/*,PRN_basicembossdeboss__c,PRN_basicfoilstamping__c*/,PRN_bindingtype__c,PRN_corners__c,PRN_coverpapercoating__c,PRN_coverpaperfinishstyle__c,PRN_coverpaperfinishtype__c,PRN_coverpaperweight__c,PRN_dustjacket__c,PRN_dustjacketfinishstyle__c,PRN_endsheets__c,PRN_height__c,PRN_insidepagecount__c,PRN_insidepapercoating__c,PRN_insidepaperweight__c,PRN_printingcolor__c,PRN_printoninsidecoversendsheets__c,PRN_proofing__c/*,PRN_spotuv__c*/,PRN_width__c,newshipping_liftgate__c,PRN_Remark__c from Opportunity where Id=:oppId limit 1];
        return oppor;
     }
      public Opportunity getByJobNumber(string job_number){
     //,Shipping_Company__c,Shipping_Company_E__c
      Opportunity  oppor= [SELECT Account.Email__c,Account.Name,Owner.Email,Owner.Name,CreatedById,Express_KG__c,Shipping_Status_Standard__c,IsDeleted,CloseDate,CreatedDate,OwnerId,Product_Type__c,Delivery_Time_E__c,Quantity_1__c,Customer_Expected_Delivery_Date_E__c,Actual_Pur_Cost_D__c,ETD_Port__c,LastModifiedById,Refund__c,Explanation__c,Total_Shipping_I__c,Shipping_Status_Expedited__c,Actual_Arrival_Date_E__c,Actual_Per_Cost_I__c,Ocean_CBM__c,Additional_Charges_s_IQ__c,Tax_I__c,Product__c,EXW_Date__c,Actual_Ocean_Shipping_Cost_I__c,Job_Number1__c,Pipeline_Rev_Value__c,Actual_Ground_Shipping_Cost_D__c,Actual_Expedited_Shipping_Cost__c,Quoted_Product_Price__c,StageName,Job_Note__c,Total_Selling_Int__c,Opportunity_Vendor__c,Delivery_Time__c,Fiscal,Transaction_ID_2__c,Transaction_ID_R__c,SyncedQuoteId,Reason_if_Lost__c,Quoted_Ground_Freight__c,Markup_D__c,Quantity_2__c,LastActivityDate,Amount,Opportunity_Source__c,Production_Status__c,Description,Customer_Expected_Delivery_Date__c,Target_Print_Date__c,Target_Delivery_Date__c,X1Profit_Margin_D__c,Amount_1__c,Quoted_Ocean_Freight__c,Tracking_No_E__c,Tracking_No__c,X3Quantity_D__c,X3Expected_Revenue_D__c,Customer_Feedback__c,Quoted_Actual_Expedited_Freight__c,Total_Selling_D__c,Quoted_Actual_Ground_Freight__c,X4Profit_Margin_D__c,IsClosed,Actual_Arrival_Date__c,ExpectedRevenue,NextStep,HasOpportunityLineItem,X4QuantityD__c,X5QuantityD__c,Profit_Margin__c,Transaction_ID_1__c,LastModifiedDate,Id,X1Quantity_D__c,Name,ETA_Customer__c,Quoted_Expedited_Freight__c,Approved_for_Production__c,Actual_Ground_Shipping_Cost_I__c,AccountId,Sample_Usage__c,Total_Shipping_D__c,Contact__c,ForecastCategory,Additional_Charge_s_IA__c,Actual_Ocean_Shipping_Cost__c,ForecastCategoryName,Quoted_Tax__c,X2Quantity_D__c,Tax_D__c,Amount_2__c,total_Selling_I_and_D__c,Margin_I__c,ETA_Customer_E__c,Order_Completion_Date__c,IsWon,X4Expected_Revenue_D__c,ETD_Port_China__c,IsPrivate,EXW_Date_E__c,New_ROW__c from Opportunity where Job_Number1__c=:job_number limit 1];
      
        return oppor;
     }
     
    
    /*  public void setTaskByOppStage(ID oppId,string opp_stage){
       theQuery+=' from Opportunity where Id=\''+oppId+'\'';
        Opportunity oppor=Database.query(theQuery);
        if(opp_stage=='Draft')
        {
        Task newTask = new Task(Description = 'Finish Quoting for the Opportunity',
                                        Priority = 'Normal', 
                                       Status = 'In Progress', 
                                        Subject = 'Finish Quoting for the Opportunity', 
                                        IsReminderSet = false, 
                                        ReminderDateTime = datetime.now(), 
                                        OwnerId=oppor.OwnerId,
                                        WhatId=oppor.AccountId 
                                        );             
            insert newTask;
            }
            if(opp_stage=='Quoted by China')
            {

             Task newTask = new Task(Description = 'Finish Quoting for the Opportunity',
                                        Priority = 'Normal', 
                                       Status = 'In Progress', 
                                        Subject = 'Finish Quoting for the Opportunity', 
                                        IsReminderSet = false, 
                                        ReminderDateTime = datetime.now(), 
                                        OwnerId='00590000000pxx1',
                                        WhatId=oppor.AccountId 
                                        );             
            insert newTask;
            
            }
            if(opp_stage=='Proposal/ Custom Quote')
            {

             Task newTask = new Task(
                                        Priority = 'Normal', 
                                       Status = 'In Progress', 
                                        Subject = 'Follow up the task the Opportunity', 
                                        IsReminderSet = true, 
                                        ReminderDateTime = datetime.now(),
                                        ActivityDate=date.today().addDays(5), 
                                        OwnerId=oppor.OwnerId,
                                        WhatId=oppor.AccountId 
                                        );             
            insert newTask;
            
            }
            if(opp_stage=='Proposal/ Online Blind Quote')
            {

             Task newTask = new Task(
                                        Priority = 'Normal', 
                                       Status = 'In Progress', 
                                        Subject = 'Follow up the task the Opportunity', 
                                        IsReminderSet = true, 
                                        ReminderDateTime = datetime.now(),
                                        ActivityDate=date.today().addDays(5), 
                                        OwnerId=oppor.OwnerId,
                                        WhatId=oppor.AccountId 
                                        );             
            insert newTask;
            
            }
           
            
  
     }*/
   
}