/**
 ==================================================================
 * @description       : This is Test class for OpportunityTriggerHandler.
 * Created By         : Akshay Sharma 
 * Class Name         : OpportunityTriggerHandlerTest
 * Modifications Log 
 * Ver   Date         Author          Modification
 *
 ==================================================================
**/
@isTest
public class OpportunityTriggerHandlerTest {
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
    static void testAfterUpdate(){
        Test.setMock(HttpCalloutMock.class, new CurrencyExchangeControllerMock());
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Oppp';
        opp.Amount = 150000;
        opp.CurrencyIsoCode = 'INR';
        opp.StageName = 'Prospecting';
        opp.CloseDate = system.today().addDays(3);
        
        insert opp;
        
        Test.startTest();
        opp.CurrencyIsoCode = 'USD';
        update opp;
        System.assertEquals('USD', opp.CurrencyIsoCode, 'Currency ISO Code Changed');
        Test.stopTest();

    }

}