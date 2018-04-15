/*
 * Part of the message header and properties as described on 
 * https://docs.microsoft.com/en-us/rest/api/servicebus/message-headers-and-properties
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
        correlationId = '';
        deliveryCount = 0;
        enqueuedSequenceNumber = 0;
        enqueuedTimeUtc = '';
        label = '';
        lockToken = '';
        lockedUntilUtc = '';
        messageId = '';
        partitionKey = '';
        sequenceNumber = Long.valueOf('0');
        sessionId = '';
        state = '';
        timeToLive = Long.valueOf('0');
    }//end AzureBrokerProperties
    
    public static AzureBrokerProperties parse(String json) {
		return (AzureBrokerProperties) System.JSON.deserialize(json, AzureBrokerProperties.class);
	}//end parse
    
}//end AzureBrokerProperties