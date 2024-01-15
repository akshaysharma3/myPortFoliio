/**
 ==================================================================
 * @description       : This is Handler class for OpportunityTrigger.
 * Created By         : Akshay Sharma 
 * Class Name         : OpportunityTriggerHandler
 * Test Class         : OpportunityTriggerHandlerTest
 * Modifications Log 
 * Ver   Date         Author          Modification
 *
 ==================================================================
**/
public class OpportunityTriggerHandler {
    public static void beforeInsert(List<Opportunity> newList){
        
    }
    public static void beforeUpdate(List<Opportunity> newList){
        
    }
    public static void afterInsert(List<Opportunity> newList){
        
    }
    public static void afterUpdate(List<Opportunity> newList, Map<Id, Opportunity> oldOppMap){
        updateExchangeRates(newList, oldOppMap);
    }
    
    
    public static void updateExchangeRates(List<Opportunity> newOppList, Map<Id, Opportunity> oldOppMap){
        for(Opportunity opp : newOppList){
            if(opp.CurrencyIsoCode != oldOppMap.get(opp.Id).CurrencyISOCode){
                System.debug('opp.CurrencyISOCode'+opp.CurrencyISOCode);
                CurrencyExchangeController.updateCurrencyExchangeRates(opp.CurrencyISOCode);
            }
        }
    }  
}