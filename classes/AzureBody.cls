/*
 * Wrapper classes to serve as a way to store the values that are being sent with the request.
 * Replace all fields with a descriptive name that are needed for your request.
 */ 
public with sharing class AzureBody {
    public String objectName;
    
    public AzureBody() {
        // At least have a default value. 
        objectName = '';
    }//end AzureBody
}//end AzureBody