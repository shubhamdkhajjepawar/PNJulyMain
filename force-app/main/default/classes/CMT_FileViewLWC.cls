/**
 * @description       : 
 * @author            : Ashwani Soni
 * @group             : 
 * @last modified on  : 06-26-2021
 * @last modified by  : Ashwani Soni
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   06-26-2021   Ashwani Soni   Initial Version
**/
public with sharing class CMT_FileViewLWC 
{
    @auraenabled
    public static String generateFilePreview(String key)
    {
        return CMT_AWSUtil.getSignedURL(key);
    }       
}