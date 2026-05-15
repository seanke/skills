[CmdletBinding()]
param(
    [string]$Organization,
    [string]$Project,
    [string]$Repository,
    [string]$RemoteUrl,
    [Parameter(Mandatory = $true)]
    [string]$SourceBranch,
    [Parameter(Mandatory = $true)]
    [string]$TargetBranch,
    [Parameter(Mandatory = $true)]
    [string]$Title,
    [string]$Description,
    [string]$DescriptionFile,
    [string[]]$ReviewerIds,
    [bool]$SupportsIterations = $true,
    [switch]$DryRun,
    [switch]$ConfirmLiveWrite,
    [ValidateSet('Auto', 'Pat', 'Bearer', 'GitCredential')]
    [string]$AuthMode = 'Auto'
)

Set-StrictMode -Version Latest
. (Join-Path $PSScriptRoot 'AdoPr.Common.ps1')

$context = Resolve-AdoContext -Organization $Organization -Project $Project -Repository $Repository -RemoteUrl $RemoteUrl
$repositoryPath = Get-AdoRepositoryPath -Context $context
$descriptionText = Resolve-AdoTextInput -Text $Description -Path $DescriptionFile -Name 'Description'

$body = [ordered]@{
    sourceRefName = ConvertTo-AdoRefName -Branch $SourceBranch
    targetRefName = ConvertTo-AdoRefName -Branch $TargetBranch
    title         = $Title
    description   = $descriptionText
    isDraft       = $true
}

if ($null -ne $ReviewerIds -and $ReviewerIds.Count -gt 0) {
    $body.reviewers = @($ReviewerIds | ForEach-Object { @{ id = $_ } })
}

$url = New-AdoApiUrl -Context $context -Path "$repositoryPath/pullrequests" -Query @{ supportsIterations = $SupportsIterations }

if ($DryRun.IsPresent) {
    New-AdoDryRun -Method POST -Url $url -Body $body | Write-AdoJson
    return
}

if (-not $ConfirmLiveWrite.IsPresent) {
    throw 'Creating a pull request is a live write. Rerun with -DryRun first, then use -ConfirmLiveWrite when the request is correct.'
}

$pullRequest = Invoke-AdoRest -Method POST -Url $url -Body $body -AuthMode $AuthMode -Context $context
$pullRequest = Add-AdoPullRequestWebUrl -InputObject $pullRequest -Context $context
$pullRequestId = Get-AdoObjectPropertyValue -InputObject $pullRequest -Name 'pullRequestId'

if ($null -ne $pullRequestId) {
    $verifyUrl = New-AdoApiUrl -Context $context -Path "$repositoryPath/pullrequests/$pullRequestId"
    $verifiedPullRequest = Invoke-AdoRest -Method GET -Url $verifyUrl -AuthMode $AuthMode -Context $context
    $verifiedPullRequest = Add-AdoPullRequestWebUrl -InputObject $verifiedPullRequest -Context $context -PullRequestId ([int]$pullRequestId)
    Assert-AdoPullRequestDraft -PullRequest $verifiedPullRequest -Context $context -PullRequestId ([int]$pullRequestId)
    $verifiedPullRequest | Write-AdoJson
    return
}

Assert-AdoPullRequestDraft -PullRequest $pullRequest -Context $context
$pullRequest | Write-AdoJson
