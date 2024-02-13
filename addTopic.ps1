param (
    [Parameter(Mandatory=$true)]
    $repoName,
    [Parameter(Mandatory=$true)]
    $topic
)

$orgName = "svageriya-bunnings"  # Replace with your GitHub organization or username
$pat = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($env:GH_PAT)"))

# Ensure topics are lowercase
$topic = $topic.ToLower()

Write-Host "Adding the topic ""$topic"" to $repoName Repo"

# Get existing topics
$params = @{
    'Uri' = "https://api.github.com/repos/$orgName/$repoName/topics"
    'Headers' = @{ 'Authorization' = 'Basic ' + $pat }
    'Method' = 'GET'
    'ContentType' = 'application/json'
}
try {
    $topics = Invoke-RestMethod @params
}
catch {
    Write-Host "Error getting existing topics: $_"
    exit
}

# Add new topic
$topics.names += $topic
$body = $topics | ConvertTo-Json

# Update topics
$params = @{
    'Uri' = "https://api.github.com/repos/$orgName/$repoName/topics"
    'Headers' = @{ 'Authorization' = 'Basic ' + $pat }
    'Method' = 'Put'
    'ContentType' = 'application/json'
    'Body' = $body
}
try {
    $result = Invoke-RestMethod @params
    Write-Host "Topics updated successfully!"
}
catch {
    Write-Host "Error updating topics: $_"
}
