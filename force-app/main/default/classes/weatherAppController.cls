/**
 * @description       : 
 * @author            : Akshay Sharma
 * @group             : 
 * @last modified on  : 12-10-2023
 * @last modified by  : Akshay Sharma
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   12-10-2023   Akshay Sharma   Initial Version
**/
public with sharing class weatherAppController {

   @AuraEnabled 
   public static string getWeatherDetails(String input){
    String url = 'https://api.openweathermap.org/data/2.5/weather?q=' + input + '&units=metric' + getKey();
    String response = getResponse(url);
    return response;
   }
   public static String getResponse(String strUrl){
    Http h  = new Http();
    HttpRequest req = new HttpRequest();
    HttpResponse res = new HttpResponse();
    req.setMethod('GET');
    req.setEndpoint(strUrl);
    req.setTimeout(120000);
    res = h.send(req);
    String responseBody = res.getBody();
    return responseBody;
   }
   /**
   * @description : Get Api Key
   * @author Akshay Sharma | 12-10-2023 
   * @return String 
   **/
   public static String getKey(){
    String key = '55cdfffd9a497e0ceb696883c45f26e3'; // System.Label.WeatherApiKey
    String output = '&appid=' + key;
    return output;
   }
}