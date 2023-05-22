/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 22/05/2023
 * @description When Automation_Type__c = 'Asynchronous Apex', starts the Account Queueables
 */

global without sharing class AccountStartQueueables implements nebc.AfterInsert {

    global void handleAfterInsert(List<Account> newList) {
        Set<Id> recordCreationAccounts = new Set<Id>();
        Set<Id> uuidAccounts = new Set<Id>();

        for(Account thisAccount : newList) {
            if(thisAccount.Apex_Record_Creation_History_Status__c == 'Pending') {
                recordCreationAccounts.add(thisAccount.Id);
            }
            if(thisAccount.Apex_UUID_Status__c == 'Pending') {
                uuidAccounts.add(thisAccount.Id);
            }
        }

        if(!recordCreationAccounts.isEmpty()) {
            System.enqueueJob(new AccountRecordCreationHistoryQueueable(recordCreationAccounts), 0);
        }
        if(!uuidAccounts.isEmpty()) {
            System.enqueueJob(new AccountUUIDQueueable(uuidAccounts), 0);
        }
    }
}