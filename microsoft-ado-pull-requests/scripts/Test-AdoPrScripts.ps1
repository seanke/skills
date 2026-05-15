[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Assert-Equal {
    param(
        [object]$Actual,
        [object]$Expected,
        [string]$Name
    )

    if ($Actual -ne $Expected) {
        throw "Assertion failed for ${Name}: expected '$Expected', got '$Actual'."
    }
}

$scriptRoot = $PSScriptRoot
$scripts = Get-ChildItem -LiteralPath $scriptRoot -Filter '*.ps1' -File

foreach ($script in $scripts) {
    $tokens = $null
    $errors = $null
    [System.Management.Automation.Language.Parser]::ParseFile($script.FullName, [ref]$tokens, [ref]$errors) | Out-Null
    if ($errors.Count -gt 0) {
        $messages = $errors | ForEach-Object { $_.Message }
        throw "PowerShell parse failed for $($script.Name): $($messages -join '; ')"
    }
}

$context = @{
    Organization = 'fabrikam'
    Project      = 'Sample Project'
    Repository   = 'sample-repo'
    DryRun       = $true
}
$expectedPrUrl = 'https://dev.azure.com/fabrikam/Sample%20Project/_git/sample-repo/pullrequest/123'

$created = & (Join-Path $scriptRoot 'New-AdoPullRequest.ps1') @context -SourceBranch 'feature/demo' -TargetBranch 'main' -Title 'Demo PR' -Description 'Demo body' | ConvertFrom-Json
Assert-Equal -Actual $created.method -Expected 'POST' -Name 'create method'
Assert-Equal -Actual $created.body.sourceRefName -Expected 'refs/heads/feature/demo' -Name 'create source ref'
Assert-Equal -Actual $created.body.targetRefName -Expected 'refs/heads/main' -Name 'create target ref'
Assert-Equal -Actual $created.body.isDraft -Expected $true -Name 'create draft flag'

. (Join-Path $scriptRoot 'AdoPr.Common.ps1')
$draftContext = [pscustomobject]@{
    Organization = 'fabrikam'
    Project      = 'Sample Project'
    Repository   = 'sample-repo'
}
$draftPullRequest = [pscustomobject]@{
    pullRequestId     = 123
    isDraft           = $true
    pullRequestWebUrl = $expectedPrUrl
}
Assert-AdoPullRequestDraft -PullRequest $draftPullRequest -Context $draftContext -PullRequestId 123

$draftAssertionFailed = $false
try {
    Assert-AdoPullRequestDraft -PullRequest ([pscustomobject]@{
        pullRequestId     = 123
        isDraft           = $false
        pullRequestWebUrl = $expectedPrUrl
    }) -Context $draftContext -PullRequestId 123
}
catch {
    $draftAssertionFailed = $true
    if ($_.Exception.Message -notmatch [regex]::Escape($expectedPrUrl)) {
        throw "Draft assertion error did not include the PR URL: $($_.Exception.Message)"
    }
}

Assert-Equal -Actual $draftAssertionFailed -Expected $true -Name 'draft verification failure'

$read = & (Join-Path $scriptRoot 'Get-AdoPullRequest.ps1') @context -PullRequestId 123 -IncludeThreads | ConvertFrom-Json
Assert-Equal -Actual $read.pullRequestWebUrl -Expected $expectedPrUrl -Name 'read PR web URL'
Assert-Equal -Actual $read.requests[0].method -Expected 'GET' -Name 'read PR method'
Assert-Equal -Actual $read.requests[1].method -Expected 'GET' -Name 'read threads method'

$listed = & (Join-Path $scriptRoot 'Get-AdoPullRequest.ps1') @context -Status all -Top 5 | ConvertFrom-Json
Assert-Equal -Actual $listed.method -Expected 'GET' -Name 'list PR method'
if ($listed.url -notmatch '/repositories/sample-repo/pullrequests\?') {
    throw "Assertion failed for list PR URL: '$($listed.url)' did not use the repository-scoped endpoint."
}

$updated = & (Join-Path $scriptRoot 'Update-AdoPullRequest.ps1') @context -PullRequestId 123 -Title 'Updated title' -TargetBranch 'release/main' | ConvertFrom-Json
Assert-Equal -Actual $updated.method -Expected 'PATCH' -Name 'update method'
Assert-Equal -Actual $updated.body.targetRefName -Expected 'refs/heads/release/main' -Name 'update target ref'
Assert-Equal -Actual $updated.pullRequestWebUrl -Expected $expectedPrUrl -Name 'update PR web URL'

$commented = & (Join-Path $scriptRoot 'Add-AdoPullRequestComment.ps1') @context -PullRequestId 123 -Content 'Looks good.' | ConvertFrom-Json
Assert-Equal -Actual $commented.method -Expected 'POST' -Name 'comment method'
Assert-Equal -Actual $commented.body.comments[0].commentType -Expected 'text' -Name 'comment type'
Assert-Equal -Actual $commented.pullRequestWebUrl -Expected $expectedPrUrl -Name 'comment PR web URL'

$status = & (Join-Path $scriptRoot 'Set-AdoPullRequestThreadStatus.ps1') @context -PullRequestId 123 -ThreadId 456 -Status 'fixed' | ConvertFrom-Json
Assert-Equal -Actual $status.method -Expected 'PATCH' -Name 'thread status method'
Assert-Equal -Actual $status.body.status -Expected 'fixed' -Name 'thread status'
Assert-Equal -Actual $status.pullRequestWebUrl -Expected $expectedPrUrl -Name 'thread PR web URL'

[pscustomobject]@{
    ok      = $true
    checked = $scripts.Count
} | ConvertTo-Json
