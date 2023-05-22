/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 17/05/2023
 */

@IsTest
private class AccountRecordCreationHistoryTest {

    static nebc.TestRecordSource testRecordSource = new nebc.TestRecordSource();

    @IsTest
    static void testBehavior() {
        Account testAccount = (Account)testRecordSource.getRecord(Account.SObjectType)
                .put(Account.Automation_Type__c, 'Synchronous Apex')
                .withInsert();

        Record_Creation_History__c history = [
                SELECT Record_Id__c, Record_Created_By__c, Record_Created_Date__c
                FROM Record_Creation_History__c
        ];

        testAccount = [SELECT CreatedDate FROM Account WHERE Id = :testAccount.Id];

        Assert.areEqual(testAccount.Id, history.Record_Id__c);
        Assert.areEqual(testAccount.CreatedDate, history.Record_Created_Date__c);
        Assert.areEqual(UserInfo.getUserId(), history.Record_Created_By__c);
    }
}