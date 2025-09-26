@isTest
private class SmsQueueableTest {
    @isTest static void testSmsQueueable_callout() {
        Test.setMock(HttpCalloutMock.class, new MockSmsResponse());

        Test.startTest();
        Id jobId = System.enqueueJob(new SmsQueueable('+919800000000', 'Test SMS from Education CRM'));
        Test.stopTest();

        System.assertNotEquals(null, jobId, 'Job should be enqueued');
        // we rely on HttpCalloutMock to simulate success; additional asserts can check logs if created
    }
}
