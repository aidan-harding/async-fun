/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 22/05/2023
 * @description Sets the Async Apex Status fields (Apex_Record_Creation_History_Status__c and Apex_UUID_Status__c) to
 * pending if Automation_Type__c is 'Asynchronous Apex'
 */

global without sharing class AccountSetApexAsyncPending implements nebc.BeforeInsert {
    public void handleBeforeInsert(List<Account> newList) {
        new nebc.LazySObjectIterator(newList)
                .filterOnField(Account.Automation_Type__c, 'Asynchronous Apex')
                .put(Account.Apex_Record_Creation_History_Status__c, 'Pending')
                .put(Account.Apex_UUID_Status__c, 'Pending')
                .forEach();
    }
}