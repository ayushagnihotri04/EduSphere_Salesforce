@isTest
global class MockPaymentResponse implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"status":"success","chargeId":"CHARGE123"}');
        return res;
    }
}
