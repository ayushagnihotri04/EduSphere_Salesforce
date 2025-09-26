@isTest
private class ProviderWebhookTest {
    @isTest static void testHandleWebhook() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestUri = '/services/apexrest/webhook/provider/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"status":"SUCCESS","transactionId":"TX123"}');

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        ProviderWebhook.handle();
        Test.stopTest();

        System.assertNotEquals(null, RestContext.response, 'Response should not be null');
    }
}
