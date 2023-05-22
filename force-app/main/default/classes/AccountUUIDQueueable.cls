/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 22/05/2023
 * @description Sets Account.AccountNumber to a UUID. Handles one Account per execution
 */

public class AccountUUIDQueueable implements Queueable {

    private List<Account> theAccounts;

    public AccountUUIDQueueable(List<Account> theAccounts) {
        this.theAccounts = theAccounts.deepClone(true, true);
    }

    public void execute(QueueableContext qc) {
        Account thisAccount  = theAccounts.remove(0);

        thisAccount.AccountNumber = new UUIDGenerator().next();

        update thisAccount;

        if(!theAccounts.isEmpty()) {
            System.enqueueJob(this);
        }
    }
}