/**
* Batch Class for Creating Bonus Payouts.
* @author         Raghavendra
* @version        1.0
* @created        2-07-2021
* @systemLayer    Batch Class
**/

global class BatchBonuspayouts implements Database.Batchable<sObject>{
    
    /**
* @description  This start selects Bonus records with related Bonus Payout Records.
* @param    BC - Database.BatchableContext
* @return   Database.QueryLocator

*/
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT Id, Name, Start_Date__c, End_Date__c FROM Bonus__c WHERE Id NOT IN (SELECT Bonus__c FROM Bonus_Payouts__c) AND Start_Date__c != null AND End_Date__c != null');
    }
    
    /**

* @description  This excecute method creates Bonus Payouts records for each bonus record.
* @param    BC - Database.BatchableContext
* @param    scope - List<Bonus__c>
* @return   void
*/
    global void execute(Database.BatchableContext BC, List<Bonus__c> scope){
        
        List<Bonus_Payouts__c> insertbonuspaylst = new List<Bonus_Payouts__c>();
        
        for(Bonus__c ObjBonus : scope){
            Integer differenceInMonths = getCountMonth(ObjBonus.Start_Date__c, ObjBonus.End_Date__c);
              for(Integer i = 0; i<= differenceInMonths; i++){
                Bonus_Payouts__c ObjBonusPayout;
                if (i == differenceInMonths && ObjBonus.End_Date__c.Day() != 1 ){
                    ObjBonusPayout = createBonusPayoutsRecords(ObjBonus.End_Date__c,ObjBonus,i);
                }
                else{
                    ObjBonusPayout = createBonusPayoutsRecords(ObjBonus.Start_Date__c,ObjBonus,i);
                }
                insertbonuspaylst.add(ObjBonusPayout);
            }
        }
        if(!insertbonuspaylst.isEmpty()){
            INSERT insertbonuspaylst;
        }
    }
    
    /**
* @description  This excecute method gets the difference between startDate and endDate of Bonus records.
* @param    startDate - Date
* @param    endDate - Date
* @return   Integer

*/
    global Integer getCountMonth(Date startDate, Date endDate){
         system.debug('startDate--->'+startDate+' end dte---'+endDate);
        Date firstDate = Date.newInstance(startDate.year(), startDate.month(), startDate.day());
        Date secondDate = Date.newInstance(endDate.year(), endDate.month(), endDate.day());
        Integer monthsBetween = firstDate.monthsBetween(secondDate);
         monthsBetween++;
        if(endDate.day() == 1){ 
            monthsBetween = monthsBetween - 1;
        } 
        
           
        return monthsBetween;
    }
    
    /**
* @description  This method creates Bonus Payouts records.
* @param    bonusDate - Date BonusStartDate, Date BonusEndDate
* @param    ObjBonus - Bonus__c
* @param    i - Integer
* @return   Bonus_Payouts__c
*/
    
    global Bonus_Payouts__c createBonusPayoutsRecords(Date bonusDate, Bonus__c ObjBonus, Integer i){
        Bonus_Payouts__c objbonuspay = new Bonus_Payouts__c();
        Date payoutDate;
        if(ObjBonus.End_Date__c == bonusDate){
            payoutDate = bonusDate;
        }
        else{
            payoutDate = bonusDate.addMonths(i);
        }
        
        objbonuspay.Date_Of_Bonus__c = payoutDate;
        objbonuspay.Name = 'BonusPay'+i;
        objbonuspay.Bonus__C = ObjBonus.Id;
        
        return objbonuspay;
    }
 
    global void finish(Database.BatchableContext BC){
        
    }  
    
}