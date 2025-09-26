public with sharing class PaymentService {
    @AuraEnabled
    public static Map<String,Object> createCharge(String token, Decimal amount, String currencyCode) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:PaymentProvider/charges');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');

        Map<String,Object> body = new Map<String,Object>{
            'token' => token,
            'amount' => amount,
            'currency' => currencyCode
        };

        req.setBody(JSON.serialize(body));
        HttpResponse res = http.send(req);
        return (Map<String,Object>) JSON.deserializeUntyped(res.getBody());
    }
}
