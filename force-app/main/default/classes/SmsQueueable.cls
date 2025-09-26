public class SmsQueueable implements Queueable, Database.AllowsCallouts {
    private String toPhone;
    private String messageBody;

    public SmsQueueable(String toPhone, String messageBody) {
        this.toPhone = toPhone;
        this.messageBody = messageBody;
    }

    public void execute(QueueableContext ctx) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();

        // Use Named Credential + endpoint path
        req.setEndpoint('callout:MySMSProvider/messages');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');

        // Read API key from Custom Metadata (optional)
        String apiKey;
        try {
            List<External_Provider__mdt> listMeta = [
                SELECT API_Key__c FROM External_Provider__mdt
                WHERE DeveloperName = 'MySMSProvider' LIMIT 1
            ];
            if (!listMeta.isEmpty()) apiKey = listMeta[0].API_Key__c;
        } catch (Exception ex) {
            // ignore if metadata missing; handle gracefully
        }

        if (apiKey != null) {
            req.setHeader('Authorization', 'Bearer ' + apiKey);
        }

        Map<String, Object> payload = new Map<String, Object>{
            'to' => toPhone,
            'from' => 'SENDERID', // update per provider / use Custom Metadata if needed
            'body' => messageBody
        };

        req.setBody(JSON.serialize(payload));

        try {
            HttpResponse res = http.send(req);
            Integer sc = res.getStatusCode();
            String body = res.getBody();
            // basic logging - in production write to a log object
            System.debug('SMS response (' + sc + '): ' + body);
            // Add logic to persist provider message id or status if required
        } catch (Exception ex) {
            System.debug('SmsQueueable exception: ' + ex.getMessage());
            // You can create a custom log record here for retries
        }
    }
}
