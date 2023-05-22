/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 17/05/2023
 */

trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    new nebc.MetadataTriggerManager(Account.SObjectType).handle();
}