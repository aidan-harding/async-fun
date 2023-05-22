/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 17/05/2023
 * @description Creates a Record_Creation_History__c history for an inserted Account
 */

global without sharing class AccountRecordCreationHistory implements nebc.AfterInsert {

    public static nebc.Function accountToRecordCreationHistory =
            new nebc.SObjectFromPrototype(new Record_Creation_History__c())
                    .putField(Record_Creation_History__c.Record_Id__c, Account.Id)
                    .putField(Record_Creation_History__c.Account__c, Account.Id)
                    .putField(Record_Creation_History__c.Record_Created_By__c, Account.CreatedById)
                    .putField(Record_Creation_History__c.Record_Created_Date__c, Account.CreatedDate);

    global void handleAfterInsert(List<Account> newList) {
        new nebc.LazySObjectIterator(newList)
                .filterOnField(Account.Automation_Type__c, 'Synchronous Apex')
                .mapValuesT(accountToRecordCreationHistory)
                .doInsert();
    }
}