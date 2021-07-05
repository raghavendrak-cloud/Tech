/** trigger for Opportunity.
* @author         Raghavendra
* @modifiedBy     Raghavendra
* @created        01-07-2021
* @systemLayer    Trigger 
*/
trigger OpportunityTrigger on Opportunity (before insert) {
    if(trigger.isBefore){
        if(trigger.isInsert){
            OpportunityTriggerHandler.beforeInsert(Trigger.New);
        }
    }
}