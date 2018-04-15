/*
 * Utility class used to assist with AzureReceiver.
 * Important: getSasToken is used to get the necessary token to make the connection work.
 */ 
public with sharing class AzureReceiverUtility {
	// Make sure token is valid for a duration long enough that the request can be completed even if scheduled in the future.
    public static String getSasToken(String resourceUri, String keyName, String key, Integer duration) {
        AzureGenerateToken newSasToken = new AzureGenerateToken(keyName);
        return AzureGenerateToken.generateSasToken(resourceUri, keyName, key, duration); 
    }//end getSasToken
    
    public static Set<Integer> getHttpSuccessStatusCodes() {
        Set<Integer> httpResponseCodes = new Set<Integer>();
        httpResponseCodes.add(200);
        httpResponseCodes.add(201);
        return httpResponseCodes; 
    }//end getHttpSuccessStatusCodes
    
    public static Set<Integer> getHttpNoContentStatusCodes() {
        Set<Integer> httpNoContentCodes = new Set<Integer>();
        //more can be added depending upon the code.
        httpNoContentCodes.add(204);
        return httpNoContentCodes; 
    }//end getHttpNoContentStatusCodes
    
    public static Set<Integer> getHttpFailedStatusCode() {
        Set<Integer> httpFailedCodes = new Set<Integer>();
        httpFailedCodes.add(0);
        return httpFailedCodes; 
    }//end getHttpFailedStatusCode
    
    /*
     * We will use callout to ensure we can handle any edits that may be on going. 
     */ 
    @future(callout=true)
    public static void initiateAzureReceiver(String uri, String method, String resourceUri, String keyName, String key, Integer duration, String endPoint, String contentType, String contentLength, Integer maxCallouts) {
        HttpResponse readResponse = new HttpResponse();
        HttpResponse completeResponse = new HttpResponse();
        List<Azure_Message__c> messagesToInsert = new List<Azure_Message__c>();
        Azure_Message__c azureMsgToCreate = new Azure_Message__c();
        Set<Integer> httpSuccessCodes = getHttpSuccessStatusCodes();
        Set<Integer> httpNoContentCodes = getHttpNoContentStatusCodes();
        Set<Integer> httpFailedCodes = getHttpFailedStatusCode();
        Set<String> uniqueAdUserNames = new Set<String>();
        
        // Used to store values necessary for request.
        String sasToken = getSasToken(resourceUri, keyName, key, duration);
        Integer responseStatusCode = 0;
        String responseBody = '';
        String responseStatus = '';
        // Allow for receive and delete.
        String completeMethod = 'DELETE';
        String notCompleteMethod = 'PUT';
        String responseBrokerProps = '';
        String headerBrokerProperties = 'BrokerProperties';
        String objectName = '';
       	Integer requestTimeOut = 30000;
        
        // Initiate variables outside of loop once.
        AzureJsonBodyWrapper jsonParser = new AzureJsonBodyWrapper();
        AzureBody jsonBody = new AzureBody();
        AzureBrokerProperties brokerProperties = new AzureBrokerProperties();
        
        // Store error message in case we have an error for logging or email alerts.
        String body = '';
        
        for(Integer curCallout = 0; curCallout < maxCallouts; curCallout++) {
            readResponse = AzureReceiver.peekQueue(method, endPoint, sasToken, contentType, contentLength, requestTimeOut);
            // We want to loop until we reach the end of the queue and nothing is remaining.
            if(readResponse != null) {
                responseStatusCode = readResponse.getStatusCode();
                responseBody = readResponse.getBody();
                responseStatus = readResponse.getStatus();
                responseBrokerProps = readResponse.getHeader(headerBrokerProperties);
                
                //as long we can successfully connect
                if(httpSuccessCodes.contains(responseStatusCode)) {
                    jsonParser = AzureJsonBodyWrapper.parse(responseBody);
                    jsonBody = jsonParser.body;
                    objectName = jsonBody.objectName;
                    brokerProperties = AzureBrokerProperties.parse(responseBrokerProps);
                    uniqueAdUserNames.add(objectName);
                    // We will store the request object name from the body so that we can log what exactly we processed.
                    body += 'Object Name: ' + objectName + '<br>';
                    
                    completeResponse = AzureReceiver.markCompleteInQueue(completeMethod, endPoint, sasToken, brokerProperties.MessageId, brokerProperties.LockToken, requestTimeOut);
                    // As long we get a succesful complete response we want to create a single message to log activity.
                    if(httpSuccessCodes.contains(completeResponse.getStatusCode())) {
                        azureMsgToCreate = createSingleAzureMsg(responseBody, responseStatusCode, responseStatus);
                        messagesToInsert.add(azureMsgToCreate);    
                    }//end if httpSuccessCode completeResponse
                    
                }//end if httpSuccessCodes readResponse
                else if(httpNoContentCodes.contains(responseStatusCode)) {
                    //lets break from loop since no more content to be read
                    break;
                }//end else if
            }//end if response != null
            else {
                break;
            }
            
        }//end for
        
        // Only log if we have any items, which implies successful connection and requests.
        if(messagesToInsert.size() > 0) {
            try{
                insert messagesToInsert;
            }catch(DmlException dmlEx) { 
                //Send admins email alert with descriptive message, e.g. dmlEx.getMessage());
            } 
        }
    }//end initiateAzureReceiver
    
    public static Azure_Message__c createSingleAzureMsg(String responseBody, Integer responseStatusCode, String responseStatus) {
        Azure_Message__c azureMsg = new Azure_Message__c();
        azureMsg.Message__c = responseBody;
        azureMsg.Http_Response_Code__c = String.valueOf(responseStatusCode);
        azureMsg.HTTP_Response_Status__c = responseStatus;
        return azureMsg;
    }//end createSingleAzureMsg
}//end AzureReceiverUtility