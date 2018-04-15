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
        testConfig.Max_Callouts__c = 100;
        testConfig.Object_Type__c = 'Account';
        testConfig.Receiver_Id__c = 'testApplication';
        testConfig.Name = testName;
        testConfig.Resource_URI__c = 'https://searchsamples.azurewebsites.net/samplequeue';
        testConfig.Sender_Id__c = 'salesforce';
        testConfig.URI__c = 'https://searchsamples.azurewebsites.net/samplequeue/messages';
        testConfig.Version__c = '1';
            
       	insert testConfig;
    }//end insertTestAzureConfig
}//AzureDataFactory