/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 22/05/2023
 */

@IsTest
private class AccountUUIDQueueableTest {

    static nebc.TestRecordSource testRecordSource = new nebc.TestRecordSource();

    @IsTest
    static void testBehaviour() {
        Test.startTest();
        Account testAccount = (Account)testRecordSource.getRecord(Account.SObjectType)
                .put(Account.Automation_Type__c, 'Asynchronous Apex')
                .withInsert();
        Test.stopTest();

        testAccount = [SELECT AccountNumber, Apex_UUID_Status__c FROM Account WHERE Id = :testAccount.Id];

        Assert.isNotNull(testAccount.AccountNumber);
        Assert.areEqual('Complete', testAccount.Apex_UUID_Status__c);
    }

    @IsTest
    static void sixRecords() {
        Test.startTest();
        List<Account> testAccounts = testRecordSource.getRecord(Account.SObjectType)
                .put(Account.Automation_Type__c, 'Asynchronous Apex')
                .withInsert(6);
        Test.stopTest();

        testAccounts = [SELECT AccountNumber, Apex_UUID_Status__c FROM Account WHERE Id IN :testAccounts];

        for(Account testAccount : testAccounts) {
            Assert.isNotNull(testAccount.AccountNumber);
            Assert.areEqual('Complete', testAccount.Apex_UUID_Status__c);
        }
    }
}