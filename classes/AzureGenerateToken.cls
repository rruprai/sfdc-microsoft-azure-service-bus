/*
 * Token necessary to send and receive messages between Salesforce and Azure Application.
 * This is the most important, all other classes should be seen more as a way to support this one. 
 * Helpful link: https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-sas
 */ 

public with sharing class AzureGenerateToken {
    // Given the nature of the token, these are private and require getters to obtain. 
    private static String sasSignatureName;
    private static String sha256DigAlg;
    private static String hmacSha256MacAlgo;
    private static String urlEncodingScheme;
    private static String queueName;
    
    public AzureGenerateToken(String queueNm) {
        // May need to update to SHA-512 in the future.
        sasSignatureName = 'SharedAccessSignature';
        sha256DigAlg = 'SHA-256';
        hmacSha256MacAlgo = 'hmacSHA256';
        urlEncodingScheme = 'UTF-8';
        queueName = queueNm;  
    }//end AzureGenerateToken
    
    public static String generateSasToken(String resourceUri, String keyName, String key, Integer duration) {
        String token = sasSignatureName;
        String stringToSign = '';
        String newLine = '\n';
        
        //sasToken should be generated in seconds. 
        Long expiry = getEpochTime(duration, true);
        String encodedResourceUri = EncodingUtil.urlEncode(resourceUri, urlEncodingScheme);
        encodedResourceUri = encodedResourceUri.toLowerCase();
        stringToSign = encodedResourceUri + newLine + expiry;
        
        Blob encodedKey = Crypto.generateDigest(sha256DigAlg, Blob.valueOf(key));
        String signature = EncodingUtil.base64Encode(Crypto.generateMac(hmacSha256MacAlgo, Blob.valueOf(stringToSign), Blob.valueOf(key)));
        String encodedSignature = EncodingUtil.urlEncode(signature, urlEncodingScheme);
        
        token += ' sr=' + encodedResourceUri;
        token += '&sig=' + encodedSignature;
        token += '&se=' + expiry;
        token += '&skn=' + keyName;
        return token;
    }//end generateSasToken
    
    public static Long getEpochTime(Integer secondsToAdd, Boolean inSeconds) {
        // If needed in seconds then divide by 1000. 
        DateTime curTime = System.now();
        Long currentGmtTime = null;
        curTime = curTime.addSeconds(secondsToAdd);
        Long currentGmtInMillSecs = curTime.getTime();
        
        if(!inSeconds) 
        	currentGmtTime = currentGmtInMillSecs;
        else
            currentGmtTime = currentGmtInMillSecs / 1000;
        
        return currentGmtTime;
    }//end getEpochTime
}//end AzureGenerateToken