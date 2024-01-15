/**
 ==================================================================
 * @description       : This is Controller class for CurrencyExchangeLwc Component.
 * Created By         : Akshay Sharma 
 * Class Name         : CurrencyExchangeController
 * Test Class         : CurrencyExchangeControllerTest
 * Modifications Log 
 * Ver   Date         Author          Modification
 *
 ==================================================================
**/
public with sharing class CurrencyExchangeController {
    //Handler Method for refresh currency exchange rates.
    @AuraEnabled
    public static List<ResponseWrapper> getCurrencyExchangeRates(String fromSymbol){
        if(fromSymbol != null){
            System.debug('In First Method');
            System.debug('generateToSymbol()::>>'+generateToSymbol());
            CalloutParamsWrapper paramWrap = getCalloutParams(fromSymbol, generateToSymbol());
            Map<String, Object> response = makeCallout(paramWrap);
            System.debug('Response::>>'+response);
            if(response != null){
                List<ResponseWrapper> respWrapperList = new List<ResponseWrapper>();
                for(String symbol : response.keyset()){
                     ResponseWrapper wrapper = new ResponseWrapper();
                    wrapper.currencyCode = symbol;
                    wrapper.rate = (Decimal)response.get(symbol);
                    System.debug('wrapper'+wrapper);
                    respWrapperList.add(wrapper);
                }
                
                CurrencyExchangeRate__c exchangeRec = setCurrencyExchangeValues(response, fromSymbol);
                Database.update(exchangeRec,false);
                return respWrapperList;
            }
            return null;
        }
        return null;
    }
    
    //Method called from Opportunity Trigger
    @future(callout=true)
    public static void updateCurrencyExchangeRates(String fromSymbol){
        if(fromSymbol != null){
            CalloutParamsWrapper paramWrap = getCalloutParams(fromSymbol, generateToSymbol());
            Map<String, Object> response = makeCallout(paramWrap);
            
            System.debug('Response::>>'+response);
            if(response != null){
                CurrencyExchangeRate__c exchangeRec = setCurrencyExchangeValues(response, fromSymbol);
                Database.upsert(exchangeRec,false);
            }
        }
    }
    
    //Method to Make callout to external system.
    public static Map<String, Object> makeCallout(CalloutParamsWrapper paramWrap){
        try{
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(paramWrap.endpoint);
            request.setMethod(paramWrap.method);
            if((paramWrap.headerKey != '' || paramWrap.headerKey != null) && (paramWrap.headerValue != '' || paramWrap.headerValue != null)){
                request.setHeader(paramWrap.headerKey, paramWrap.headerValue);
            }
            
            HttpResponse res = http.send(request);
            if(res.getStatus() == 'OK'){
                System.debug('res.getBody'+res.toString());
                return (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            }
        } catch(Exception ex){
            throw new AuraHandledException('Some Error Occured, Please Contact Your Administrator'); 
        }
        return null;
    }
    
    public static String generateToSymbol(){
        String toSymbol = '';
        for(Currency_Field_Mapping__mdt mapping : [SELECT MasterLabel FROM Currency_Field_Mapping__mdt]){
            toSymbol+= mapping.MasterLabel + ',';
        }
        toSymbol = toSymbol.removeEnd(',');
        return toSymbol;
    }
    
    //Method to Set Latest Currency Exchange Values
    public static CurrencyExchangeRate__c setCurrencyExchangeValues(Map<String, Object> response, String fromSymbol){
        CurrencyExchangeRate__c exchangeRateRec = [SELECT USD__c, Id, Base_Currency__c, INR__c, BTC__c, XRP__c, ETH__c, BCH__c FROM CurrencyExchangeRate__c WITH SECURITY_ENFORCED LIMIT 1];
        
        System.debug('exchange rate before'+exchangeRateRec);
        for(Currency_Field_Mapping__mdt mapping : [SELECT MasterLabel, FieldApiName__c FROM Currency_Field_Mapping__mdt]){
            if(response.containsKey(mapping.MasterLabel)){
                exchangeRateRec.put(mapping.FieldApiName__c, (Decimal)response.get(mapping.MasterLabel));
            }
        }
        exchangeRateRec.Base_Currency__c = fromSymbol;
        System.debug('exchange rate after'+exchangeRateRec);
        return exchangeRateRec;
    }
    
    //Method to get Request Parameters Wrapper
    public static CalloutParamsWrapper getCalloutParams(String fromSymbol, String toSymbol){
        CryptoExchangeRateApi__c exchange = [SELECT Apikey__c, Endpoint__c FROM CryptoExchangeRateApi__c WITH SECURITY_ENFORCED LIMIT 1];
        
        CalloutParamsWrapper paramWrapper = new CalloutParamsWrapper();
        paramWrapper.endpoint = exchange.Endpoint__c+'?fsym='+fromSymbol+'&tsyms='+toSymbol;
        paramWrapper.headerKey = 'Authorization';
        paramWrapper.headerValue = 'Apikey '+exchange.Apikey__c;
        paramWrapper.method = 'GET';
        System.debug('paramWrapper:::>>'+paramWrapper);
        return paramWrapper;
    }
    
    //Wrapper to store Response
    public class ResponseWrapper{
        @AuraEnabled public String currencyCode{get;set;}
        @AuraEnabled public Decimal rate{get;set;}
    }
    
    //Wrapper to store request parameters
    public class CalloutParamsWrapper{
        public String endpoint{get;set;}
        public String headerKey{get;set;}
        public String headerValue{get;set;}
        public String method{get;set;}
    }
    
}