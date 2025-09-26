@isTest
private class LeadAfterUpdateTest {
    @isTest
    static void testLeadCreationCreatesFollowupTask_Robust() {
        // --- pick a Profile for the test user (Standard User if present, else first profile) ---
        Id profileId;
        List<Profile> pList = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        if (!pList.isEmpty()) profileId = pList[0].Id;
        else profileId = [SELECT Id FROM Profile LIMIT 1].Id;

        // --- create unique test user ---
        String uniqueSuffix = String.valueOf(Datetime.now().getTime());
        User testUser = new User(
            FirstName = 'Flow',
            LastName  = 'Owner' + uniqueSuffix,
            Alias     = 'flw' + uniqueSuffix.substring(uniqueSuffix.length()-3),
            Username  = 'flow.owner.' + uniqueSuffix + '@example.test',
            Email     = 'flow.owner.' + uniqueSuffix + '@example.test',
            TimeZoneSidKey = 'Asia/Kolkata',
            LocaleSidKey   = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = profileId
        );
        insert testUser;

        // --- Build Lead dynamically ---
        SObject leadObj = Schema.getGlobalDescribe().get('Lead').newSObject();
        leadObj.put('FirstName', 'TF');
        leadObj.put('LastName', 'TestLead' + uniqueSuffix);
        leadObj.put('Company', 'TestCompany');
        leadObj.put('OwnerId', testUser.Id);

        // --- Set Status to a valid Flow-triggering value ---
        List<String> triggerStatuses = new List<String>{'Open - Not Contacted'};
        Map<String, Schema.SObjectField> leadFields = Schema.SObjectType.Lead.fields.getMap();
        Boolean statusSet = false;

        if (leadFields.containsKey('Status')) {
            Schema.DescribeFieldResult dfr = leadFields.get('Status').getDescribe();
            Set<String> allowed = new Set<String>();
            for (Schema.PicklistEntry pe : dfr.getPicklistValues()) {
                allowed.add(pe.getValue());
            }
            for (String val : triggerStatuses) {
                if (allowed.contains(val)) {
                    leadObj.put('Status', val);
                    statusSet = true;
                    break;
                }
            }
        }

        System.assert(statusSet, 'None of the Flow-triggering Status values ("Open - Not Contacted") are available in this org.');

        // --- Optional fields used by the Flow ---
        if (leadFields.containsKey('FollowupDueDate__c')) {
            leadObj.put('FollowupDueDate__c', Date.today().addDays(2));
        }
        if (leadFields.containsKey('FollowupSubject__c')) {
            leadObj.put('FollowupSubject__c', 'Follow-up for new lead (test)');
        }
        if (leadFields.containsKey('FollowupDueDate')) {
            leadObj.put('FollowupDueDate', Date.today().addDays(2));
        }
        if (leadFields.containsKey('FollowupSubject')) {
            leadObj.put('FollowupSubject', 'Follow-up for new lead (test)');
        }

        // --- Insert Lead inside runAs to simulate Flow trigger ---
        System.runAs(testUser) {
            Test.startTest();
                insert leadObj;
            Test.stopTest();
        }

        // --- Check if Task was created by Flow ---
        Datetime windowStart = Datetime.now().addMinutes(-10);
        List<Task> tasksForUser = [
            SELECT Id, Subject, Status, Priority, OwnerId, CreatedDate, WhatId, WhoId
            FROM Task
            WHERE OwnerId = :testUser.Id
              AND CreatedDate >= :windowStart
            ORDER BY CreatedDate DESC
            LIMIT 50
        ];

        System.assert(tasksForUser.size() > 0,
            'Expected at least one Task assigned to the Lead owner (created by the Flow). ' +
            'If this assertion fails, check your Flow Start condition and any required variables.');
    }
}
