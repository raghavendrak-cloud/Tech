/** Handler Class for Opportunity.
* @author         Raghavendra
* @modifiedBy     Raghavendra
* @created        01-07-2021
* @systemLayer    Trigger Handler
*/ 

public class OpportunityTriggerHandler {
    
    private static final Id OppRecordTypeId= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Renewal').getRecordTypeId();
    private static final String Oppstage = 'Closed';
    
    public static void beforeInsert(List<Opportunity> oppList){
        
        Map<Id,Opportunity> getOppAccIdMap = new Map<Id,Opportunity>();
        for(Opportunity opp : oppList){
            if(opp.AccountId != null){
                getOppAccIdMap.put(opp.AccountId,opp);
            }
        }
       Map<Id,Account> mapOfAccById = new Map<Id,Account>([SELECT Id, Name, Test_Opp__c 
                                                            FROM Account
                                                            WHERE Id =: getOppAccIdMap.keyset()]);
        
        for(Opportunity objOpp : getOppAccIdMap.values()){
           if(mapOfAccById.containsKey(objOpp.AccountId)){
                objOpp.Test_Opp__c = mapOfAccById.get(objOpp.AccountId).Test_Opp__c;
            }
            if(objOpp.CloseDate<System.Today()){
                objOpp.StageName = Oppstage;
                objOpp.RecordTypeId = OppRecordTypeId;
            }
        }
    }
}