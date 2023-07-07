@isTest
public class ConvertLeadAction_TEST {

	@testSetup static void setup(){
		Lead lead = new Lead();
		lead.LastName = 'Lead';
		lead.Company = 'Account';
		insert lead;
	}

	@isTest static void convertLeads_default(){
		Lead lead = [SELECT Id FROM Lead LIMIT 1];

		ConvertLeadAction.Request req = new ConvertLeadAction.Request();
		req.leadId = lead.Id;
		req.opportunityName = 'Opportunity';

		Test.startTest();
		ConvertLeadAction.Response res = ConvertLeadAction.execute(req);
		Test.stopTest();

		System.assert(!String.isEmpty(res.accountId));
	}

	@isTest static void convertLeads_custom(){
		Lead lead = [SELECT Id FROM Lead LIMIT 1];

		Account acc = new Account();
		acc.Name = 'Account';
		insert acc;

		Contact con = new Contact();
		con.LastName = 'Contact';
		con.AccountId = acc.id;
		insert con;

		ConvertLeadAction.Request req = new ConvertLeadAction.Request();
		req.leadId = lead.Id;
		req.accountId = acc.id;
		req.contactId = con.Id;
		req.convertedStatus = ConvertLeadAction.convertedStatus.MasterLabel;
		req.overWriteLeadSource = true;
		req.createOpportunity = false;
		req.ownerId = UserInfo.getUserId();
		req.sendEmailToOwner = true;

		Test.startTest();
		ConvertLeadAction.Response res = ConvertLeadAction.execute(req);
		Test.stopTest();

		System.assertEquals(res.accountId, acc.Id);
		System.assertEquals(res.contactId, con.Id);
		System.assert(String.isEmpty(res.opportunityId));
	}

	@isTest static void convertLeads_error(){
		Lead lead = [SELECT Id FROM Lead LIMIT 1];

		ConvertLeadAction.Request req = new ConvertLeadAction.Request();
		req.leadId = lead.Id;
		req.convertedStatus = 'Invalid Status';

		Test.startTest();
		try {
			ConvertLeadAction.execute(req);
			System.assert(false, 'Should have thrown an exception');
		} catch(ConvertLeadAction.ConvertLeadActionException ex){
			System.assert(true);
		}

		Test.stopTest();
	}

}