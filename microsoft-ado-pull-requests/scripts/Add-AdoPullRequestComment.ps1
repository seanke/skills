[CmdletBinding()]
param(
    [string]$Organization,
    [string]$Project,
    [string]$Repository,
    [string]$RemoteUrl,
    [Parameter(Mandatory = $true)]
    [int]$PullRequestId,
    [string]$Content,
    [string]$ContentFile,
    [int]$ThreadId,
    [int]$ParentCommentId = 0,
    [string]$FilePath,
    [int]$Line,
    [int]$StartColumn = 1,
    [int]$EndLine,
    [int]$EndColumn,
    [int]$ChangeTrackingId,
    [int]$FirstIteration,
    [int]$SecondIteration,
    [ValidateSet('active', 'fixed', 'wontFix', 'closed', 'byDesign', 'pending')]
    [string]$Status = 'active',
    [switch]$DryRun,
    [switch]$ConfirmLiveWrite,
    [ValidateSet('Auto', 'Pat', 'Bearer', 'GitCredential')]
    [string]$AuthMode = 'Auto'
)

Set-StrictMode -Version Latest
. (Join-Path $PSScriptRoot 'AdoPr.Common.ps1')

$context = Resolve-AdoContext -Organization $Organization -Project $Project -Repository $Repository -RemoteUrl $RemoteUrl
$repositoryPath = Get-AdoRepositoryPath -Context $context
$contentText = Resolve-AdoTextInput -Text $Content -Path $ContentFile -Name 'Content'
$pullRequestWebUrl = New-AdoPullRequestWebUrl -Context $context -PullRequestId $PullRequestId

if ([string]::IsNullOrWhiteSpace($contentText)) {
    throw 'A comment requires -Content or -ContentFile.'
}

if ($ThreadId -gt 0) {
    $body = [ordered]@{
        content         = $contentText
        parentCommentId = $ParentCommentId
        commentType     = 'text'
    }
    $url = New-AdoApiUrl -Context $context -Path "$repositoryPath/pullRequests/$PullRequestId/threads/$ThreadId/comments"
}
else {
    $comment = [ordered]@{
        parentCommentId = 0
        content         = $contentText
        commentType     = 'text'
    }

    $body = [ordered]@{
        comments = @($comment)
        status   = $Status
    }

    if (-not [string]::IsNullOrWhiteSpace($FilePath)) {
        if ($Line -le 0) {
            throw 'Inline comments require -Line.'
        }

        if ($EndLine -le 0) {
            $EndLine = $Line
        }

        if ($EndColumn -le 0) {
            $EndColumn = $StartColumn
        }

        $normalizedPath = '/' + $FilePath.TrimStart('/')
        $body.threadContext = [ordered]@{
            filePath       = $normalizedPath
            rightFileStart = @{ line = $Line; offset = $StartColumn }
            rightFileEnd   = @{ line = $EndLine; offset = $EndColumn }
        }

        if ($ChangeTrackingId -gt 0 -or $FirstIteration -gt 0 -or $SecondIteration -gt 0) {
            if ($ChangeTrackingId -le 0 -or $FirstIteration -le 0 -or $SecondIteration -le 0) {
                throw 'Inline pull request iteration context requires -ChangeTrackingId, -FirstIteration, and -SecondIteration together.'
            }

            $body.pullRequestThreadContext = [ordered]@{
                changeTrackingId = $ChangeTrackingId
                iterationContext = @{
                    firstComparingIteration  = $FirstIteration
                    secondComparingIteration = $SecondIteration
                }
            }
        }
    }

    $url = New-AdoApiUrl -Context $context -Path "$repositoryPath/pullRequests/$PullRequestId/threads"
}

if ($DryRun.IsPresent) {
    New-AdoDryRun -Method POST -Url $url -Body $body -PullRequestWebUrl $pullRequestWebUrl | Write-AdoJson
    return
}

if (-not $ConfirmLiveWrite.IsPresent) {
    throw 'Adding a pull request comment is a live write. Rerun with -DryRun first, then use -ConfirmLiveWrite when the request is correct.'
}

$comment = Invoke-AdoRest -Method POST -Url $url -Body $body -AuthMode $AuthMode -Context $context
Add-AdoPullRequestWebUrl -InputObject $comment -Context $context -PullRequestId $PullRequestId | Write-AdoJson
