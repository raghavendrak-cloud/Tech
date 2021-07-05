/**
* Scheduler Class for BatchCreatingBonusPayouts.
* @author         Raghavendra
* @version        1.0
* @created        2021-06-14
* @modified       
* @systemLayer    Schedulable Class
**/

global class ScheduleCreateBonusPayout implements Schedulable{

    global void execute(SchedulableContext sc){
        
        BatchBonuspayouts callBonuspayout = new BatchBonuspayouts();
        Database.executeBatch(callBonuspayout,200); 
    }
    
    
}
