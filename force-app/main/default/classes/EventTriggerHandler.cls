/** Handler Class for EventTrigger.
* @author         Raghavendra
* @modifiedBy     Raghavendra
* @created        01-07-2021
* @systemLayer    Trigger Handler
**/

public class EventTriggerHandler {

 public static void beforeInsertOrbeforeUpdate(List<Event> eventsList){
      
        Map<Id,String> getUserNamemap = new Map<Id,String>();
        Set<Id> eventUserIdSet = new Set<Id>();
        for(Event objEvent : eventsList){
            if(!string.isEmpty(objEvent.OwnerId)){
                eventUserIdSet.add(objEvent.OwnerId);
              }
        } 
         EventLimit__mdt ObjeventsLimitMdt = [SELECT Id, Max_Number_Of_Events_Per_User__c
                                              FROM EventLimit__mdt
                                              WHERE Label = 'User Event Limit' LIMIT 1];
         
         List<Event> ownerEventsList = [SELECT Id, Subject, OwnerId, CreatedById 
                                        FROM Event 
                                        WHERE  CreatedDate = THIS_MONTH AND CreatedById =: eventUserIdSet];
  
        Map<Id,Event[]> EventsByOwnerIdMap = new Map<Id,Event[]>();
        /*capture the user Id and events*/
        for(Event objEvent : ownerEventsList){
            if(EventsByOwnerIdMap.containsKey(objEvent.OwnerId)){
                EventsByOwnerIdMap.get(objEvent.OwnerId).add(objEvent);
            }
            else{
                Event[] eventList = new Event[]{objEvent};
                    EventsByOwnerIdMap.put(objEvent.OwnerId, eventList);
            }
        }
        
        for(user obj : [select id,name from user where Id =: EventsByOwnerIdMap.keyset()]){
             getUserNamemap.put(obj.ID,obj.Name);
         }
     
     /* Get the user limit and show the error message*/
        for(Event objEvt : eventsList){
            if(!EventsByOwnerIdMap.isEmpty()){
                if(EventsByOwnerIdMap.containsKey(objEvt.OwnerId)){
                    List<Event> ownerEvtList = EventsByOwnerIdMap.get(objEvt.OwnerId);
                    if(ownerEvtList.size()>=ObjeventsLimitMdt.Max_Number_Of_Events_Per_User__c){
                        objEvt.addError('Too many Events created this month for user:'+getUserNamemap.get(objEvt.OwnerId) + ' ' + ':' + 'Your event Limit is  ' +ObjeventsLimitMdt.Max_Number_Of_Events_Per_User__c);
                    }
                }
            }
         }
    }
}