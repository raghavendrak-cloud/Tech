/**
*  Class for Creating Bonus Payouts.
* @author         Raghavendra
* @version        1.0
* @created        2-07-2021
* @systemLayer    SearchNonProfit Class
**/


public with sharing class SearchNonProfitOrgController  {
    
    public static final string Subscription_Key = '407813e975774d7f92a2252d3509b977'; // USE label or custom setting to store auth key
    @AuraEnabled
    public static Object searchNonprofitOrg(String searchKey){
        try {
            
            Map<String,String> reqbody = new Map<String, String>();
            reqbody.put('search_terms', searchKey);
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://apidata.guidestar.org/essentials/v2'); //TODO: Use Custom setting 
            request.setMethod('POST');
            request.setHeader('Subscription-Key', Subscription_Key);
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setBody(JSON.serialize(reqbody));
            HttpResponse response = http.send(request);
            System.debug('Response :: '+response.getBody());
           
            return (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
