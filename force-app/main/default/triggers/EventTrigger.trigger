trigger EventTrigger on Event (before insert, before update) {
 if(trigger.isBefore){
        if(trigger.isInsert || trigger.isUpdate){
           EventTriggerHandler.beforeInsertOrbeforeUpdate(Trigger.New);
        }
    }
}