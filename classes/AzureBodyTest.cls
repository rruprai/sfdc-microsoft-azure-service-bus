/*
 * Test class for AzureBodyTest. 
 * Adding this in case it needs to be expanded on in the future.
 */ 
@isTest
public with sharing class AzureBodyTest {
    static testmethod void testConstructors() {
        AzureBody bodyWithParameter = new AzureBody(AzureObjectUtility.generateRandomString(10));
        System.assertEquals(true, (String.isNotEmpty(bodyWithParameter.objectName)));
        
        AzureBody bodyNoParameter = new AzureBody();
        System.assertEquals(true, (String.isEmpty(bodyNoParameter.objectName)));
    }//end testConstructors
}//end AzureBodyTest