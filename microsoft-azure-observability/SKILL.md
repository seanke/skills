---
name: microsoft-azure-observability
description: "Azure observability guidance for Azure Monitor, Application Insights, Log Analytics, alerts, workbooks, metrics, APM, distributed tracing, and KQL-based investigations. Use when Codex needs to inspect or explain monitoring signals, choose the right Azure observability service, write or refine KQL queries for Azure Monitor or Log Analytics, troubleshoot alerting/reporting setups, or work with observability SDK references for Azure-hosted applications. Do not use for general Azure cost analysis, non-Azure Kusto clusters, or application instrumentation setup that belongs to a dedicated instrumentation skill."
---

# Azure Observability

## Goal
Use this skill for Azure monitoring, alerts, and KQL.

## Use When
Use Azure Monitor for platform metrics, alerts, and dashboards.

Use Application Insights for request tracing, exceptions, dependency timing, and distributed application diagnostics.

Use Log Analytics when the task is log-centric and requires KQL over workspace data.

Use workbooks when the user needs an interactive investigation or reporting surface that combines metrics, logs, and parameters.

Use alerting guidance when the user is configuring thresholds, action groups, incident routing, or signal-based automation.

### Common Tasks
For "Why is this app failing right now?": inspect Application Insights exceptions, failed requests, and dependency duration first; then widen to Log Analytics if cross-resource correlation is needed.

For "Write a KQL query": confirm the workspace or table family, constrain the time range, and keep the first query simple enough to validate the schema before optimizing.

For "Set up monitoring or alerts": separate data collection, alert condition, and notification routing; explain those as three distinct pieces instead of collapsing them into one step.

For "Which SDK/client should I use?": load only the matching language reference in `references/sdk/` and keep the answer scoped to the requested language and operation.

## Workflow
1. Identify the signal type first: metrics, traces, logs, alerts, or workbook/reporting.
2. Prefer MCP-backed Azure tools when they are available in the environment; otherwise fall back to Azure CLI guidance.
3. Scope the target resource clearly before querying anything: subscription, resource group, resource name, Application Insights component, or Log Analytics workspace.
4. For KQL tasks, start with a minimal time window and explicit tables, then expand only if the first pass is insufficient.
5. When the user is implementing SDK-based access or telemetry ingestion, read only the relevant file from `references/sdk/`.
6. When authentication is relevant, read `references/auth-best-practices.md` and prefer managed identity or workload identity guidance over secrets.

### Tool Preference
Prefer Azure MCP when available because it gives direct resource and query access without restating CLI syntax.

Use CLI examples only when the environment does not expose the required Azure MCP capability or when the user explicitly wants shell commands.

## References
Read `references/auth-best-practices.md` for environment-aware Azure authentication patterns and identity guidance.

Read the matching file in `references/sdk/` only when the task requires SDK details:

- `azure-monitor-opentelemetry-py.md`
- `azure-monitor-opentelemetry-ts.md`
- `azure-monitor-opentelemetry-exporter-py.md`
- `azure-monitor-query-py.md`
- `azure-monitor-query-java.md`
- `azure-monitor-ingestion-py.md`
- `azure-monitor-ingestion-java.md`
- `azure-mgmt-applicationinsights-dotnet.md`

Do not bulk-load every reference file. Choose the smallest relevant subset for the request.

## Notes
Do not use this skill for application code instrumentation if a dedicated App Insights instrumentation skill exists.

Do not use this skill for Azure Cost Management or budgeting tasks.

Do not use this skill for generic Kusto or Azure Data Explorer cluster work outside Azure Monitor and Log Analytics context.
