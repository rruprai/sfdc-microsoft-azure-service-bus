/*
 * This mainly contains two httpMethods: 
 * peekQueue is a way to receive the first message without deleting from the queue
 * receiveAndDeleteFromQueue is a way to receive and delete the message from the queue.
 * Helpful link: https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-performance-improvements
 * Helpful link: https://docs.microsoft.com/en-us/rest/api/servicebus/unlock-message
 */ 
public with sharing class AzureReceiver {   
    public static HttpResponse peekQueue(String httpMethod, String endPoint, String sasToken, String contentType, String contentLength, Integer timeOut) {
        HttpRequest readRequest = new HttpRequest();
        readRequest.setMethod(httpMethod);
        readRequest.setEndpoint(endPoint); 
        readRequest.setHeader('Authorization', sasToken);
        readRequest.setHeader('Content-Type', contentType);
        readRequest.setHeader('Content-Length', contentLength);
        // Set timeout to 30 seconds or something else as needed per application.
        readRequest.setTimeout(timeOut);
           
        Http sendHttpReq = new Http();
        HttpResponse response = new HttpResponse();
        try{
        	response = sendHttpReq.send(readRequest);     
        }catch(CalloutException calloutExc) {
            // Send admin emails example, Cause of error: +calloutExc.getCause();
            // If we are not able to receive message then set to null.
            response = null;
        }finally {
            // Send Admins email on completion or log activity.
        }
        return response;
    }//end peekQueue
    
    public static HttpResponse receiveAndDeleteFromQueue(String httpMethod, String endPoint, String sasToken, String messageId, String lockToken, Integer timeOut) {
        String endPointToUnlockMsg = endPoint.substring(0, endPoint.indexOf('head'));
        endPointToUnlockMsg += messageId;
        endPointToUnlockMsg += '/' + lockToken;
        HttpRequest completeRequest = new HttpRequest();
        completeRequest.setMethod(httpMethod);
        completeRequest.setEndpoint(endPointToUnlockMsg); 
        completeRequest.setHeader('Authorization', sasToken);
        completeRequest.setTimeout(timeOut);
         
        Http sendHttpReq = new Http();
        HttpResponse response = new HttpResponse();
        try{
        	response = sendHttpReq.send(completeRequest);     
        }catch(CalloutException calloutExc) {
            // Send admins email using calloutExc.getMessage()
            // Set response to null if not able to receive for troubleshooting and possible logging.
            response = null;
        }finally {
            // Send admins emails on completion or log activity.
        } 
        return response;
    }//end markCompleteInQueue
}//end AzureReceiver