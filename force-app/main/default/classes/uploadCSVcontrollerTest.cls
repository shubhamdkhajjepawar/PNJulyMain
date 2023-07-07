@isTest(seeAllData=false)
public class uploadCSVcontrollerTest{
    public static testMethod void testUpdateOppor(){
    test.startTest();
     Account acc=new Account(
            Name='Doom',
            Email__c='test@xcv.com'
        );
        insert acc;
        
        Contact c=new Contact(
         LastName='Marial',
         AccountId=acc.Id
   
        );
        insert c;
        Opportunity opp=new Opportunity(
         Name='Doomstone',
         CloseDate=Date.today(),
         Opportunity_Vendor__c='International',
         StageName='Draft',
         AccountId=acc.Id
         
        );
          
        insert opp; 
       
         OpportunityHelper obj1=new OpportunityHelper();
         Opportunity opp1=obj1.getByOpportunity(opp.Id);
         
        
   
    ApexPages.StandardController controller1= new  ApexPages.StandardController(opp);
    uploadCSVcontroller obj=new uploadCSVcontroller(controller1);
    string ss=opp1.Job_Number1__c;
    // Load the test Opprtunity from the static resource
      
      String s= 'Item No.,Changes,CSR,Quote,Job#,Product Name,Qty,Delivery Address,Customer Name,Customer Email,Customer Contact,Order Status,Date Order Received,Date Order Confirmed,Production Completed Date,Order EXW Date,ETD Port,ETA Port,ETA Customer,Actual arrival date,Customer expected delivery date,Delivery time,Booking No.,House Bill of Lading No.,Express Tracking NO.,Shipping Mode,Delivery Company,Shipping Agent,Buying UP(USD),Total Buying AMT (USD),Ocean CBM/Express KG,Actual Ocean Frt Cost,Actual Grd Shipping Cost,Actual Expedited Cost,Total Shipping Cost,Total Selling Price(USD),Margin,Remark'+'\r'+
      '1,1,HM,quoteNo,'+ss+',Q1212-025,1000,YEEP 4031 ,Ricky Lasley,rickylasley@myyeep.org,(316) 771-7456,Delivered,3/13/2001,7/13/2001,7/13/2001,1/14/13,1/18/13,1/18/13,1/18/13,1/15/13,1/15/13,1/15/13,,,7749424804,dfdf,dfdfd,,$0.52,$520.00,86.512,86.512,86.512,$550.06,$550.06,$1,236.71,$166.65,Remark'+'\r'+    
      '1,1,HM,quoteNo,'+ss+',Q1212-025,1000,YEEP 4031 ,Ricky Lasley,rickylasley@myyeep.org,(316) 771-7456,Delivered,3/13/2001,7/13/2001,7/13/2001,1/14/13,1/18/13,1/18/13,1/18/13,1/15/13,1/15/13,1/15/13,,,79949424804,Air Express,DHL,,$0.52,$520.00,86.512,86.512,86.512,$550.06,$550.06,$1,236.71,$166.65,Remark'+'\r'+
      '1,1,HM,quoteNo,'+ss+',Q1212-025,1000,YEEP 4031 ,Ricky Lasley,rickylasley@myyeep.org,(316) 771-7456,In-Transit(Ocean),3/13/2001,7/13/2001,7/13/2001,1/14/13,1/18/13,1/18/13,1/18/13,1/15/13,1/15/13,1/15/13,,,79949424804,ghjk,ghghg,,$0.52,$520.00,86.512,86.512,86.512,$550.06,$550.06,$1,236.71,$166.65,Remark'+'\r'+
      '1,1,HM,quoteNo,'+ss+',Q1212-025,1000,YEEP 4031 ,Ricky Lasley,rickylasley@myyeep.org,(316) 771-7456,Delivered,3/13/2001,7/13/2001,7/13/2001,1/14/13,1/18/13,1/18/13,1/18/13,1/15/13,1/15/13,1/15/13,,,7849424804,Ghjk,Ghjk,,$0.52,$520.00,86.512,86.512,86.512,$550.06,$550.06,$1,236.71,$166.65,Remark';

        // Get first test account
      
        Blob myBlob = Blob.valueof(s);
        obj.contentFile=myBlob;
        obj.UpdateOppor();
        
         String s3= 'Item No.,Changes,CSR,Quote,Job#,Product Name,Qty,Delivery Address,Customer Name,Customer Email,Customer Contact,Order Status,Date Order Received,Date Order Confirmed,Production Completed Date,Order EXW Date,ETD Port,ETA Port,ETA Customer,Actual arrival date,Customer expected delivery date,Delivery time,Booking No.,House Bill of Lading No.,Express Tracking NO.,Shipping Mode,Delivery Company,Shipping Agent,Buying UP(USD),Total Buying AMT (USD),Ocean CBM/Express KG,Actual Ocean Frt Cost,Actual Grd Shipping Cost,Actual Expedited Cost,Total Shipping Cost,Total Selling Price(USD),Margin,Remark'+'\r'+
      '1,1,HM,quoteNo,'+ss+',Q1212-025,1000,YEEP 4031 ,Ricky Lasley,rickylasley@myyeep.org,(316) 771-7456,Delivered,3/13/2001,7/13/2001,7/13/2001,1/14/13,1/18/13,1/18/13,1/18/13,1/15/13,1/15/13,1/15/13,,,7749424804,Air Express,DHL,,$0.52,$520.00,86.512,86.512,86.512,$550.06,$550.06,$1,236.71,$166.65,Remark'+'\r'+    
      '1,1,HM,quoteNo,'+ss+',Q1212-025,1000,YEEP 4031 ,Ricky Lasley,rickylasley@myyeep.org,(316) 771-7456,Delivered,3/13/2001,7/13/2001,7/13/2001,1/14/13,1/18/13,1/18/13,1/18/13,1/15/13,1/15/13,1/15/13,,,79949424804,Air Express,DHL,,$0.52,$520.00,86.512,86.512,86.512,$550.06,$550.06,$1,236.71,$166.65,Remark'+'\r'+
      '1,1,HM,quoteNo,'+ss+',Q1212-025,1000,YEEP 4031 ,Ricky Lasley,rickylasley@myyeep.org,(316) 771-7456,In-Transit(Ocean),3/13/2001,7/13/2001,7/13/2001,1/14/13,1/18/13,1/18/13,1/18/13,1/15/13,1/15/13,1/15/13,,,79949424804,ghjk,ghghg,,$0.52,$520.00,86.512,86.512,86.512,$550.06,$550.06,$1,236.71,$166.65,Remark'+'\r'+
      '1,1,HM,quoteNo,'+ss+',Q1212-025,1000,YEEP 4031 ,Ricky Lasley,rickylasley@myyeep.org,(316) 771-7456,Delivered,3/13/2001,7/13/2001,7/13/2001,1/14/13,1/18/13,1/18/13,1/18/13,1/15/13,1/15/13,1/15/13,,,7849424804,Ghjk,Ghjk,,$0.52,$520.00,86.512,86.512,86.512,$550.06,$550.06,$1,236.71,$166.65,Remark';

         Blob myBlob12 = Blob.valueof(s3);
        obj.contentFile=myBlob12;
        obj.UpdateOppor();
        
       // uploadCSVcontroller.parseCSVTest(myBlob.tostring(),false);
        //obj.MethodForCoverage();
        //obj.MethodForCoverage1();
        List<List<String>> lis=obj.getResults();
       
     String s1='From UPS,ConsolidatedMovementUniqueShipmentIdentifier,ShipmentInformationVoidIndicator,ShipToCompanyorName,ShipToAttention,ShipToAddress1,ShipToAddress2,ShipToAddress3,ShipToCountryTerritory,ShipToPostalCode,ShipToCityorTown,    ShipToStateProvinceCounty,ShipFromCompanyorName,PackageTrackingNumber,ShipmentInformationBillingOption,PackageReference2,PackageReference3,PackageReference4,PackageReference5,PackageReference1,ShipmentInformationCODOption,ShipmentInformationCODAmount,ShipmentInformationCODCashOnly,,,'+'\r'+
         '1,7780749086,N,Rugged Product Manufacturing,Josh Noble,1341 N. 325 E,11,11,United States,84041,Layton,UT,PrintNinja,1ZX6185X0341258885,Bill Shipper Freight,'+ss+',11,11,11,TD,N,11,N,11,11'+'\r';
       Blob myBlob1 = Blob.valueof(s1);
        obj.contentFileUPS=myBlob1;
        obj.UpdateOpporByUPS();
        obj.SendEmail('test@xcv.com','test1','test@xxcb.com','testst','sdsfds','sddd');
        // obj.SendEmail2('test@xcv.com','test1','test@xxcb.com','testst','sdsfds','sddd');
         // obj.SendEmail3('test@xcv.com','test1','test@xxcb.com','testst','sdsfds','sddd');
        test.stopTest();
    }
    
   
    
    
}