@isTest
private class OpportunityTriggerHandlerTest {
    
    @testSetup static void testDataSetup(){
        List<Account> lstAccounts = new List<Account>{
            new Account(Name = 'Acc01', Test_Opp__c = 'Acc01Val1'),
                new Account(Name = 'Acc02', Test_Opp__c = 'Acc01Val2')
                };
                    
                    INSERT lstAccounts;
    } 
    
    
    @isTest
    public static void testBeforeInsert(){
        
        Account acc1 = [SELECT Id, Name, Test_Opp__c
                        FROM Account 
                        WHERE Name = 'Acc01' LIMIT 1];
        
        Account acc2 = [SELECT Id, Name, Test_Opp__c
                        FROM Account 
                        WHERE Name = 'Acc02' LIMIT 1];
        
        Test.startTest();
        
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'opptest1';
        opp1.Accountid = acc1.id;
        opp1.StageName = 'Prospecting';
        opp1.CloseDate = system.Today().addDays(-3);
        INSERT opp1;
        
        Opportunity opp2 = new Opportunity();
        opp2.Name = 'oppptest2';
        opp2.Accountid = acc2.id;
        opp2.StageName = 'Prospecting';
        opp2.CloseDate = system.Today().addDays(3);
        INSERT opp2;
        
        Opportunity updatedOpp = [SELECT id, Name, StageName, Test_Opp__c
                                  FROM Opportunity
                                  WHERE Name = 'opptest1'];
        
        System.AssertEquals(updatedOpp.Test_Opp__c, acc1.Test_Opp__c);
        System.AssertEquals(updatedOpp.StageName, 'Closed');
        
        Test.stopTest();
    }
}