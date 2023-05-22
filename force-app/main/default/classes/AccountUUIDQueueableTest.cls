/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 22/05/2023
 */

@IsTest
private class AccountUUIDQueueableTest {

    static nebc.TestRecordSource testRecordSource = new nebc.TestRecordSource();

    @IsTest
    static void testBehavior() {
        Test.startTest();
        Account testAccount = (Account)testRecordSource.getRecord(Account.SObjectType)
                .put(Account.Automation_Type__c, 'Asynchronous Apex')
                .withInsert();
        Test.stopTest();

        testAccount = [SELECT AccountNumber FROM Account WHERE Id = :testAccount.Id];

        Assert.isNotNull(testAccount.AccountNumber);
    }
}