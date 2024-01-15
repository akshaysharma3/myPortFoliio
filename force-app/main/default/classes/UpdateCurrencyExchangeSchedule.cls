/**
==================================================================
* @description       : This is Scheduler class to fetch Latest Currency Exchange Rates Every Night.
* Created By         : Akshay Sharma 
* Class Name         : UpdateCurrencyExchangeSchedule
* Test Class         : UpdateCurrencyExchangeScheduleTest
* Modifications Log 
* Ver   Date         Author          Modification
*
==================================================================
**/
global class UpdateCurrencyExchangeSchedule implements Schedulable {
    
    global void execute(SchedulableContext sc){
        CurrencyExchangeRate__c exchangeRateRec = [SELECT Base_Currency__c FROM CurrencyExchangeRate__c WITH SECURITY_ENFORCED LIMIT 1];
        CurrencyExchangeController.updateCurrencyExchangeRates(exchangeRateRec.Base_Currency__c);
    }
    
}