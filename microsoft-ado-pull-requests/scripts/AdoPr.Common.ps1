Set-StrictMode -Version Latest

function ConvertTo-AdoUrlSegment {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Value
    )

    return [uri]::EscapeDataString($Value)
}

function ConvertTo-AdoQueryValue {
    param(
        [Parameter(Mandatory = $true)]
        [object]$Value
    )

    if ($Value -is [bool]) {
        return $Value.ToString().ToLowerInvariant()
    }

    return [string]$Value
}

function ConvertTo-AdoQueryString {
    param(
        [hashtable]$Query
    )

    if ($null -eq $Query -or $Query.Count -eq 0) {
        return ''
    }

    $pairs = foreach ($key in ($Query.Keys | Sort-Object)) {
        $value = $Query[$key]
        if ($null -eq $value) {
            continue
        }

        $stringValue = ConvertTo-AdoQueryValue -Value $value
        if ([string]::IsNullOrWhiteSpace($stringValue)) {
            continue
        }

        '{0}={1}' -f [uri]::EscapeDataString([string]$key), [uri]::EscapeDataString($stringValue)
    }

    return ($pairs -join '&')
}

function ConvertTo-AdoRefName {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Branch
    )

    $trimmed = $Branch.Trim()
    if ($trimmed -match '^refs/') {
        return $trimmed
    }

    if ($trimmed -match '^heads/') {
        return "refs/$trimmed"
    }

    return "refs/heads/$trimmed"
}

function Get-AdoGitRemoteUrl {
    try {
        $remote = & git config --get remote.origin.url 2>$null
        if ($LASTEXITCODE -eq 0 -and -not [string]::IsNullOrWhiteSpace($remote)) {
            return $remote.Trim()
        }
    }
    catch {
        return $null
    }

    return $null
}

function ConvertFrom-AdoRemoteUrl {
    param(
        [string]$RemoteUrl
    )

    $result = @{}
    if ([string]::IsNullOrWhiteSpace($RemoteUrl)) {
        return $result
    }

    $value = $RemoteUrl.Trim()

    if ($value -match '^git@ssh\.dev\.azure\.com:v3/([^/]+)/([^/]+)/(.+)$') {
        $result.Organization = [uri]::UnescapeDataString($Matches[1])
        $result.Project = [uri]::UnescapeDataString($Matches[2])
        $result.Repository = [uri]::UnescapeDataString($Matches[3])
        return $result
    }

    if ($value -match '^https?://([^@/]+@)?dev\.azure\.com/([^/]+)/([^/]+)/_git/([^?#]+)') {
        $result.Organization = [uri]::UnescapeDataString($Matches[2])
        $result.Project = [uri]::UnescapeDataString($Matches[3])
        $result.Repository = [uri]::UnescapeDataString($Matches[4])
        return $result
    }

    if ($value -match '^https?://([^./]+)\.visualstudio\.com/([^/]+)/_git/([^?#]+)') {
        $result.Organization = [uri]::UnescapeDataString($Matches[1])
        $result.Project = [uri]::UnescapeDataString($Matches[2])
        $result.Repository = [uri]::UnescapeDataString($Matches[3])
        return $result
    }

    return $result
}

