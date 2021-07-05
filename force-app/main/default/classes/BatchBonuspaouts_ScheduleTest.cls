/**
* Test Class for BatchCreatingBonusPayouts and BatchScheduleCreateBonusPayout.
* @author         Raghavendra
* @modifiedBy     Raghavendra
* @maintainedBy   Raghavendra
* @version        1.0
* @created        2021-06-14
* @modified       
* @systemLayer    Test Class

**/

@isTest
public class BatchBonuspaouts_ScheduleTest {
    
    @testSetup() static void setup(){
        
        List<Bonus__c> bonusToInsertList = new List<Bonus__c>();
        for(integer i=0;i<=10;i++){
            Bonus__c ObjBonus = new Bonus__c();
            ObjBonus.Name = 'TestBonus'+i;
            ObjBonus.Start_Date__c =Date.valueOf('2021-02-14 00:00:00');
            ObjBonus.End_Date__c =Date.valueOf('2021-06-01 00:00:00');
            bonusToInsertList.add(ObjBonus);
        }
        INSERT bonusToInsertList;
    }
    
    @isTest
    public static void testBatchCreateBonusPayment(){
        
        List<Bonus__c> bonusToInsertList = new List<Bonus__c>{
            new Bonus__c(Name='janbonus',Start_Date__c=Date.valueOf('2021-07-10 00:00:00''),End_Date__c=Date.valueOf('2021-10-05 00:00:00')),
                new Bonus__c(Name='Febbonus',Start_Date__c=Date.valueOf('2021-05-10 00:00:00'),End_Date__c=Date.valueOf('2021-7-05 00:00:00'))
                };
                    INSERT bonusToInsertList;
        
        Test.startTest();
        ID BatchProcessdId = Database.executeBatch(new BatchBonuspayouts());
        Test.stopTest();
        
        List<Bonus_Payouts__c> bonusPayoutInsertList = [SELECT Id, Name, Bonus__c
                                                        FROM Bonus_Payouts__c];
        
        System.assertEquals(51, bonusPayoutInsertList.Size());
        System.assert(bonusPayoutInsertList.Size()>0);
    }
    
    @isTest 
    public static void testScheduleCreateBonusPayment() {
        
        Test.startTest();
        ScheduleCreateBonusPayout ObjScheduleBP = new ScheduleCreateBonusPayout();
        String sch = '0 0 5 * * ?'; 
        system.schedule('Test Scheduler', sch, ObjScheduleBP); 
        ObjScheduleBP.execute(null);
        Test.stopTest();
        List<Bonus_Payouts__c> bonusPayoutInsertList = [SELECT Id, Name, Bonus__c
                                                        FROM Bonus_Payouts__c];
        System.assertEquals(44, bonusPayoutInsertList.size());
    }
}