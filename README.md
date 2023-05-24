# Async Fun

Example code for playing around with synchronous and asynchronous execution options in Salesforce. 

## Setup

You must install the packages [Nebula Core](https://github.com/aidan-harding/nebula-core) and 
[Apex UUID](https://github.com/jongpie/ApexUUID) before pushing the code to your scratch org. They are aliased 
in the [sfdx-project.json](sfdx-project.json) file.

See the respective repositories for details specific to each package.

## Overview

This code drives the examples in my London's Calling 2023 presentation 'Event driven: Don’t Fear the Async'.

The (somewhat artificial) scenario is that we want two things to happen when an Account is inserted

1. Set the AccountNumber to a UUID
2. Insert a log record (Record_Creation_History__c)

This repository includes solutions using

- Synchronous Apex
- Asynchronous Apex (Queueable)
- Asynchronous Flow

The choice of solution is determined by the Account.Automation_Type__c field.

## Running

You can run the Apex Tests, which ought to pass.

Since Apex Tests are no good at testing parallel behaviour, it's also good to test by running the code for real.

You can do that using Anonymous Apex and making use of the test record generator from Nebula Core. For example, you can 
test the Async Apex version with the following:

```apex
new nebc.TestRecordSource()
        .getRecord(Account.SObjectType)
        .put(Account.Automation_Type__c, 'Asynchronous Apex')
        .withInsert(6);
```

Obviously, you can change the `Automation_Type__c` to exercise different solutions.

Then query something like this:

```
SELECT AccountNumber, Apex_Record_Creation_History_Status__c, Apex_UUID_Status__c, CreatedDate, LastModifiedDate, (SELECT Id FROM Record_Creation_Histories__r LIMIT 1) FROM Account WHERE Automation_Type__c = 'Asynchronous Apex'
```

As downloaded from the repository, this should result in 4 successfully updated Accounts. The 5th fails in a scratch 
org due to reaching the maximum stack depth of a `Queueable` in that org type.

You can change whether or not `FOR UPDATE` is used by modifying a Custom Metadata record for the trigger handler 
framework [nebc__Trigger_Handler.AccountStartQueueables](force-app/main/default/customMetadata/nebc__Trigger_Handler.AccountStartQueueables.md-meta.xml):

The default value for the parameters field (i.e. using FOR UPDATE) is:
```json
{
  "queryForUpdate": true
}
```

You can change that to false and re-run the above Anonymous Apex test. You may see the behaviour from the presentation 
where some Accounts end up stuck in the status of Pending. Or it might work - async is tricky! Either way, the 
Apex Tests will pass.