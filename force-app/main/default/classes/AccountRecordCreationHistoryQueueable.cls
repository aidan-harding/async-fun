/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 17/05/2023
 * @description Creates a Record_Creation_History__c history for an inserted Account. Handles one Account per invocation
 */

public without sharing class AccountRecordCreationHistoryQueueable extends AccountQueueableHandler {

    public AccountRecordCreationHistoryQueueable(Set<Id> accountToProcess) {
        super(accountToProcess);
    }

    public void execute(Account thisAccount) {
        insert (Record_Creation_History__c)AccountRecordCreationHistory.accountToRecordCreationHistory.call(thisAccount);

        thisAccount.Apex_Record_Creation_History_Status__c = 'Complete';
        update thisAccount;
    }
}