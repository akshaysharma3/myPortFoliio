/**
 ==================================================================
 * @description       : This is Mock class for fake callout Response.
 * Created By         : Akshay Sharma 
 * Class Name         : CurrencyExchangeControllerMock
 * Modifications Log 
 * Ver   Date         Author          Modification
 *
 ==================================================================
**/
@isTest
global class CurrencyExchangeControllerMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req){
        
    	System.assertEquals('GET', req.getMethod(), 'Check Request Method');
        HttpResponse response = new HttpResponse();
        response.setBody('{"USD":1,"JPY":106.6,"EUR":0.8313,"INR":80.84,"XRP":2.41,"BCH":0.002194,"ETH":0.0007333,"BTC":0.0000222}');
        response.setStatus('OK');
        response.setStatusCode(200);
        return response;
    }
}