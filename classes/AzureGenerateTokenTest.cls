/*
 * Test class for AzureGenerateTokenTest
 * Ideally we want to check if the sas token generated is based on the actual key values, but we do not want to save them in
 * test classes for security reasons
 */ 
@isTest
public with sharing class AzureGenerateTokenTest {
    static testmethod void testGenerateSasToken() {
        Integer stringLength = 20;
        String keyName = AzureObjectUtility.generateRandomString(stringLength);
        String resourceUri = AzureObjectUtility.generateRandomString(stringLength);
        String key = AzureObjectUtility.generateRandomString(stringLength);
        Integer duration = 3000;
        
        String testSasToken = AzureReceiverUtility.getSasToken(resourceUri, keyName, key, duration);
        
        //all we can do is validate that we get a string that is not blank
        Boolean actual = (testSasToken.length() > 0) ? true : false;
        System.assertEquals(true, actual);
    }//end testGenerateSasToken
    
    static testmethod void testGetEpochTime() {
        Integer secondsToAdd = 10;
        DateTime currentTime = System.now();
        Long currentGmtTime = null;
        currentTime = currentTime.addSeconds(secondsToAdd);
        // Current time in Test
        Long testGmtTime = currentTime.getTime();
        
        // Generate time in ms
        Long generatedGmtTime = AzureGenerateToken.getEpochTime(secondsToAdd, false); 
        Boolean actual = (generatedGmtTime == testGmtTime) ? true : false;
        System.assertEquals(true, actual);
    }//end testGetEpochTime
}//end AzureGenerateTokenTest