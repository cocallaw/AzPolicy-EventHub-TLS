using './main.bicep'

param location = 'northeurope'
param createRemediationTask = true
param policyName = 'Enforce-EventHub-TLS-1.2'
param policyDisplayName = 'Enforce TLS 1.2 for Event Hub Namespaces'
param policyDescription = 'This policy ensures that Event Hub namespaces have a minimum TLS version of 1.2.'
param policyCategory = 'Security'
