/** Lead Trigger.
* @author         Raghavendra
* @modifiedBy     Raghavendra
* @created        01-07-2021
* @systemLayer    Trigger Handler 
*/

trigger leadtrigger on Lead (before update) {
    if(Trigger.isupdate){
        preventduplicateleadhandler.beforeupdate(Trigger.New,Trigger.old);
    }
    
}