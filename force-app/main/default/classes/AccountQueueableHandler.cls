/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 22/05/2023
 * @description Handles querying and iteration to simplify the Queueables that process Account records
 */

public abstract inherited sharing class AccountQueueableHandler implements Queueable {

    // Use a list here not an iterator because the iterator returned from a Set<Id> causes the Queueable to fail
    private List<Id> accountsToProcess;
    private Boolean queryForUpdate = false;

    public AccountQueueableHandler(Set<Id> accountsToProcess) {
        this.accountsToProcess = new List<Id>(accountsToProcess);
    }

    public AccountQueueableHandler setQueryForUpdate(Boolean queryForUpdate) {
        this.queryForUpdate = queryForUpdate == true; // null-safe
        return this;
    }

    public void execute(QueueableContext qc) {
        Id thisAccountId = accountsToProcess.remove(0);

        String query = 'SELECT Id, AccountNumber, CreatedById, CreatedDate,\n' +
                ' Apex_UUID_Status__c, Apex_Record_Creation_History_Status__c\n' +
                ' FROM Account\n' +
                ' WHERE Id = :thisAccountId';

        if(queryForUpdate) {
            query += '\n FOR UPDATE';
        }

        Account thisAccount = Database.query(query);

        execute(thisAccount.clone(true, true, true));

        if(!accountsToProcess.isEmpty()) {
            if(Test.isRunningTest()) {
                execute(qc);
            } else {
                System.enqueueJob(this, 0);
            }
        }
    }

    abstract void execute(Account theAccount);
}