function Resolve-AdoContext {
    param(
        [string]$Organization,
        [string]$Project,
        [string]$Repository,
        [string]$RemoteUrl
    )

    if ([string]::IsNullOrWhiteSpace($Organization)) {
        $Organization = $env:ADO_ORG
    }

    if ([string]::IsNullOrWhiteSpace($Project)) {
        $Project = $env:ADO_PROJECT
    }

    if ([string]::IsNullOrWhiteSpace($Repository)) {
        $Repository = $env:ADO_REPOSITORY
    }

    if ([string]::IsNullOrWhiteSpace($RemoteUrl)) {
        $RemoteUrl = Get-AdoGitRemoteUrl
    }

    $remoteContext = ConvertFrom-AdoRemoteUrl -RemoteUrl $RemoteUrl

    if ([string]::IsNullOrWhiteSpace($Organization) -and $remoteContext.ContainsKey('Organization')) {
        $Organization = $remoteContext.Organization
    }

    if ([string]::IsNullOrWhiteSpace($Project) -and $remoteContext.ContainsKey('Project')) {
        $Project = $remoteContext.Project
    }

    if ([string]::IsNullOrWhiteSpace($Repository) -and $remoteContext.ContainsKey('Repository')) {
        $Repository = $remoteContext.Repository
    }

    $missing = @()
    if ([string]::IsNullOrWhiteSpace($Organization)) { $missing += 'Organization' }
    if ([string]::IsNullOrWhiteSpace($Project)) { $missing += 'Project' }
    if ([string]::IsNullOrWhiteSpace($Repository)) { $missing += 'Repository' }

    if ($missing.Count -gt 0) {
        throw "Missing Azure DevOps context: $($missing -join ', '). Supply explicit parameters, set ADO_ORG/ADO_PROJECT/ADO_REPOSITORY, or run from a checkout with an Azure Repos origin."
    }

    return [pscustomobject]@{
        Organization = $Organization
        Project      = $Project
        Repository   = $Repository
        RemoteUrl    = $RemoteUrl
    }
}

function New-AdoApiUrl {
    param(
        [Parameter(Mandatory = $true)]
        [pscustomobject]$Context,

        [Parameter(Mandatory = $true)]
        [string]$Path,

        [hashtable]$Query
    )

    $queryValues = @{}
    if ($null -ne $Query) {
        foreach ($key in $Query.Keys) {
            $queryValues[$key] = $Query[$key]
        }
    }

    if (-not $queryValues.ContainsKey('api-version')) {
        $queryValues['api-version'] = '7.1'
    }

    $org = ConvertTo-AdoUrlSegment -Value $Context.Organization
    $project = ConvertTo-AdoUrlSegment -Value $Context.Project
    $cleanPath = $Path.TrimStart('/')
    $url = "https://dev.azure.com/$org/$project/_apis/git/$cleanPath"
    $queryString = ConvertTo-AdoQueryString -Query $queryValues

    if ([string]::IsNullOrWhiteSpace($queryString)) {
        return $url
    }

    return "${url}?$queryString"
}

function Get-AdoRepositoryPath {
    param(
        [Parameter(Mandatory = $true)]
        [pscustomobject]$Context
    )

    $repository = ConvertTo-AdoUrlSegment -Value $Context.Repository
    return "repositories/$repository"
}

function New-AdoPullRequestWebUrl {
    param(
        [Parameter(Mandatory = $true)]
        [pscustomobject]$Context,

        [Parameter(Mandatory = $true)]
        [int]$PullRequestId
    )

    if ($PullRequestId -le 0) {
        return $null
    }

    $org = ConvertTo-AdoUrlSegment -Value $Context.Organization
    $project = ConvertTo-AdoUrlSegment -Value $Context.Project
    $repository = ConvertTo-AdoUrlSegment -Value $Context.Repository
    return "https://dev.azure.com/$org/$project/_git/$repository/pullrequest/$PullRequestId"
}

function Add-AdoPullRequestWebUrl {
    param(
        [Parameter(Mandatory = $true)]
        [AllowNull()]
        [object]$InputObject,

        [Parameter(Mandatory = $true)]
        [pscustomobject]$Context,

        [int]$PullRequestId = 0
    )

    if ($null -eq $InputObject) {
        return $InputObject
    }

    $propertyNames = @($InputObject.PSObject.Properties.Name)
    $explicitUrl = if ($PullRequestId -gt 0) {
        New-AdoPullRequestWebUrl -Context $Context -PullRequestId $PullRequestId
    }
    else {
        $null
    }

    if ($propertyNames -contains 'value' -and $null -ne $InputObject.value) {
        foreach ($item in @($InputObject.value)) {
            Add-AdoPullRequestWebUrl -InputObject $item -Context $Context | Out-Null
        }
    }

    if ($propertyNames -contains 'pullRequest' -and $null -ne $InputObject.pullRequest) {
        Add-AdoPullRequestWebUrl -InputObject $InputObject.pullRequest -Context $Context -PullRequestId $PullRequestId | Out-Null

        if ([string]::IsNullOrWhiteSpace($explicitUrl)) {
            $nestedId = Get-AdoObjectPropertyValue -InputObject $InputObject.pullRequest -Name 'pullRequestId'
            if ($null -ne $nestedId) {
                $explicitUrl = New-AdoPullRequestWebUrl -Context $Context -PullRequestId ([int]$nestedId)
            }
        }
    }

    if ([string]::IsNullOrWhiteSpace($explicitUrl)) {
        $objectPullRequestId = Get-AdoObjectPropertyValue -InputObject $InputObject -Name 'pullRequestId'
        if ($null -ne $objectPullRequestId) {
            $explicitUrl = New-AdoPullRequestWebUrl -Context $Context -PullRequestId ([int]$objectPullRequestId)
        }
    }

    if (-not [string]::IsNullOrWhiteSpace($explicitUrl)) {
        $InputObject | Add-Member -NotePropertyName 'pullRequestWebUrl' -NotePropertyValue $explicitUrl -Force
    }

    return $InputObject
}

