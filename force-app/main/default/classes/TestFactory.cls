@isTest
public with sharing class TestFactory {
	
	public static Account createAccount(String name){
		Account acc = new Account();
		acc.Name = name;
		return acc;
	}

	public static Contact createContact(String name, Account acc){
		Contact con = new Contact();
		con.AccountId = acc.Id;
		con.LastName = name;
		return con;
	}

	public static Opportunity createOpportunity(String product, Account acc){
		Opportunity opp = new Opportunity();
		opp.Name = product;
		opp.Product__c = product;
		opp.StageName = 'Closed Won';
		opp.CloseDate = System.today();
		opp.AccountId = acc.Id;
		return opp;
	}

	public enum Row { R1, R2, R3, R4, R11, R12, R13, R14 }

	public static Quote createQuote(Opportunity opp, Row r){
		Quote quote = new Quote();
		quote.Name = opp.Product__c;
		quote.OpportunityId = opp.Id;
		quote.Quoted_Created__c = System.today();
		quote.Sent_to_Customer__c = System.today();

		if(r == null) return quote;

		List<Row> rows = new List<Row>();
		rows.add(Row.R1);
		rows.add(Row.R2);
		rows.add(Row.R3);
		rows.add(Row.R4);
		rows.add(Row.R11);
		rows.add(Row.R12);
		rows.add(Row.R13);
		rows.add(Row.R14);

		for(Row row :rows){
			String istr = row.name().removeStart('R');
			Integer inum = Integer.valueOf(istr);
			List<String> filler = new List<String>{istr};

			quote.put(String.format(
				'Use_to_Calculate_ROW_{0}__c', filler
			), (row == r ? 'Yes' : 'No'));
			quote.put(String.format('Total_Quantity_{0}__c', filler), inum);
			quote.put(String.format('Additional_charge_s_{0}__c', filler), inum);

			if( inum >= 1 && inum <= 4){
				quote.Quote_Source__c = 'International';
				quote.put(String.format('Product_Purchase_Cost{0}__c', filler), inum);
				quote.put(String.format('Ocean_Freight_{0}__c', filler), inum);
				quote.put(String.format('Grd_Freight_{0}__c', filler), inum);
				quote.put(String.format('Proofing_Price_{0}__c', filler), inum);
				quote.put(String.format('Expedited_Freight_{0}__c', filler), inum);
			} else if( inum >= 11 && inum <= 14){
				quote.Quote_Source__c = 'Domestic';
				quote.put(String.format('Dom_Purch_Price_{0}__c',filler), inum);
				quote.put(String.format('Dom_Vendor_s_Freight_Charge_{0}__c', filler), inum);
			}
		}		
		return quote;
	}

	public static Quote createQuote(Opportunity opp){
		return createQuote(opp, null);
	}

}