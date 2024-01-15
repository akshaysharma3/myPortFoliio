@isTest
public class CurrencyExchangeControllerTest {
    @testSetup
    static void setupTestData(){
        CryptoExchangeRateApi__c apiDet = new CryptoExchangeRateApi__c();
        apiDet.Apikey__c = 'a8b9feee4ecc38eb44e478a614e9ae1c338b71baa0412330d313d049633c76c4';
        apiDet.Endpoint__c = 'https://min-api.cryptocompare.com/data/price';
        insert apiDet;
        
        CurrencyExchangeRate__c exchrec = new CurrencyExchangeRate__c();
        exchrec.Base_Currency__c = 'USD';
        insert exchrec;
    }
	@isTest
    static void testGetCurrencyExchangeRates(){
        Test.setMock(HttpCalloutMock.class, new CurrencyExchangeControllerMock());
        Test.startTest();
        List<CurrencyExchangeController.ResponseWrapper> responseList =  CurrencyExchangeController.getCurrencyExchangeRates('USD');
        Test.stopTest();
    }
}