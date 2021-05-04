param ([string]$userserviceEndpoint = "https://userservice.jppol.dk"
	)

. .\Get-AccessToken.ps1

function Verify-Email([string]$AccessToken, [string]$email) {
	$headers = @{ "Authorization" = ("Bearer " + $AccessToken); "Content-Type" = "application/json+jsondate"}
	$urlEncodedEmail = $email
	$absoluteUrl = $userserviceEndpoint + "/ssouser.svc/validateEmail/" + $urlEncodedEmail
	$response = Invoke-Webrequest -Uri $absoluteUrl -Method POST -Headers $headers
	$response|ConvertFrom-Json
}

$accessToken = Get-AccessToken -ClientID $credentials.clientId -ClientSecret $credentials.clientSecret

Write-Host "Building list"
$count = 0
foreach($email in $input) {
	$count++
	$stopwatch =  [system.diagnostics.stopwatch]::StartNew()
	Verify-Email -AccessToken $accessToken -email $email
	write-host "Retrieving" $email "which is" $count "of" $emails.Length "in" $stopwatch.Elapsed
}
