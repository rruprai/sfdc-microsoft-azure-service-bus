/*
 * When making callouts, a test callout mock class is needed to set the test.setMock().
 * Test successfull callout.
 * Helpful links: https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_testing_best_practices.htm
 */ 

@isTest
global class AzureOkCalloutMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        List<Account> acnts = [Select Name, Id
                               From Account];
        // Let's create fake response for testing.
        HttpResponse resp = new HttpResponse();
        // Get Response similar to AzureJsonBodyWrapper.
        String jsonBody = AzureDataFactory.generateJsonBody(String.valueOf(1), 'testApplication', 'Salesforce', acnts);
        resp.setBody(jsonBody);
        resp.setStatus('OK');
        resp.setStatusCode(201);
        resp.setHeader('Content-Type', 'application/json');
        resp.setHeader('Content-Length', String.valueOf(0));
        
        // Setup BrokerProperties for testing and parsing
        AzureBrokerProperties testProperties = new AzureBrokerProperties();
        resp.setHeader('BrokerProperties', AzureDataFactory.generateBrokerProperties(testProperties));
        return resp;
    }//end respond
}//end AzureCalloutMock