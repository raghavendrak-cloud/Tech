/*
* @author        Ragahvendra
* @modifiedBy    Raghavendra 
* @maintainedBy   
* @version        1.0
* @created        2021-06-10
* @modified       
* @systemLayer    Test Class
*/

@isTest
public class EventTriggerHandlerTest {

    @isTest
    public static void testBeforeinsertUpdate(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'systema', Email='systemadmin@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='systemadmin@testorg.com');

        System.runAs(u) {
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId());

            Account ObjAcc = new Account();
            ObjAcc.Name = 'TestAcc03';
            INSERT ObjAcc;

            List<Event> eventList = new List<Event>();
            for(integer i=1;i<=100;i++){
                Event eventObj = new Event();
                eventObj.Subject = 'Call';
                eventObj.WhatId = ObjAcc.Id;
                eventObj.DurationInMinutes = 52;
                eventObj.ActivityDateTime = System.now();
                eventList.add(eventObj);
            }
            INSERT eventList;

            Event eventObj = new Event();
            eventObj.Subject = 'Call';
            eventObj.WhatId = ObjAcc.Id;
            eventObj.DurationInMinutes = 52;
            eventObj.ActivityDateTime = System.now(); 
            Test.startTest();
            try {
                INSERT eventObj;
            } catch (DmlException e) {
               
                System.assert(e.getDmlMessage(0).indexOf(
                   'Too many Events created this month for user:') > -1);
            }
            Test.stopTest();
            List<Event> ownerEventsList = [SELECT Id, Subject, OwnerId, CreatedById 
                                           FROM Event 
                                           WHERE WhatId =: ObjAcc.Id];
              System.assertEquals(false, ownerEventsList.size()>100);
        }
    }  
}