@isTest
public with sharing class UpdatePriceTrigger_TEST {
	
	@testSetup static void setup(){
		Account acc = TestFactory.createAccount('Account');
		insert acc;

		Contact con = TestFactory.createContact('Contact', acc);
		insert con;
		
		Opportunity opp = TestFactory.createOpportunity('Comic Books', acc);
		opp.Contact__c = con.Id;
		opp.StageName = 'Closed Won';
		opp.Production_Status__c = 'Waiting for Artwork';
		insert opp;

		Quote quote = TestFactory.createQuote(opp);
		insert quote;
	}

	@isTest static void rowR1(){
		executeRow(TestFactory.Row.R1);
	}

	@isTest static void rowR2(){
		executeRow(TestFactory.Row.R2);
	}

	@isTest static void rowR3(){
		executeRow(TestFactory.Row.R3);
	}

	@isTest static void rowR4(){
		executeRow(TestFactory.Row.R4);
	}

	@isTest static void rowR11(){
		executeRow(TestFactory.Row.R11);
	}

	@isTest static void rowR12(){
		executeRow(TestFactory.Row.R12);
	}

	@isTest static void rowR13(){
		executeRow(TestFactory.Row.R13);
	}

	@isTest static void rowR14(){
		executeRow(TestFactory.Row.R14);
	}

	private static void executeRow(TestFactory.Row row){
		// Retrieve opp and quote
		Opportunity opp = getOpp();
		Quote quo = getQuote();

		// Update quote with specific row info
		Quote quote = TestFactory.createQuote(opp, row);
		quote.Id = quo.Id;
		update quote;

		Test.startTest();
		update opp;
		Test.stopTest();

		// Retrieve opp and quote for assertiions
		opp = getOpp();
		quo = getQuote();

		String istr = row.name().removeStart('R');
		Integer inum = Integer.valueOf(istr);
		List<String> filler = new List<String>{istr};

		System.assertEquals('Yes', quo.get(String.format('Use_to_Calculate_ROW_{0}__c', filler)));
		
		if( inum >= 1 && inum <= 4){
			System.assertEquals('International', opp.Opportunity_Vendor__c);
			System.assertEquals(
				quo.get(String.format('Total_Quantity_{0}__c', filler)),
				opp.Quantity_1__c
			);
			System.assertEquals(
				quo.get(String.format('Product_i_Price{0}__c', filler)),
				opp.Quoted_Product_Price__c
			);
			System.assertEquals(
				quo.get(String.format('International_Grand_Total_{0}__c', filler)),
				opp.Total_Selling_Int__c
			);
			System.assertEquals(
				quo.get(String.format('Product_i_Price{0}__c', filler)),
				opp.Quoted_Product_Price__c
			);
			System.assertEquals(
				quo.get(String.format('Ocean_Freight_Price{0}__c', filler)),
				opp.Quoted_Ocean_Freight__c
			);
			System.assertEquals(
				quo.get(String.format('Ground_Freight_Price{0}__c', filler)),
				opp.Quoted_Ground_Freight__c
			);
			System.assertEquals(
				quo.get(String.format('Add_On_Price_{0}__c', filler)),
				opp.Additional_Charges_s_IQ__c
			);
			System.assertEquals(
				quo.get(String.format('Proofing_Price_{0}__c', filler)),
				opp.Proofing_Price__c
			);
			System.assertEquals(
				quo.get(String.format('Expedited_Freight_Price{0}__c', filler)),
				opp.Quoted_Expedited_Freight__c
			);
		} else if( inum >= 11 && inum <= 14){
			System.assertEquals('Domestic', opp.Opportunity_Vendor__c);
			System.assertEquals(
				quo.get(String.format('Total_Quantity_{0}__c', filler)),
				opp.Quantity_2__c
			);
			System.assertEquals(
				quo.get(String.format('Dom_Purch_Price_{0}__c', filler)), 
				opp.Actual_Pur_Cost_D__c
			);
			System.assertEquals(
				quo.get(String.format('Domestic_Freight_Charge_{0}__c', filler)), 
				opp.Actual_Ground_Shipping_Cost_D__c
			);
			System.assertEquals(
				quo.get(String.format('Additional_charge_s_{0}__c', filler)), 
				opp.Additional_Charges_s_AD__c
			);
			System.assertEquals(
				quo.get(String.format('Domestic_Grand_Total_{0}__c', filler)), 
				opp.Total_Selling_D__c
			);
		}
	}

	private static Opportunity getOpp(){
		return [
			SELECT Id, Product__c, Quantity_1__c, Total_Selling_Int__c, Quoted_Product_Price__c, Quoted_Ocean_Freight__c, 
				Quoted_Ground_Freight__c, Quoted_Tax__c, Additional_Charges_s_IQ__c, Proofing_Price__c, Quoted_Expedited_Freight__c ,
				Opportunity_Vendor__c, Quantity_2__c, Actual_Pur_Cost_D__c, Tax_D__c, Actual_Ground_Shipping_Cost_D__c, 
				Additional_Charges_s_AD__c, Total_Selling_D__c
			FROM Opportunity
			LIMIT 1
		];
	}

	private static Quote getQuote(){
		return [
			SELECT Use_to_Calculate_ROW_1__c, Use_to_Calculate_ROW_2__c, Use_to_Calculate_ROW_3__c, Use_to_Calculate_ROW_4__c, 
				Use_to_Calculate_ROW_11__c, Use_to_Calculate_ROW_12__c, Use_to_Calculate_ROW_13__c, Use_to_Calculate_ROW_14__c, 
				Total_Quantity_1__c, International_Grand_Total_1__c, Product_i_Price1__c, Ocean_Freight_Price1__c, 
				Ground_Freight_Price1__c, Tax, Add_On_Price_1__c, Proofing_Price_1__c, Expedited_Freight_Price1__c, 
				Total_Quantity_2__c, International_Grand_Total_2__c, Product_i_Price2__c, Ocean_Freight_Price2__c, 
				Ground_Freight_Price2__c, Tax_2__c, Add_On_Price_2__c, Proofing_Price_2__c, Expedited_Freight_Price2__c, 
				Total_Quantity_3__c, International_Grand_Total_3__c, Product_i_Price3__c, Ocean_Freight_Price3__c, 
				Ground_Freight_Price3__c, Tax_3__c, Add_On_Price_3__c, Proofing_Price_3__c, Expedited_Freight_Price3__c, 
				Total_Quantity_4__c, International_Grand_Total_4__c, Product_i_Price4__c, Ocean_Freight_Price4__c, 
				Ground_Freight_Price4__c, Tax_4__c, Add_On_Price_4__c, Proofing_Price_4__c, Expedited_Freight_Price4__c, 
				Total_Quantity_11__c, Dom_Purch_Price_11__c, Tax_11__c, Domestic_Freight_Charge_11__c, Additional_charge_s_11__c, 
				Domestic_Grand_Total_11__c, Total_Quantity_12__c, Dom_Purch_Price_12__c, Tax_12__c, Domestic_Freight_Charge_12__c, 
				Additional_charge_s_12__c, Domestic_Grand_Total_12__c, Total_Quantity_13__c, Dom_Purch_Price_13__c, Tax_13__c, 
				Domestic_Freight_Charge_13__c, Additional_charge_s_13__c, Domestic_Grand_Total_13__c, Total_Quantity_14__c, 
				Dom_Purch_Price_14__c, Tax_14__c, Domestic_Freight_Charge_14__c, Additional_charge_s_14__c, Domestic_Grand_Total_14__c,
				OpportunityId, Id
			FROM Quote
			LIMIT 1
		];
	}

}