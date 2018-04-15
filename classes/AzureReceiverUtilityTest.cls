/*
 * Test class for AzureReceiverUtilityTest. 
 * Since AzureReceiverUtility call methods from AzureReceiver, AzureJsonBodyWrapper, AzureBody, and AzureBrokerProperties
 * we should be able to use this to cover all. However, separate test classes can be added depending upon applications.
 */ 
@isTest
public with sharing class AzureReceiverUtilityTest {
    @testSetup
    static void setupData() {
        
    }//end setupData

}//end AzureReceiverUtilityTest