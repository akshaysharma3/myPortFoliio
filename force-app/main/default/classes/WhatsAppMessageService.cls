/**
 * @description       : 
 * @author            : Akshay Sharma
 * @group             : 
 * @last modified on  : 11-02-2021
 * @last modified by  : Akshay Sharma
**/
public class WhatsAppMessageService {
    @AuraEnabled
    public static Boolean sendMessage(string mobileno,string message)
    {
        Boolean isSuccess = false;
        ErrorResponseWrapper erw;
        final String fromNumber = '+14155238886'; 
        String account = 'ACc5db3ced62ced507513ef5807d05a742';  
        String token   = '0cd04dfc1b36f0c7748bd2de0517bde5';
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.twilio.com/2010-04-01/Accounts/'+account+'/Messages.json');
        req.setMethod('POST'); 
        req.setHeader('Content-Type','application/json');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        
        Blob headerValue = Blob.valueOf(account + ':' + token);
        String authorizationHeader = 'BASIC ' +
            EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        
        
        if(mobileno != null)
        {
            string jsonString='From='+EncodingUtil.urlEncode('whatsapp:+14155238886', 'UTF-8')+'&Body='+EncodingUtil.urlEncode(message, 'UTF-8')+'&To='+EncodingUtil.urlEncode('whatsapp:'+mobileno+'', 'UTF-8')+'';
            req.setBody(jsonString);
            try{
                Http http = new Http();
                HTTPResponse res = http.send(req);
                System.debug(res.getBody());
                if(res.getStatusCode()==201){
                    isSuccess = true;
                    System.debug('Result ::>> '+res.getBody());
                    system.debug('Twilio Success'+mobileno);
                }  
                else{
                    system.debug('Twilio failed'+mobileno);
                    erw =(ErrorResponseWrapper)json.deserialize(res.getBody(),ErrorResponseWrapper.class);
                    system.debug('Twilio error'+erw.message);
                    isSuccess = false;
                }
            }
            catch(Exception e){
                system.debug('Error :'+e);
                isSuccess = false;
            } 
            //return isSuccess;
        }
        return isSuccess;
    }
    public class ErrorResponseWrapper{
        String code;
        String message;
        String moreInfo;
        String status;    
    }
}