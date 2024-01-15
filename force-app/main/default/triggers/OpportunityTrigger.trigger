/**
 ==================================================================
 * @description       : Opportunity Trigger to handle pre and post update Operations
 * Created By         : Akshay Sharma 
 * Class Name         : OpportunityTrigger
 * Test Class         : OpportunityTriggerTest
 * Modifications Log 
 * Ver   Date         Author          Modification
 *
 ==================================================================
**/
trigger OpportunityTrigger on Opportunity (after insert, after update, before insert, before update) {
    
    switch on Trigger.operationType{
        when BEFORE_INSERT{
            OpportunityTriggerHandler.beforeInsert(Trigger.new);
        }
        when AFTER_INSERT{
            OpportunityTriggerHandler.afterInsert(Trigger.new);
        }
        when BEFORE_UPDATE{
            OpportunityTriggerHandler.beforeUpdate(Trigger.new);
        }
        when AFTER_UPDATE{
            OpportunityTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}