global class ConvertLeadAction {

	public static LeadStatus convertedStatus { get {
    if(convertedStatus == null){
      convertedStatus = [
        SELECT Id, MasterLabel
        FROM LeadStatus
        WHERE IsConverted = true
        LIMIT 1
      ];
    }
    return convertedStatus;
  } set; }

  @InvocableMethod(label='Convert Leads')
  global static List<Response> execute(List<Request> requests) {
		List<Database.LeadConvert> lcs = new List<Database.LeadConvert>();
    for (Request req : requests) {
			Database.LeadConvert lc = new Database.LeadConvert();
	    lc.setLeadId(req.leadId);

			if(!String.isEmpty(req.convertedStatus)){
				lc.setConvertedStatus(req.convertedStatus);
			} else {
				lc.setConvertedStatus(convertedStatus.MasterLabel);
			}

	    if (!String.isEmpty(req.accountId)) {
        lc.setAccountId(req.accountId);
	    }

	    if (!String.isEmpty(req.contactId)) {
	      lc.setContactId(req.contactId);
	    }

	    if (req.overWriteLeadSource != null && req.overWriteLeadSource) {
	      lc.setOverwriteLeadSource(req.overWriteLeadSource);
	    }

	    if (req.createOpportunity != null && !req.createOpportunity) {
	      lc.setDoNotCreateOpportunity(!req.createOpportunity);
	    }

	    if (!String.isEmpty(req.opportunityName)) {
	      lc.setOpportunityName(req.opportunityName);
	    }

	    if (!String.isEmpty(req.ownerId)) {
	      lc.setOwnerId(req.ownerId);
	    }

	    if (req.sendEmailToOwner != null && req.sendEmailToOwner) {
	      lc.setSendNotificationEmail(req.sendEmailToOwner);
	    }
			lcs.add(lc);
    }

		List<Response> responses = new List<Response>();
		for(Database.LeadConvertResult lcr :Database.convertLead(lcs, false)){
			if (lcr.isSuccess()) {
	      Response res = new Response();
	      res.accountId = lcr.getAccountId();
	      res.contactId = lcr.getContactId();
	      res.opportunityId = lcr.getOpportunityId();
	      responses.add(res);
	    } else {
	      throw new ConvertLeadActionException(lcr.getErrors()[0].getMessage());
	    }
		}

    return responses;
  }

	global static Response execute(Request req){
		List<Response> responses = execute(new List<Request>{req});
		return responses.get(0);
	}

  global class Request {
    @InvocableVariable(required=true)
    global ID leadId;

    @InvocableVariable
    global String convertedStatus;

    @InvocableVariable
    global ID accountId;

    @InvocableVariable
    global ID contactId;

    @InvocableVariable
    global Boolean overWriteLeadSource;

    @InvocableVariable
    global Boolean createOpportunity;

    @InvocableVariable
    global String opportunityName;

    @InvocableVariable
    global ID ownerId;

    @InvocableVariable
    global Boolean sendEmailToOwner;
  }

  global class Response {
    @InvocableVariable
    global ID accountId;

    @InvocableVariable
    global ID contactId;

    @InvocableVariable
    global ID opportunityId;
  }

  class ConvertLeadActionException extends Exception {}
}