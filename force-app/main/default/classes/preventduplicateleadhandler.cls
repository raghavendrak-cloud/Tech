/** Handler Class for preventduplicateleadhandler.
* @author         Raghavendra
* @modifiedBy     Raghavendra
* @created        01-07-2021
* @systemLayer    Trigger Handler 
*/

public class preventduplicateleadhandler {
    
    public static void beforeupdate(List<lead> newleadlst ,List<lead> oldlead){
    system.debug('lead triggered'); 
    Map<Id, Lead> oldleadMap = new Map<Id, Lead>();    
    Map<String, Lead> leadMap = new Map<String, Lead>();
        
    for(Lead lead :oldlead){
        oldleadMap.put(lead.Id,lead);      
    }  
    for (Lead lead : newleadlst) {
        if(lead.Email != null && (lead.Email != oldleadMap.get(lead.Id).Email)){
               leadMap.put(lead.Email, lead); 
          }
      }
    
    for (Lead lead : [SELECT Email FROM Lead WHERE Email IN :leadMap.KeySet()]) {
        Lead newLead = leadMap.get(lead.Email);
         newLead.Email.addError('A lead with this email ' + 'address already exists.');
    }  
 }
}