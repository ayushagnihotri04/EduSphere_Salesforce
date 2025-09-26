global class MockSmsResponse implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"message":"Message Sent Successfully"}');
        res.setStatusCode(200);
        return res;
    }
}
