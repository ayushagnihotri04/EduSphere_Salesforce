@RestResource(urlMapping='/webhook/provider/*')
global with sharing class ProviderWebhook {
    @HttpPost
    global static void handle() {
        RestRequest req = RestContext.request;
        String payload = req.requestBody.toString();
        // Example signature header
        String signature = req.headers.get('X-Signature');
        // verify signature using provider secret if provided
        // Process payload (parse JSON, update records)
        Map<String,Object> data = (Map<String,Object>) JSON.deserializeUntyped(payload);
        System.debug('Received webhook: ' + data);
        // e.g., update a Payment__c or SMS_Log__c record
    }
}