function Get-AdoObjectPropertyValue {
    param(
        [Parameter(Mandatory = $true)]
        [AllowNull()]
        [object]$InputObject,

        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    if ($null -eq $InputObject) {
        return $null
    }

    $property = $InputObject.PSObject.Properties[$Name]
    if ($null -eq $property) {
        return $null
    }

    return $property.Value
}

function New-AdoAuthHeaders {
    param(
        [ValidateSet('Auto', 'Pat', 'Bearer', 'GitCredential')]
        [string]$AuthMode = 'Auto',

        [pscustomobject]$Context
    )

    $headers = @{
        Accept         = 'application/json'
        'Content-Type' = 'application/json'
    }

    $pat = if (-not [string]::IsNullOrWhiteSpace($env:ADO_PAT)) {
        $env:ADO_PAT
    }
    elseif (-not [string]::IsNullOrWhiteSpace($env:AZURE_DEVOPS_EXT_PAT)) {
        $env:AZURE_DEVOPS_EXT_PAT
    }
    else {
        $null
    }

    if ($AuthMode -eq 'Pat' -or ($AuthMode -eq 'Auto' -and -not [string]::IsNullOrWhiteSpace($pat))) {
        if ([string]::IsNullOrWhiteSpace($pat)) {
            throw 'AuthMode Pat requires ADO_PAT or AZURE_DEVOPS_EXT_PAT.'
        }

        $bytes = [Text.Encoding]::ASCII.GetBytes(":$pat")
        $headers.Authorization = "Basic $([Convert]::ToBase64String($bytes))"
        return $headers
    }

    $bearer = if (-not [string]::IsNullOrWhiteSpace($env:ADO_BEARER_TOKEN)) {
        $env:ADO_BEARER_TOKEN
    }
    elseif (-not [string]::IsNullOrWhiteSpace($env:SYSTEM_ACCESSTOKEN)) {
        $env:SYSTEM_ACCESSTOKEN
    }
    else {
        $null
    }

    if ($AuthMode -eq 'Bearer' -or ($AuthMode -eq 'Auto' -and -not [string]::IsNullOrWhiteSpace($bearer))) {
        if ([string]::IsNullOrWhiteSpace($bearer)) {
            $bearer = Get-AdoBearerTokenFromAzCli
        }

        $headers.Authorization = "Bearer $bearer"
        return $headers
    }

    if ($AuthMode -eq 'GitCredential' -or ($AuthMode -eq 'Auto' -and $null -ne $Context)) {
        $basicCredential = Get-AdoBasicCredentialFromGit -Context $Context
        if (-not [string]::IsNullOrWhiteSpace($basicCredential)) {
            $headers.Authorization = "Basic $basicCredential"
            return $headers
        }

        if ($AuthMode -eq 'GitCredential') {
            throw 'Git Credential Manager did not return an Azure Repos credential for the resolved remote.'
        }
    }

    if ($AuthMode -eq 'Auto') {
        $bearer = Get-AdoBearerTokenFromAzCli
        $headers.Authorization = "Bearer $bearer"
        return $headers
    }

    throw 'Unable to resolve Azure DevOps authentication headers.'
}

function Get-AdoBasicCredentialFromGit {
    param(
        [Parameter(Mandatory = $true)]
        [pscustomobject]$Context
    )

    $credentialInput = @(
        'protocol=https'
        'host=dev.azure.com'
        "path=$($Context.Organization)/$($Context.Project)/_git/$($Context.Repository)"
        ''
    )

    try {
        $credentialLines = $credentialInput | & git credential fill 2>$null
    }
    catch {
        return $null
    }

    if ($LASTEXITCODE -ne 0 -or $null -eq $credentialLines) {
        return $null
    }

    $credential = @{}
    foreach ($line in $credentialLines) {
        if ($line -match '^([^=]+)=(.*)$') {
            $credential[$Matches[1]] = $Matches[2]
        }
    }

    if (-not $credential.ContainsKey('password') -or [string]::IsNullOrWhiteSpace($credential.password)) {
        return $null
    }

    $username = if ($credential.ContainsKey('username') -and -not [string]::IsNullOrWhiteSpace($credential.username)) {
        $credential.username
    }
    else {
        'ado'
    }

    $bytes = [Text.Encoding]::ASCII.GetBytes("${username}:$($credential.password)")
    return [Convert]::ToBase64String($bytes)
}

function Get-AdoBearerTokenFromAzCli {
    $token = $null
    try {
        $token = & az account get-access-token --resource 499b84ac-1321-427f-aa17-267ca6975798 --query accessToken -o tsv 2>$null
    }
    catch {
        $token = $null
    }

    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($token)) {
        throw 'Unable to get an Azure DevOps bearer token. Set ADO_PAT, AZURE_DEVOPS_EXT_PAT, ADO_BEARER_TOKEN, or sign in with Azure CLI.'
    }

    return $token.Trim()
}

