/**
 * @description       : 
 * @author            : Ashwani Soni
 * @group             : 
 * @last modified on  : 07-19-2021
 * @last modified by  : Ashwani Soni
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   06-27-2021   Ashwani Soni   Initial Version
**/
public with sharing class CMT_AWSMockHTTP implements HttpCalloutMock 
{
    public static Integer state = 1;
    public HTTPResponse respond(HTTPRequest req)
    {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"example":"test"}');
        if(state == 1)
        {
            res.setStatusCode(200);
        }
        else if(state == 2)
        {
            res.setStatusCode(500);
        }
        return res;
    }
}