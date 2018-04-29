/*
 * Part of the message header and properties as described on 
 * https://docs.microsoft.com/en-us/rest/api/servicebus/message-headers-and-properties (sample data)
 * For different orgs, you may or may not need all the properties. 
 * Another constructor can be created where you pass in the values you need. 
 * Based on your json, this may or more not be valid, but you can https://json2apex.herokuapp.com/ to create another class.
 */ 
public with sharing class AzureBrokerProperties {
    public String correlationId;
    public Integer deliveryCount;
    public Integer enqueuedSequenceNumber;
    public String enqueuedTimeUtc;
    public String label;
    public String lockToken;
    public String lockedUntilUtc;
    public String messageId;
    public String partitionKey;
    public Long sequenceNumber;
    public String sessionId;
    public String state;
    public Long timeToLive;
    
    public AzureBrokerProperties() {
        // Set some defaults.
        correlationId = '{701332F3-B37B-4D29-AA0A-E367906C206E}';
        deliveryCount = 2;
        enqueuedSequenceNumber = 0;
        enqueuedTimeUtc = ' Sun, 06 Nov 1994 08:49:37 GMT';
        label = '';
        lockToken = AzureObjectUtility.generateRandomString(10);
        lockedUntilUtc = '';
        messageId = '{701332E1-B37B-4D29-AA0A-E367906C206E}';
        partitionKey = '';
        sequenceNumber = Long.valueOf('1234567890');
        sessionId = '{27729E1-B37B-4D29-AA0A-E367906C206E}';
        state = '';
        timeToLive = Long.valueOf('90');
    }//end AzureBrokerProperties
    
    public static AzureBrokerProperties parse(String json) {
		return (AzureBrokerProperties) System.JSON.deserialize(json, AzureBrokerProperties.class);
	}//end parse
    
}//end AzureBrokerProperties