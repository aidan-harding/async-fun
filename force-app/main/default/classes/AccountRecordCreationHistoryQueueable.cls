/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 17/05/2023
 * @description Creates a Record_Creation_History__c history for an inserted Account. Handles one Account per invocation
 */

public without sharing class AccountRecordCreationHistoryQueueable extends AccountQueueableHandler {

    public AccountRecordCreationHistoryQueueable(Set<Id> accountIds) {
        super(accountIds);
    }

    public void execute(Account thisAccount) {
        insert new Record_Creation_History__c(
                Record_Id__c = thisAccount.Id,
                Account__c = thisAccount.Id,
                Record_Created_By__c = thisAccount.CreatedById,
                Record_Created_Date__c = thisAccount.CreatedDate
        );

        thisAccount.Apex_Record_Creation_History_Status__c = 'Complete';
        update thisAccount;
    }
}