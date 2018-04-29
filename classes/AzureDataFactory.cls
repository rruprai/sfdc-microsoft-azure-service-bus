/*
 * Used to generate data for test classes. 
 * setupDataAzure can be used in the setupData method that has @testSetup. This will allow for easily creating data for 
 * various test classes. Note that @testSetup does not allow for code coverage so you still need to have separate test class
 * for that one. 
 */ 
public with sharing class AzureDataFactory {
    public static void createAccounts(Integer numOfAccnts, Integer lengthOfNames) {
        List<Account> newAcnts = new List<Account>();
        Account newAcnt = null;
        for(Integer num = 0; num < numOfAccnts; num++) {
            newAcnt = new Account();
            newAcnt.Name = AzureObjectUtility.generateRandomString(lengthOfNames);
            newAcnts.add(newAcnt);
        }//end for
        
        if(newAcnts.size() > 0) {
            insert newAcnts;
        }//end if
    }//createAccount
    
    public static void setupDataAzure(Integer numOfAcnts, Integer nameLength) {
        // First setup a single Test Azure Config.
        insertTestAzureConfig('TestAzureConfig');
        // Let's create test accounts.
        createAccounts(numOfAcnts, nameLength);
    }//setupDataAzure
    
    public static void insertTestAzureConfig(String testName) {
        // We have to hard code some elements since we cannot use actual keys and other elements
        Azure_Config__c testConfig = new Azure_Config__c();
        testConfig.Content_Length__c = '0';
        testConfig.Content_Type__c = 'application/json';
        testConfig.Default_Key__c = AzureObjectUtility.generateRandomString(20);
        testConfig.Duration_for_Token__c = 3600;
        testConfig.Endpoint__c = 'https://searchsamples.azurewebsites.net/samplequeue/messages/head?timeout=60';
        testConfig.HTTP_Method__c = 'POST';
        testConfig.Key_Name__c = 'salesforcequeue';
        testConfig.Key__c = AzureObjectUtility.generateRandomString(20); 
        testConfig.Long_Polling_Timeout__c = 60;
        testConfig.Max_Callouts__c = 10;
        testConfig.Object_Type__c = 'Account';
        testConfig.Receiver_Id__c = 'testApplication';
        testConfig.Name = testName;
        testConfig.Resource_URI__c = 'https://searchsamples.azurewebsites.net/samplequeue';
        testConfig.Sender_Id__c = 'salesforce';
        testConfig.URI__c = 'https://searchsamples.azurewebsites.net/samplequeue/messages';
        testConfig.Version__c = '1';
            
       	insert testConfig;
    }//end insertTestAzureConfig
    
    public static String generateJsonBody(String version, String receiverId, String senderId, List<Account> acntsToProcess) {
        // Setup JSON Generator
        JSONGenerator jsonGen = JSON.createGenerator(true);
        jsonGen.writeStartObject();
        jsonGen.writeStringField('version', version);
        jsonGen.writeStringField('receiverId', receiverId);
        jsonGen.writeStringField('senderId', senderId);
        
        // Set some Broker Properties for parsing
        jsonGen.writeObjectField('BrokerProperties', new AzureBrokerProperties());
        
        // add body
        jsonGen.writeFieldName('body');
        jsonGen.writeStartObject();

        // This will need to be modified to use your test cases. This is simplified for testing purposes.
		jsonGen.writeStringField('objectName', 'testaccount');     
        // Ending curly brace of body.
        jsonGen.writeEndObject();
        // End curly brace of message.
        jsonGen.writeEndobject();
        return jsonGen.getAsString();
    }// end generateJsonBody
    
    public static String generateBrokerProperties(AzureBrokerProperties brokerProperties) {
        JSONGenerator jsonProperties = JSON.createGenerator(true);
        jsonProperties.writeStartObject();
        jsonProperties.writeStringField('correlationId', brokerProperties.correlationId);
        jsonProperties.writeStringField('deliveryCount', String.valueOf(brokerProperties.deliveryCount));
        jsonProperties.writeStringField('enqueuedSequenceNumber', String.valueOf(brokerProperties.enqueuedSequenceNumber));
        jsonProperties.writeStringField('enqueuedTimeUtc', brokerProperties.enqueuedTimeUtc);
        jsonProperties.writeStringField('label', brokerProperties.label);
        jsonProperties.writeStringField('lockToken', brokerProperties.lockToken);
        jsonProperties.writeStringField('lockedUntilUtc', brokerProperties.lockedUntilUtc);
        jsonProperties.writeStringField('messageId', brokerProperties.messageId);
        jsonProperties.writeStringField('partitionKey', brokerProperties.partitionKey);
        jsonProperties.writeStringField('sequenceNumber', String.valueOf(brokerProperties.sequenceNumber));
        jsonProperties.writeStringField('sessionId', brokerProperties.sessionId);
        jsonProperties.writeStringField('state', brokerProperties.state); 
        jsonProperties.writeStringField('timeToLive', String.valueOf(brokerProperties.timeToLive));
        jsonProperties.writeEndObject();
        return jsonProperties.getAsString();
    }//generateBrokerProperties
}//AzureDataFactory