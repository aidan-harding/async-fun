/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 22/05/2023
 */

@IsTest
private class AccountRecordCreationHistoryQueueTest {

    static nebc.TestRecordSource testRecordSource = new nebc.TestRecordSource();

    @IsTest
    static void testBehaviour() {
        Test.startTest();
        Account testAccount = (Account)testRecordSource.getRecord(Account.SObjectType)
                .put(Account.Automation_Type__c, 'Asynchronous Apex')
                .withInsert();
        Test.stopTest();

        Record_Creation_History__c history = [
                SELECT Record_Id__c, Record_Created_By__c, Record_Created_Date__c
                FROM Record_Creation_History__c
        ];

        testAccount = [SELECT CreatedDate, Apex_Record_Creation_History_Status__c
        FROM Account WHERE Id = :testAccount.Id];

        Assert.areEqual(testAccount.Id, history.Record_Id__c);
        Assert.areEqual(testAccount.CreatedDate, history.Record_Created_Date__c);
        Assert.areEqual(UserInfo.getUserId(), history.Record_Created_By__c);
        Assert.areEqual('Complete', testAccount.Apex_Record_Creation_History_Status__c);
    }

    @IsTest
    static void sixRecords() {
        Test.startTest();
        List<Account> testAccounts = testRecordSource.getRecord(Account.SObjectType)
                .put(Account.Automation_Type__c, 'Asynchronous Apex')
                .withInsert(6);
        Test.stopTest();

        nebc.SObjectIndex histories = new nebc.SObjectIndex(Record_Creation_History__c.Record_Id__c)
                .putAll([
                        SELECT Record_Id__c, Record_Created_By__c, Record_Created_Date__c
                        FROM Record_Creation_History__c
                ]);

        testAccounts = [SELECT CreatedDate, Apex_Record_Creation_History_Status__c FROM Account WHERE Id IN :testAccounts];

        for(Account testAccount : testAccounts) {
            Record_Creation_History__c history = (Record_Creation_History__c)histories.get(testAccount.Id);
            Assert.areEqual(testAccount.Id, history.Record_Id__c);
            Assert.areEqual(testAccount.CreatedDate, history.Record_Created_Date__c);
            Assert.areEqual(UserInfo.getUserId(), history.Record_Created_By__c);
            Assert.areEqual('Complete', testAccount.Apex_Record_Creation_History_Status__c);
        }
    }
}