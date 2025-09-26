public with sharing class EnrollmentService {
    @AuraEnabled
    public static Id createEnrollment(Id contactId, Id courseId, Id batchId) {
        Enrollment_c__c e = new Enrollment_c__c(
            Contact__c = contactId,
            Course__c  = courseId,
            Batch__c   = batchId,
            Enrollment_Date__c = Date.today(),
            Status__c = 'Confirmed'
        );
        insert e;
        return e.Id;
    }
}
