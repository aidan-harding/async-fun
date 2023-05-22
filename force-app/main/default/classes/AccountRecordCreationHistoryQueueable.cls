/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 17/05/2023
 * @description Creates a Record_Creation_History__c history for an inserted Account. Handles one Account per invocation
 */

public without sharing class AccountRecordCreationHistoryQueueable implements Queueable {

    private List<Account> theAccounts;

    public AccountRecordCreationHistoryQueueable(List<Account> theAccounts) {
        this.theAccounts = theAccounts.deepClone(true, true);
    }

    public void execute(QueueableContext qc) {
        Account thisAccount  = theAccounts.remove(0);

        insert (Record_Creation_History__c)AccountRecordCreationHistory.accountToRecordCreationHistory.call(thisAccount);

        if(!theAccounts.isEmpty()) {
            System.enqueueJob(this);
        }
    }
}