[CmdletBinding()]
param(
    [string]$Organization,
    [string]$Project,
    [string]$Repository,
    [string]$RemoteUrl,
    [Parameter(Mandatory = $true)]
    [int]$PullRequestId,
    [Parameter(Mandatory = $true)]
    [int]$ThreadId,
    [Parameter(Mandatory = $true)]
    [ValidateSet('active', 'fixed', 'wontFix', 'closed', 'byDesign', 'pending')]
    [string]$Status,
    [switch]$DryRun,
    [switch]$ConfirmLiveWrite,
    [ValidateSet('Auto', 'Pat', 'Bearer', 'GitCredential')]
    [string]$AuthMode = 'Auto'
)

Set-StrictMode -Version Latest
. (Join-Path $PSScriptRoot 'AdoPr.Common.ps1')

$context = Resolve-AdoContext -Organization $Organization -Project $Project -Repository $Repository -RemoteUrl $RemoteUrl
$repositoryPath = Get-AdoRepositoryPath -Context $context
$body = [ordered]@{
    status = $Status
}
$url = New-AdoApiUrl -Context $context -Path "$repositoryPath/pullRequests/$PullRequestId/threads/$ThreadId"
$pullRequestWebUrl = New-AdoPullRequestWebUrl -Context $context -PullRequestId $PullRequestId

if ($DryRun.IsPresent) {
    New-AdoDryRun -Method PATCH -Url $url -Body $body -PullRequestWebUrl $pullRequestWebUrl | Write-AdoJson
    return
}

if (-not $ConfirmLiveWrite.IsPresent) {
    throw 'Updating a pull request thread is a live write. Rerun with -DryRun first, then use -ConfirmLiveWrite when the request is correct.'
}

$thread = Invoke-AdoRest -Method PATCH -Url $url -Body $body -AuthMode $AuthMode -Context $context
Add-AdoPullRequestWebUrl -InputObject $thread -Context $context -PullRequestId $PullRequestId | Write-AdoJson
