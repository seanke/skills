# Azure Pipelines Modular Patterns

## Template Structure

- Root: `azure-pipelines.yml`
- Job templates: `jobs/template-jobs-*.yml`
- Step templates: `steps/template-steps-*.yml`
- Component templates: `<component>/template-steps-*.yml`

Organize templates under a single folder (e.g., `cicd/`) or keep them next to the component if that is the existing convention.

## Root Pipeline Pattern

- Define triggers and global variables.
- Orchestrate stages with `dependsOn` and branch gates.
- Use template jobs for repeated deployment logic.

Example (generic skeleton):

```yaml
trigger:
  branches:
    include:
      - main

pool:
  vmImage: ubuntu-latest

stages:
- stage: Build
  displayName: Build and Test
  jobs:
  - template: jobs/template-jobs-prepare.yml
  - job: BuildComponentA
    steps:
    - template: component-a/template-steps-build.yml
      parameters:
        workingDirectory: $(System.DefaultWorkingDirectory)/apps/component-a

- stage: DeployDev
  dependsOn: Build
  jobs:
  - template: jobs/template-jobs-deploy.yml
    parameters:
      environment: dev
      serviceConnectionName: SERVICE-CONNECTION-DEV

- ${{ if eq(variables['Build.SourceBranchName'], 'main') }}:
  - stage: DeployProd
    dependsOn: DeployDev
    jobs:
    - template: jobs/template-jobs-deploy.yml
      parameters:
        environment: prod
        serviceConnectionName: SERVICE-CONNECTION-PROD
```

## Job Template Pattern

- Accept environment parameters and service connection names.
- Use `deployment` jobs for environment-scoped deploys.
- Gate additional jobs with template expressions.

Example (generic skeleton):

```yaml
parameters:
- name: environment
  type: string
- name: serviceConnectionName
  type: string

jobs:
- deployment: DeployTo${{ upper(parameters.environment) }}
  displayName: Deploy to ${{ upper(parameters.environment) }}
  environment: ${{ parameters.environment }}
  strategy:
    runOnce:
      deploy:
        steps:
        - checkout: self
        - template: ../steps/template-steps-deploy.yml
          parameters:
            environment: ${{ parameters.environment }}
            serviceConnectionName: ${{ parameters.serviceConnectionName }}
```

## Step Template Pattern

- Use parameters for working directory, build configuration, and target artifacts.
- Keep tool installs and setup steps here, not in the root pipeline.

Example (generic skeleton):

```yaml
parameters:
- name: workingDirectory
  type: string

steps:
- task: DotNetCoreCLI@2
  displayName: Restore
  inputs:
    command: restore
    projects: ${{ parameters.workingDirectory }}/src/**/*.csproj

- task: DotNetCoreCLI@2
  displayName: Build
  inputs:
    command: build
    projects: ${{ parameters.workingDirectory }}/src/**/*.csproj
```

## Generic Naming Guidance

- Use neutral names like `component-a`, `serviceConnectionName`, `environment`.
- Keep environment labels short (`dev`, `uat`, `perf`, `prod`).
- Avoid embedding organization names in template file names.

## Checks

- Templates resolve correctly from the root pipeline.
- Parameters are provided wherever required.
- Secrets are sourced from variable groups or service connections.
