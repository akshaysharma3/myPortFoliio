/**
 ==================================================================
 * @description       : Test class for UpdateCurrencyExchangeSchedule.
 * Created By         : Akshay Sharma 
 * Class Name         : UpdateCurrencyExchangeScheduleTest
 * Modifications Log 
 * Ver   Date         Author          Modification
 *
 ==================================================================
**/
@isTest
public class UpdateCurrencyExchangeScheduleTest {
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
    static void testSchedule(){
        Test.setMock(HttpCalloutMock.class, new CurrencyExchangeControllerMock());
        Test.startTest();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Currency Exchange Schedule', sch, new UpdateCurrencyExchangeSchedule());
        Test.stopTest();
    }

}