# Azure DevOps PR REST Notes

Use official Azure DevOps Git REST API `7.1` endpoints for this skill.

## Pull Requests
- Create: `POST https://dev.azure.com/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullrequests?api-version=7.1`
- Get one: `GET https://dev.azure.com/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullrequests/{pullRequestId}?api-version=7.1`
- List by repository: `GET https://dev.azure.com/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullrequests?api-version=7.1`
- List by project: `GET https://dev.azure.com/{organization}/{project}/_apis/git/pullrequests?api-version=7.1`
- Update: `PATCH https://dev.azure.com/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullrequests/{pullRequestId}?api-version=7.1`

The user-facing PR web link is:

`https://dev.azure.com/{organization}/{project}/_git/{repository}/pullrequest/{pullRequestId}`

Scripts should output this as `pullRequestWebUrl` because REST `url` fields point to API resources rather than the browser PR page.

Update only these PR fields unless Microsoft documents more for the active API version:
- `status`
- `title`
- `description`
- `completionOptions`
- `mergeOptions`
- `autoCompleteSetBy.id`
- `targetRefName`

## Threads and Comments
- List threads: `GET https://dev.azure.com/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/threads?api-version=7.1`
- Create thread: `POST https://dev.azure.com/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/threads?api-version=7.1`
- Create comment on an existing thread: `POST https://dev.azure.com/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/threads/{threadId}/comments?api-version=7.1`
- Update thread status: `PATCH https://dev.azure.com/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullRequests/{pullRequestId}/threads/{threadId}?api-version=7.1`

## Authentication
- Read PRs requires `vso.code`.
- Create or update PRs requires `vso.code_write`.
- Read/write threads requires `vso.threads_full` when token scopes are enforced.
- Scripts can authenticate with PAT/basic auth, bearer auth, Git Credential Manager, or Azure CLI token fallback.

## Official Sources
- https://learn.microsoft.com/rest/api/azure/devops/git/pull-requests/create?view=azure-devops-rest-7.1
- https://learn.microsoft.com/rest/api/azure/devops/git/pull-requests/get-pull-request?view=azure-devops-rest-7.1
- https://learn.microsoft.com/rest/api/azure/devops/git/pull-requests/get-pull-requests-by-project?view=azure-devops-rest-7.1
- https://learn.microsoft.com/rest/api/azure/devops/git/pull-requests/update?view=azure-devops-rest-7.1
- https://learn.microsoft.com/rest/api/azure/devops/git/pull-request-threads/list?view=azure-devops-rest-7.1
- https://learn.microsoft.com/rest/api/azure/devops/git/pull-request-threads/create?view=azure-devops-rest-7.1
- https://learn.microsoft.com/rest/api/azure/devops/git/pull-request-thread-comments?view=azure-devops-rest-7.1
