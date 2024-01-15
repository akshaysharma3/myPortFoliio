/**
 * @description       : 
 * @author            : Akshay Sharma
 * @group             : 
 * @last modified on  : 07-19-2021
 * @last modified by  : Akshay Sharma
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   07-19-2021   Akshay Sharma   Initial Version
**/
public class AccountOpportunitiesController {
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunities(String accId){
        try {
            return [SELECT Id FROM Opportunity Where AccountId =:accId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}