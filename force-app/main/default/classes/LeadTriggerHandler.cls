public with sharing class LeadTriggerHandler {
    public static void handleAfterUpdate(List<Lead> newLeads, Map<Id, Lead> oldMap) {
        List<Enrollment_c__c> enrollsToInsert = new List<Enrollment_c__c>();

        for (Lead l : newLeads) {
            Lead oldL = oldMap.get(l.Id);
            if (oldL != null && !oldL.IsConverted && l.IsConverted) {
                if (l.Preferred_Course__c != null && l.ConvertedContactId != null) {
                    Enrollment_c__c e = new Enrollment_c__c(
                        Contact__c = l.ConvertedContactId,
                        Course__c  = l.Preferred_Course__c,
                        Enrollment_Date__c = Date.today(),
                        Status__c = 'Confirmed'
                    );
                    enrollsToInsert.add(e);
                }
            }
        }
        if (!enrollsToInsert.isEmpty()) {
            insert enrollsToInsert;
        }
    }
}
