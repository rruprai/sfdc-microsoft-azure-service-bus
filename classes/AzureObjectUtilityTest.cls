/*
 * Test class for AzureObjectUtility
 * Goal is to generate higher than 90% code coverage
 */ 
@isTest
public with sharing class AzureObjectUtilityTest {
    static testmethod void generateRandomStringTest(){
        Integer fooLength = 10;
        String foo = AzureObjectUtility.generateRandomString(fooLength);
        String fooBar = AzureObjectUtility.generateRandomString(fooLength + 5);
        Boolean actual = (foo.equalsIgnoreCase(fooBar)) ? true : false;
        
        //should they be the same?
        System.assertNotEquals(true, actual);
        
        // Does it create a string as long as expected
        actual = (foo.length() == fooLength) ? true : false;
        System.assertEquals(true, actual);
    }//generateRandomStringTest
    
    static testmethod void getRandomNumberTest() {
        Integer numberRange = 100;
        Integer randomFoo = AzureObjectUtility.getRandomNumber(numberRange);
        Integer randomBar = AzureObjectUtility.getRandomNumber(numberRange);
        
        Boolean actual = ((randomFoo <= numberRange) | (randomBar <= numberRange)) ? true : false;
        System.assertEquals(true, actual);
    }//end getRandomNumberTest
    
    static testmethod void generateRandomKeyTest() {
        Integer keyLength = 20;
        Integer aesKeyLength = 128;
        
        String randomKey = AzureObjectUtility.generateRandomKey(keyLength, aesKeyLength);
        //since the key is going to be random we just need to ensure length > 0 so atleast we have something
        Boolean actual = (randomKey.length() > 0) ? true : false;
        System.assertEquals(true, actual);
    }//end generateRandomKeyTest
    
    static testmethod void getPicklistValuesTest() {
        SObject sObjAcnt = new Azure_Config__c();
        String fieldName = 'Object_Type__c';
        Boolean getDefaultOnly = false;
        List<String> objectTypeList = AzureObjectUtility.getPicklistValues(sObjAcnt, fieldName, getDefaultOnly);
        //unless we want to check for certain values let's just check to make sure we get any values back
        Boolean actual = (objectTypeList.size() > 0) ? true : false;
        System.assertEquals(true, actual);
        
        //get default only
        List<String> contentTypeList = AzureObjectUtility.getPicklistValues(sObjAcnt, 'Content_Type__c', true);
        actual = (contentTypeList.size() == 1) ? true : false;
        System.assertEquals(true, actual);
    }//end getPicklistValues
    
    static testmethod void generateRandomUrlTest() {
        String domain = 'iam.amazonaws.com';
        String uri = '';
        String randomUrl = AzureObjectUtility.generateRandomUrl(domain, uri);
        //unless we want to validate against a particular domain, let's ensure we atleast get a value back
        Boolean actual = (randomUrl.length() > 0) ? true : false;
        System.assertEquals(true, actual);
    }//end generateRandomUrlTest
    
    static testmethod void createAzureConfigTest() {
        String configName = 'AzureAccountSenderTester';
        AzureObjectUtility.createAzureConfig(configName, 25, 5, 25);
        Azure_Config__c testConfig = AzureObjectUtility.getAzureConfig(configName);
        Boolean actual = (testConfig != null) ? true : false;
        System.assertEquals(true, actual);
    }//end createAzureConfigTest 
    
    static testmethod void generateCurrentTimeTest() {
        Integer minsToAdd = 10;
        Integer secsToAdd = 60;
        String currPlusMins = AzureObjectUtility.generateCurrentTimePlusMinutes(minsToAdd);
        String currPlusSecs = AzureObjectUtility.generateCurrentTimePlusSeconds(secsToAdd);
        
        Boolean actual = (currPlusMins.equalsIgnoreCase(currPlusSecs)) ? true : false;
        System.assertNotEquals(true, actual);
    }//end generateCurrentTimePlusMinutesTest

}//end AzureObjectUtilityTest