@isTest
private class EnrollmentServiceTest {
    @isTest static void testCreateEnrollment() {
        Contact c = new Contact(LastName = 'Test');
        insert c;

        Course_c__c course = new Course_c__c(Name = 'UnitTest Course');
        insert course;

        Batch_c__c batch = new Batch_c__c(Name = 'Batch 1', Course__c = course.Id);
        insert batch;

        Test.startTest();
        Id enrollmentId = EnrollmentService.createEnrollment(c.Id, course.Id, batch.Id);
        Test.stopTest();

        System.assertNotEquals(null, enrollmentId);

        Enrollment_c__c en = [
            SELECT Contact__c, Course__c, Batch__c, Status__c
            FROM Enrollment_c__c
            WHERE Id = :enrollmentId
        ];
        System.assertEquals(c.Id, en.Contact__c);
        System.assertEquals(course.Id, en.Course__c);
        System.assertEquals(batch.Id, en.Batch__c);
        System.assertEquals('Confirmed', en.Status__c);
    }
}
