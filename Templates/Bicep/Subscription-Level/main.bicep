targetScope = 'subscription'

@description('The location where the policy assignment will be created.')
param location string

@description('Create remediation task for non-compliant resources?')
param createRemediationTask bool = true

param policyName string = 'Enforce-EventHub-TLS-1.2'
param policyDisplayName string = 'Enforce TLS 1.2 for Event Hub Namespaces'
param policyDescription string = 'This policy ensures that Event Hub namespaces have a minimum TLS version of 1.2.'
param policyCategory string = 'Security'

// Create the Policy Definition
resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: policyName
  properties: {
    displayName: policyDisplayName
    description: policyDescription
    policyType: 'Custom'
    mode: 'All'
    metadata: {
      category: policyCategory
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.EventHub/namespaces'
          }
          {
            anyOf: [
              {
                field: 'Microsoft.EventHub/namespaces/minimumTlsVersion'
                equals: '1.0'
              }
              {
                field: 'Microsoft.EventHub/namespaces/minimumTlsVersion'
                equals: '1.1'
              }
            ]
          }
        ]
      }
      then: {
        effect: 'modify'
        details: {
          roleDefinitionIds: [
            '/providers/Microsoft.Authorization/roleDefinitions/f526a384-b230-433a-b45c-95f59c4a2dec' // Azure Event Hubs Data Owner
          ]
          operations: [
            {
              operation: 'addOrReplace'
              field: 'Microsoft.EventHub/namespaces/minimumTlsVersion'
              value: '1.2'
            }
          ]
        }
      }
    }
    parameters: {}
  }
}

// Assign the Policy with System Assigned Identity
resource policyAssignment 'Microsoft.Authorization/policyAssignments@2025-01-01' = {
  name: '${policyName}-assignment'
  location: location
  scope: subscription()
  properties: {
    displayName: policyDisplayName
    description: 'Ensures that Event Hub namespaces enforce TLS 1.2.'
    policyDefinitionId: policyDefinition.id
    enforcementMode: 'Default'
  }
  identity: {
    type: 'SystemAssigned'
  }
}

// Assign the Role to the Policy Assignment's Managed Identity
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id, policyAssignment.name) // Unique role assignment name
  scope: subscription() // Assign at subscription level
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'f526a384-b230-433a-b45c-95f59c4a2dec'
    ) // Azure Event Hubs Data Owner
    principalId: policyAssignment.identity.principalId // Managed identity of the policy assignment resource
    principalType: 'ServicePrincipal'
  }
}

// Create the Remediation Task for Non-Compliant Resources if createRemediationTask is true
resource remediationTask 'Microsoft.PolicyInsights/remediations@2021-10-01' = if (createRemediationTask) {
  name: 'remediate-eventhub-tls'
  scope: subscription()
  properties: {
    policyAssignmentId: policyAssignment.id
    resourceDiscoveryMode: 'ReEvaluateCompliance'
    failureThreshold: { percentage: 0 }
  }
}
