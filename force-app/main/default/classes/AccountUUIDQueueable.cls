/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 22/05/2023
 * @description Sets Account.AccountNumber to a UUID. Handles one Account per execution
 */

public without sharing class AccountUUIDQueueable extends AccountQueueableHandler {

    public AccountUUIDQueueable(Set<Id> accountToProcess) {
        super(accountToProcess);
    }

    public void execute(Account thisAccount) {
        thisAccount.AccountNumber = new UUIDGenerator().next();
        thisAccount.Apex_UUID_Status__c = 'Complete';

        update thisAccount;
    }
}