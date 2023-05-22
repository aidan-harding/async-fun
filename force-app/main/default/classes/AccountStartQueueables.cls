/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 22/05/2023
 * @description When Automation_Type__c = 'Asynchronous Apex', starts the Account Queueables
 */

global without sharing class AccountStartQueueables implements nebc.AfterInsert {

    global void handleAfterInsert(List<Account> newList) {
        List<Account> queueableAccounts = new nebc.LazySObjectIterator(newList)
                .filterOnField(Account.Automation_Type__c, 'Asynchronous Apex')
                .toList();

        if(!queueableAccounts.isEmpty()) {
            System.enqueueJob(new AccountRecordCreationHistoryQueueable(queueableAccounts), 0);
            System.enqueueJob(new AccountUUIDQueueable(queueableAccounts), 0);
        }
    }
}