/*
 * Mainly used to generate data for fields such as Picklist, Boolean, Text, etc. at random
 * There are many out in the community, but this is specifically for AWS classes
 */ 
public with sharing class AzureObjectUtility {
    public static string generateRandomString(Integer strLength) {
        String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        Integer charLength = chars.length();
        String randomStr = ''; 
        Integer randomIndex = 0;
        while(randomStr.length() < strLength) {
            //generate random number between 0-chars
            randomIndex = getRandomNumber(charLength);
            //concatenate character to string
            randomStr += chars.indexOfChar(randomIndex);
        }//end while
        
        return randomStr;
    }//end generateRandomString
    
    public static Integer getRandomNumber(Integer range){
        Double rand = Math.random() * range;
        return (rand.intValue());
    }//end getRandomNumber
    
    public static String generateRandomKey(Integer keyLength, Integer aesKeySize) {
        Blob key = Crypto.generateAesKey(aesKeySize);
        String randomKey = EncodingUtil.convertToHex(key);
        return randomKey.substring(0, keyLength);
    }//end generateRandomKey
    
    public static List<String> getPicklistValues(SObject sObj, String fieldName, Boolean getDefaultOnly) {
        List<String> picklistVals = new List<String>();
        //get the sObjectType, results, fieldmap, and finally the picklist values
        Schema.SObjectType sobjType = sObj.getSObjectType();
        Schema.DescribeSObjectResult sObjResult = sobjType.getDescribe();
        Map<String, Schema.SObjectField> sObjFieldMap = sObjResult.fields.getMap();
        //lowercase fieldName since the machine value will be used as key in map
        List<Schema.PicklistEntry> sObjPickListEntryList = sObjFieldMap.get(fieldName.toLowerCase()).getDescribe().getPickListValues();
        //only return default value if true is passed in. if no default value then return all
        for (Schema.PicklistEntry entry : sObjPickListEntryList) {
            if(entry.isDefaultValue() && getDefaultOnly) {
                picklistVals.clear();
                picklistVals.add(entry.getValue());
                break;
            }//end if
            else {
            	picklistVals.add(entry.getValue());    
            }//end else
        }//end for
        
        return picklistVals;
    }//end getPicklistValues
    
    public static String generateRandomUrl(String domain, String uri) {
        String randomUrl = 'https://' + domain + '/' + uri;
        return randomUrl;
    }//end getSalesforceBaseUrl
    
    public static void createAzureConfig(String configName, Integer keyLength, Integer idLength, Integer versionLength) {
        Azure_Config__c testConfig = new Azure_Config__c();
        testConfig.Content_Length__c = '0';
        testConfig.Content_Type__c = 'application/json';
        testConfig.Duration_for_Token__c = 3600;
        testConfig.Endpoint__c = 'https://searchsamples.azurewebsites.net/api/endpoint';
        testConfig.HTTP_Method__c = 'POST';
        testConfig.Key_Name__c = 'HttpMessageHandler';
        testConfig.Key__c = generateRandomString(keyLength);
        testConfig.Default_Key__c = generateRandomString(keyLength);
        testConfig.Long_Polling_Timeout__c = 60;
        testConfig.Max_Callouts__c = 100;
        testConfig.Name = configName;
        testConfig.Resource_URI__c = 'https://searchsamples.azurewebsites.net';
        testConfig.URI__c = 'https://searchsamples.azurewebsites.net/api/uri';
        testConfig.Version__c = generateRandomString(versionLength);
        testConfig.Sender_Id__c = generateRandomString(idLength);
        testConfig.Receiver_Id__c = generateRandomString(idLength);
        insert testConfig;
    }//end createAzureConfig
    
    public static Azure_Config__c getAzureConfig(String configName) {
        return [Select Name
               From Azure_Config__c
               Where Name =: configName];
    }//getAzureConfig
    
    public static String generateCurrentTimePlusMinutes(Integer minsToAdd) {
        DateTime runTime = System.now(); 
        runTime = runTime.addMinutes(minsToAdd); 
        
        // Generate string to use when scheduling job.
        String schedule = String.valueOf(runTime.second());
        schedule += ' ' + String.valueOf(runTime.minute());
        schedule += ' ' + String.valueOf(runTime.hour());
        schedule += ' ' + String.valueOf(runTime.day());
        schedule += ' ' + String.valueOf(runTime.month());
        schedule += ' ? ';
        schedule += String.valueOf(runTime.year());
        return schedule;
    }//end generateCurrentTimePlusMinutes
    
    public static String generateCurrentTimePlusSeconds(Integer secsToAdd) {
        DateTime runTime = System.now(); 
        runTime = runTime.addSeconds(secsToAdd);
        
        // Generate string necessary for scheduling job.
        String schedule = String.valueOf(runTime.second());
        schedule += ' ' + String.valueOf(runTime.minute());
        schedule += ' ' + String.valueOf(runTime.hour());
        schedule += ' ' + String.valueOf(runTime.day());
        schedule += ' ' + String.valueOf(runTime.month());
        schedule += ' ? ';
        schedule += String.valueOf(runTime.year());
        return schedule;
    }//end generateCurrentTimePlusSeconds
}//end AzureObjectUtilityity