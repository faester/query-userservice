param ([string]$userserviceEndpoint)

. .\Get-AccessToken.ps1

function Get-User([string]$AccessToken, [string]$userid) {
	$headers = @{ "Authorization" = ("Bearer " + $AccessToken); "Content-Type" = "application/json+jsondate"}
	$response = Invoke-Webrequest -Uri ($userserviceEndpoint + "/ssouser.svc/user/" + $userid) -Method GET -Headers $headers
	$response|ConvertFrom-Json
}

$accessToken = Get-AccessToken -ClientID $credentials.clientId -ClientSecret $credentials.clientSecret

$userids = @()
foreach($userid in $input) {
	$userids += $userid
}

$count = 0
foreach($userid in $userids) {
	$count++
	$stopwatch =  [system.diagnostics.stopwatch]::StartNew()
	Get-User -AccessToken $accessToken -userid $userid 
	write-host "Retrieving" $userid "which is" $count "of" $userids.Length "in" $stopwatch.Elapsed
}
