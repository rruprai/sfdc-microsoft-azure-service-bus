/*
 * Wrapper classes to serve as a way to store the values that are being sent with the request.
 * Replace all fields with a descriptive name that are needed for your request.
 */ 
public with sharing class AzureBody {
    public String objectName;
    
    public AzureBody(String name) {
        // At least have a default value. 
        objectName = name;
    }//end AzureBody
    
    public AzureBody() {
        // At least have a default value. 
        objectName = '';
    }//end AzureBody
}//end AzureBody