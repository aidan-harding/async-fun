/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 17/05/2023
 */

@IsTest
private class AccountUUIDTest {

    static nebc.TestRecordSource testRecordSource = new nebc.TestRecordSource();

    @IsTest
    static void testBehavior() {
        Integer numberOfRecords = 5;
        Set<String> uuids = new Set<String>();

        List<Account> accounts = testRecordSource.getRecord(Account.SObjectType)
                .put(Account.Automation_Type__c, 'Synchronous Apex')
                .withInsert(numberOfRecords);

        accounts = [SELECT AccountNumber FROM Account WHERE Id IN :accounts];

        for(Integer i=0; i < accounts.size(); i++) {
            Assert.isNotNull(accounts[i].AccountNumber, 'Failed on row ' + i);
            uuids.add(accounts[i].AccountNumber);
        }

        Assert.areEqual(numberOfRecords, uuids.size());
    }
}