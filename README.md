# Azure Policy for Azure Event Hub minimumTlsVersion

## Summary

This example Azure Policy checks the minimumTlsVersion of an Azure Event Hub resource and if the minimumTlsVersion is set to 1.0 or 1.1, it updates the minimumTlsVersion to 1.2 using a modify operation.

## Remediation Permissions

The remediation task requires the following permissions to be assigned to the user or system  or service principal that will be executing the remediation task:

| Role Definition             | ID                                   |
|-----------------------------|--------------------------------------|
| Azure Event Hubs Data Owner | f526a384-b230-433a-b45c-95f59c4a2dec |  
| Resource Policy Contributor | 36243c78-bf99-498c-9df9-86d9f8d28608 |