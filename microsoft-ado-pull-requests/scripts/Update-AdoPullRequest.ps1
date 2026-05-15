[CmdletBinding()]
param(
    [string]$Organization,
    [string]$Project,
    [string]$Repository,
    [string]$RemoteUrl,
    [Parameter(Mandatory = $true)]
    [int]$PullRequestId,
    [string]$Title,
    [string]$Description,
    [string]$DescriptionFile,
    [ValidateSet('active', 'abandoned', 'completed')]
    [string]$Status,
    [string]$TargetBranch,
    [string]$AutoCompleteUserId,
    [string]$CompletionOptionsJson,
    [string]$CompletionOptionsFile,
    [string]$MergeOptionsJson,
    [string]$MergeOptionsFile,
    [switch]$DryRun,
    [switch]$ConfirmLiveWrite,
    [ValidateSet('Auto', 'Pat', 'Bearer', 'GitCredential')]
    [string]$AuthMode = 'Auto'
)

Set-StrictMode -Version Latest
. (Join-Path $PSScriptRoot 'AdoPr.Common.ps1')

$context = Resolve-AdoContext -Organization $Organization -Project $Project -Repository $Repository -RemoteUrl $RemoteUrl
$repositoryPath = Get-AdoRepositoryPath -Context $context
$body = [ordered]@{}

if ($PSBoundParameters.ContainsKey('Title')) {
    $body.title = $Title
}

if ($PSBoundParameters.ContainsKey('Description') -or $PSBoundParameters.ContainsKey('DescriptionFile')) {
    $body.description = Resolve-AdoTextInput -Text $Description -Path $DescriptionFile -Name 'Description'
}

if ($PSBoundParameters.ContainsKey('Status')) {
    $body.status = $Status
}

if (-not [string]::IsNullOrWhiteSpace($TargetBranch)) {
    $body.targetRefName = ConvertTo-AdoRefName -Branch $TargetBranch
}

if (-not [string]::IsNullOrWhiteSpace($AutoCompleteUserId)) {
    $body.autoCompleteSetBy = @{ id = $AutoCompleteUserId }
}

$completionOptions = ConvertFrom-AdoJsonText -Json $CompletionOptionsJson -Path $CompletionOptionsFile -Name 'CompletionOptions'
if ($null -ne $completionOptions) {
    $body.completionOptions = $completionOptions
}

$mergeOptions = ConvertFrom-AdoJsonText -Json $MergeOptionsJson -Path $MergeOptionsFile -Name 'MergeOptions'
if ($null -ne $mergeOptions) {
    $body.mergeOptions = $mergeOptions
}

if ($body.Count -eq 0) {
    throw 'No PR update fields were supplied.'
}

$url = New-AdoApiUrl -Context $context -Path "$repositoryPath/pullrequests/$PullRequestId"
$pullRequestWebUrl = New-AdoPullRequestWebUrl -Context $context -PullRequestId $PullRequestId

if ($DryRun.IsPresent) {
    New-AdoDryRun -Method PATCH -Url $url -Body $body -PullRequestWebUrl $pullRequestWebUrl | Write-AdoJson
    return
}

if (-not $ConfirmLiveWrite.IsPresent) {
    throw 'Updating a pull request is a live write. Rerun with -DryRun first, then use -ConfirmLiveWrite when the request is correct.'
}

$pullRequest = Invoke-AdoRest -Method PATCH -Url $url -Body $body -AuthMode $AuthMode -Context $context
Add-AdoPullRequestWebUrl -InputObject $pullRequest -Context $context -PullRequestId $PullRequestId | Write-AdoJson
