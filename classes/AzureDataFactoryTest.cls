/*
 * Test class for AzureDataFactory .
 */ 
@isTest
public with sharing class AzureDataFactoryTest {
    @testSetup 
    static void setupData() {
        AzureDataFactory.setupDataAzure(10, 10);
    }//end setupData
    
    static testmethod void testSetupDataAzure() {
        AzureDataFactory.setupDataAzure(5, 10);
        Integer numOfNewAccounts = [Select count()
                                    From Account];
        Boolean actual = (numOfNewAccounts > 0 ) ? true : false;
        System.assertEquals(true, actual);
    }//end testSetupDataAzure
    
    static testmethod void testCreateAccounts() {
        // Get current accounts
        Integer numOfCurrAccounts = [Select count()
                                        From Account];
        Boolean actual = (numOfCurrAccounts > 0) ? true : false;
        //if setupdata was successful it should have created accounts
        System.assertEquals(true, actual);
        
        //create new ones and then query again to make sure size is greater than previous
        AzureDataFactory.createAccounts(5, 10);
        
        Integer numOfLatestAccounts = [Select count()
                                       From Account];
        actual = (numOfCurrAccounts < numOfLatestAccounts);
        System.assertEquals(true, actual);
    }//end testCreateAccounts
    
    static testmethod void testInsertTestAzureConfig() {
        String testConfigName = 'TestAzureConfig';
        AzureDataFactory.insertTestAzureConfig(testConfigName);
        Azure_Config__c testConfig = [Select Id, Name
                                     from Azure_Config__c
                                     Where Name =: testConfigName Limit 1];
        Boolean actual = (testConfig != null) ? true : false;
        // Check if we were able to create Azure Config with name
        System.assertEquals(true, actual);
    }//end testInsertTestAzureConfig
}//end AzureDataFactoryTest