/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 17/05/2023
 * @description Sets Account.AccountNumber to a UUID
 */

global without sharing class AccountUUID implements nebc.BeforeInsert {

    public void handleBeforeInsert(List<Account> newList) {
        new nebc.LazySObjectIterator(newList)
                .filterOnField(Account.Automation_Type__c, 'Synchronous Apex')
                .put(Account.AccountNumber, new nebc.LazyIterator(new UUIDGenerator()))
                .forEach();
    }
}