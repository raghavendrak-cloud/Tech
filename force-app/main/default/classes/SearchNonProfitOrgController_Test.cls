/**
* Test Class for Search non profit.
* @author         Raghavendra
* @version        1.0
* @created        2-07-2021
* @systemLayer    SearchNonProfitOrgController Class
**/

@isTest
private class SearchNonProfitOrgController_Test {
    
    @isTest static void testSearchNonprofitOrg(){
        Test.setMock(HttpCalloutMock.class, new NonProfitMockResponseGenrator());
        try{
            
            String searchKey = 'red';
            Object response = SearchNonProfitOrgController.searchNonprofitOrg(searchKey);
            System.debug(response);
            String expectedValue = '{"example":"test"}';
            System.assertEquals(response,(Map<String, Object>) JSON.deserializeUntyped(expectedValue));
            
        }
        
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());  
        }
        
        
        
        
        
    } 
    
    
    
    
    
    
}
