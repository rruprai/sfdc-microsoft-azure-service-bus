/*
 * Test class for AzureReceiverUtilityTest. 
 * Since AzureReceiverUtility call methods from AzureReceiver, AzureJsonBodyWrapper, AzureBody, and AzureBrokerProperties
 * we should be able to use this to cover all. However, separate test classes can be added depending upon applications.
 */ 
@isTest
public with sharing class AzureReceiverUtilityTest {
    @testSetup
    static void setupData() {
        AzureDataFactory.setupDataAzure(1, 10);
    }//end setupData
    
    static testmethod void testAzureReceiver() {
        Azure_Config__c testConfig = [Select Resource_URI__c, Key_Name__c, Key__c, Duration_for_Token__c
                                     From Azure_Config__c Limit 1];
        String testSasToken = AzureReceiverUtility.getSasToken(testConfig.Resource_URI__c, testConfig.Key_Name__c, testConfig.Key__c, Integer.valueOf(testConfig.Duration_for_Token__c));
        // We just need to make sure we can generate a token. You may add single test cases as needed.
        Boolean actual = (testSasToken.length() > 0) ? true : false;
        System.assertEquals(true, actual);
    }//end testAzureReceiver
    
    static testmethod void testStatusCodes() {
        Set<Integer> successfulCodes = AzureReceiverUtility.getHttpSuccessStatusCodes();
        Boolean actual = false;
        for(Integer code : successfulCodes) {
            if(code == 200 | code == 201) {
                actual = true;
            }
        }//end for
        
        System.assertEquals(true, actual);
        
        // Check no content codes.
        actual = false;
        Set<Integer> noContentCodes = AzureReceiverUtility.getHttpNoContentStatusCodes();
        for(Integer noContentCode : noContentCodes) {
            if(noContentCode == 204) {
                actual = true;
            }
        }//end for
        System.assertEquals(true, actual);
        
        // Check failed status codes.
        actual = false;
        Set<Integer> failedCodes = AzureReceiverUtility.getHttpFailedStatusCode();
        for(Integer failedCode : failedCodes) {
            if(failedCode == 0) {
                actual = true;
            }
        }//end
        System.assertEquals(true, actual);
    }//end testStatusCode
    
    static testmethod void testCreateAzureMessage() {
        //public static Azure_Message__c createSingleAzureMsg(String responseBody, Integer responseStatusCode, String responseStatus) {
        // You can add custom test cases but we just need to make sure we can insert properly with random body.
        String testBody = AzureObjectUtility.generateRandomString(10);
        // Get Random response code.
        Set<Integer> responseCodes = AzureReceiverUtility.getHttpSuccessStatusCodes();
        Integer numOfResponseCodes = responseCodes.size();
        Integer randomIndex = AzureObjectUtility.getRandomNumber(numofResponseCodes);
        List<Integer> responseCodesList = new List<Integer>(responseCodes);
        // Set Random status.
        String testStatus = AzureObjectUtility.generateRandomString(5);
        Azure_Message__c testAzureMessage = AzureReceiverUtility.createSingleAzureMsg(testBody, responseCodesList.get(randomIndex), testStatus);
        insert testAzureMessage;
        
        Integer testMessage = [Select count()
                              From Azure_Message__c];
        // Plenty of ways to test, just keeping it simple here.
        Boolean actual = (testMessage > 0) ? true : false;
        System.assertEquals(true, actual);
    }//end testCreateAzureMessage
    
    static testmethod void testOkInitiateAzureReceiver() {
        Azure_Config__c testConfig = [Select URI__c,HTTP_Method__c,Resource_URI__c,Key_Name__c, Key__c,Duration_for_Token__c, Endpoint__c, Content_Type__c,Content_Length__c, Max_Callouts__c
                                     From Azure_Config__c Limit 1];
        
        Test.startTest();
        // Set the mock test first and then initiate Azure Receiver.
        Test.setMock(HttpCalloutMock.class, new AzureOkCalloutMock());
        AzureReceiverUtility.initiateAzureReceiver(
            testConfig.URI__c,
            testConfig.HTTP_Method__c,
            testConfig.Resource_URI__c,
            testConfig.Key_Name__c,
            testConfig.Key__c,
            Integer.valueOf(testConfig.Duration_for_Token__c),
            testConfig.Endpoint__c,
            testConfig.Content_Type__c,
            testConfig.Content_Length__c,
            Integer.valueOf(testConfig.Max_Callouts__c)
        );
        Test.stopTest();
    }//end testOkInitiateAzureReceiver
    
    static testmethod void testNoContentInitiateAzureReceiver() {
        Azure_Config__c testConfig = [Select URI__c,HTTP_Method__c,Resource_URI__c,Key_Name__c, Key__c,Duration_for_Token__c, Endpoint__c, Content_Type__c,Content_Length__c, Max_Callouts__c
                                     From Azure_Config__c Limit 1];
        
        Test.startTest();
        // Set the mock test first and then initiate Azure Receiver.
        Test.setMock(HttpCalloutMock.class, new AzureNoContentCalloutMock());
        AzureReceiverUtility.initiateAzureReceiver(
            testConfig.URI__c,
            testConfig.HTTP_Method__c,
            testConfig.Resource_URI__c,
            testConfig.Key_Name__c,
            testConfig.Key__c,
            Integer.valueOf(testConfig.Duration_for_Token__c),
            testConfig.Endpoint__c,
            testConfig.Content_Type__c,
            testConfig.Content_Length__c,
            Integer.valueOf(testConfig.Max_Callouts__c)
        );
        Test.stopTest();
    }//end testOkInitiateAzureReceiver

}//end AzureReceiverUtilityTest