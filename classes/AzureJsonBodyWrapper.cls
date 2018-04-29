/*
 * Rather then putting it in a classes, wrapper class was created to make it more extensible. 
 * Helpful link: https://json2apex.herokuapp.com/.
 * Based on the body that needs to be sent, this should be updated using helpful link.
 * This is different from AzureBodyWrapper, which stores the Account information so that it can be inserted
 * into a JSON array to send multiple Accounts at once. 
 */ 
public class AzureJsonBodyWrapper {
    public String version;
    public String senderId;
    public String receiverId;
    public AzureBody body; 
    
    public AzureJsonBodyWrapper() {
        senderId = '';
        receiverId = '';
        version = '1';
        body = new AzureBody(); 
    }//end AzureJsonBodyWrapper
     
    public static AzureJsonBodyWrapper parse(String json) {
        return (AzureJsonBodyWrapper)System.JSON.deserialize(json, AzureJsonBodyWrapper.class);
    }//end parse
}//end AzureJsonBodyWrapper