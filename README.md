# Azure Policy for Azure Event Hub minimumTlsVersion

## Summary

This example Azure Policy checks the minimumTlsVersion of an Azure Event Hub resource and if the minimumTlsVersion is set to 1.0 or 1.1, it updates the minimumTlsVersion to 1.2 using a modify operation.

## Remediation Permissions

For remediation the following role needs to be assigned to the user or system assigned managed identity that will be executing the remediation task:

| Role Definition             | ID                                   |
|-----------------------------|--------------------------------------|
| Azure Event Hubs Data Owner | f526a384-b230-433a-b45c-95f59c4a2dec |  