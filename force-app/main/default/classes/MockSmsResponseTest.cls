@isTest
private class MockSmsResponseTest {

    @isTest static void testGenerateMockResponse() {
        // Arrange
        Test.setMock(HttpCalloutMock.class, new MockSmsResponse());
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:MySmsProvider/messages');
        req.setMethod('POST');

        // Act
        HttpResponse res = new MockSmsResponse().respond(req);

        // Assert
        System.assertNotEquals(null, res, 'Response should not be null');
        System.assertEquals(200, res.getStatusCode(), 'Status code should be 200');
        System.assert(res.getBody().contains('Message Sent Successfully'), 
                      'Response body should contain success message');
    }
}
