[CmdletBinding()]
param(
    [string]$Organization,
    [string]$Project,
    [string]$Repository,
    [string]$RemoteUrl,
    [int]$PullRequestId,
    [ValidateSet('active', 'abandoned', 'completed', 'all')]
    [string]$Status = 'active',
    [int]$Top = 50,
    [string]$SourceBranch,
    [string]$TargetBranch,
    [switch]$IncludeThreads,
    [switch]$IncludeCommits,
    [switch]$IncludeWorkItems,
    [switch]$DryRun,
    [ValidateSet('Auto', 'Pat', 'Bearer', 'GitCredential')]
    [string]$AuthMode = 'Auto'
)

Set-StrictMode -Version Latest
. (Join-Path $PSScriptRoot 'AdoPr.Common.ps1')

$context = Resolve-AdoContext -Organization $Organization -Project $Project -Repository $Repository -RemoteUrl $RemoteUrl
$repositoryPath = Get-AdoRepositoryPath -Context $context

if ($PullRequestId -gt 0) {
    $pullRequestWebUrl = New-AdoPullRequestWebUrl -Context $context -PullRequestId $PullRequestId
    $query = @{}
    if ($IncludeCommits.IsPresent) { $query.includeCommits = $true }
    if ($IncludeWorkItems.IsPresent) { $query.includeWorkItemRefs = $true }

    $url = New-AdoApiUrl -Context $context -Path "$repositoryPath/pullrequests/$PullRequestId" -Query $query

    if ($IncludeThreads.IsPresent) {
        $threadsUrl = New-AdoApiUrl -Context $context -Path "$repositoryPath/pullRequests/$PullRequestId/threads"
        if ($DryRun.IsPresent) {
            [ordered]@{
                pullRequestWebUrl = $pullRequestWebUrl
                requests          = @(
                    (New-AdoDryRun -Method GET -Url $url -PullRequestWebUrl $pullRequestWebUrl),
                    (New-AdoDryRun -Method GET -Url $threadsUrl -PullRequestWebUrl $pullRequestWebUrl)
                )
            } | Write-AdoJson
            return
        }

        $pullRequest = Invoke-AdoRest -Method GET -Url $url -AuthMode $AuthMode -Context $context
        $threads = Invoke-AdoRest -Method GET -Url $threadsUrl -AuthMode $AuthMode -Context $context
        Add-AdoPullRequestWebUrl -InputObject $pullRequest -Context $context -PullRequestId $PullRequestId | Out-Null
        Add-AdoPullRequestWebUrl -InputObject $threads -Context $context -PullRequestId $PullRequestId | Out-Null

        [pscustomobject]@{
            pullRequestWebUrl = $pullRequestWebUrl
            pullRequest       = $pullRequest
            threads           = $threads
        } | Write-AdoJson
        return
    }

    if ($DryRun.IsPresent) {
        New-AdoDryRun -Method GET -Url $url -PullRequestWebUrl $pullRequestWebUrl | Write-AdoJson
        return
    }

    $pullRequest = Invoke-AdoRest -Method GET -Url $url -AuthMode $AuthMode -Context $context
    Add-AdoPullRequestWebUrl -InputObject $pullRequest -Context $context -PullRequestId $PullRequestId | Write-AdoJson
    return
}

$query = @{
    'searchCriteria.status' = $Status
    '$top'                  = $Top
}

if (-not [string]::IsNullOrWhiteSpace($SourceBranch)) {
    $query['searchCriteria.sourceRefName'] = ConvertTo-AdoRefName -Branch $SourceBranch
}

if (-not [string]::IsNullOrWhiteSpace($TargetBranch)) {
    $query['searchCriteria.targetRefName'] = ConvertTo-AdoRefName -Branch $TargetBranch
}

$listUrl = New-AdoApiUrl -Context $context -Path "$repositoryPath/pullrequests" -Query $query

if ($DryRun.IsPresent) {
    New-AdoDryRun -Method GET -Url $listUrl | Write-AdoJson
    return
}

$pullRequests = Invoke-AdoRest -Method GET -Url $listUrl -AuthMode $AuthMode -Context $context
Add-AdoPullRequestWebUrl -InputObject $pullRequests -Context $context | Write-AdoJson
