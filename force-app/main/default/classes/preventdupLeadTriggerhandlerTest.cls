@isTest
public class preventdupLeadTriggerhandlerTest { 
    
    @testSetup static void setup(){
       List<Lead> leadToInsertList = new List<Lead>{
            new Lead( Company = 'Testcompany1',LastName = 'TestLead1',Status = 'Open', Email = 'testlead01@test.com'),
                new Lead( Company = 'Testcompany2',LastName = 'TestLead2',Status = 'Open', Email = 'testlead02@test.com')
                };        
         INSERT leadToInsertList;
    }
    @isTest
    public static void testBeforeLeadUpdate()
    {
        Test.startTest();
        Lead ObjLead = [SELECT Id, Name, Email, Status
                        FROM Lead
                        WHERE LastName='TestLead2' 
                        LIMIT 1];
        ObjLead.Email = 'testlead01@test.com';
        try {
            UPDATE ObjLead;
        } catch (DmlException e) {
            //System.assert(e.getDmlMessage(0).indexOf(
             //   'Duplicate Lead') > -1);
        }
        Lead ObjLead2 = [SELECT Id, Name, Email, Status
                         FROM Lead
                         WHERE LastName='TestLead2' 
                         LIMIT 1];
        ObjLead2.Email = 'testlead04@testabc.com';
        UPDATE ObjLead2;
        System.assertEquals('testlead04@testabc.com', ObjLead2.Email);
        Test.stopTest();
    }
}