function Invoke-AdoRest {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('GET', 'POST', 'PATCH', 'PUT', 'DELETE')]
        [string]$Method,

        [Parameter(Mandatory = $true)]
        [string]$Url,

        [object]$Body,

        [ValidateSet('Auto', 'Pat', 'Bearer', 'GitCredential')]
        [string]$AuthMode = 'Auto',

        [pscustomobject]$Context
    )

    $headers = New-AdoAuthHeaders -AuthMode $AuthMode -Context $Context
    $parameters = @{
        Method  = $Method
        Uri     = $Url
        Headers = $headers
    }

    if ($PSBoundParameters.ContainsKey('Body') -and $null -ne $Body) {
        $parameters.Body = ($Body | ConvertTo-Json -Depth 100)
    }

    try {
        return Invoke-RestMethod @parameters
    }
    catch {
        $message = $_.Exception.Message
        if ($_.ErrorDetails -and -not [string]::IsNullOrWhiteSpace($_.ErrorDetails.Message)) {
            $message = "$message $($_.ErrorDetails.Message)"
        }

        throw "Azure DevOps REST request failed: $message"
    }
}

function Resolve-AdoTextInput {
    param(
        [string]$Text,
        [string]$Path,
        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    if (-not [string]::IsNullOrWhiteSpace($Text) -and -not [string]::IsNullOrWhiteSpace($Path)) {
        throw "Supply either -$Name or -$($Name)File, not both."
    }

    if (-not [string]::IsNullOrWhiteSpace($Path)) {
        return Get-Content -LiteralPath $Path -Raw
    }

    return $Text
}

function ConvertFrom-AdoJsonText {
    param(
        [string]$Json,
        [string]$Path,
        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    $text = Resolve-AdoTextInput -Text $Json -Path $Path -Name $Name
    if ([string]::IsNullOrWhiteSpace($text)) {
        return $null
    }

    return $text | ConvertFrom-Json
}

function New-AdoDryRun {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('GET', 'POST', 'PATCH', 'PUT', 'DELETE')]
        [string]$Method,

        [Parameter(Mandatory = $true)]
        [string]$Url,

        [object]$Body,

        [string]$PullRequestWebUrl
    )

    $result = [ordered]@{
        method = $Method
        url    = $Url
        body   = $Body
    }

    if (-not [string]::IsNullOrWhiteSpace($PullRequestWebUrl)) {
        $result.pullRequestWebUrl = $PullRequestWebUrl
    }

    return $result
}

function Write-AdoJson {
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [object]$InputObject
    )

    process {
        $InputObject | ConvertTo-Json -Depth 100
    }
}
