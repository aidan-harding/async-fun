/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 22/05/2023
 * @description Handles querying and iteration to simplify the Queueables that process Account records
 */

public abstract inherited sharing class AccountQueueableHandler implements Queueable {

    // Use a list here not an iterator because the iterator returned from a Set<Id> d
    private List<Id> accountsToProcess;

    public AccountQueueableHandler(Set<Id> accountsToProcess) {
        this.accountsToProcess = new List<Id>(accountsToProcess);
    }

    public void execute(QueueableContext qc) {
        Id thisAccountId = accountsToProcess.remove(0);
        Account thisAccount = [
                SELECT Id, AccountNumber, CreatedById, CreatedDate,
                        Apex_UUID_Status__c, Apex_Record_Creation_History_Status__c
                FROM Account
                WHERE Id = :thisAccountId
        ];

        execute(thisAccount.clone(true, true, true));

        if(!accountsToProcess.isEmpty()) {
            if(Test.isRunningTest()) {
                execute(qc);
            } else {
                System.enqueueJob(this);
            }
        }
    }

    abstract void execute(Account theAccount);
}