param ([string]$userserviceEndpoint = "https://userservice.jppol.dk"
	)

. .\Get-AccessToken.ps1

function Verify-Email([string]$AccessToken, [string]$email) {
	$headers = @{ "Authorization" = ("Bearer " + $AccessToken); "Content-Type" = "application/json+jsondate"}
	$urlEncodedEmail = $email
	$absoluteUrl = $userserviceEndpoint + "/ssouser.svc/validateEmail/" + $urlEncodedEmail
	write-host $absoluteUrl
	write-host $AccessToken
	$response = Invoke-Webrequest -Uri $absoluteUrl -Method POST -Headers $headers
	$response|ConvertFrom-Json
}

$accessToken = Get-AccessToken -ClientID $credentials.clientId -ClientSecret $credentials.clientSecret

$emails = @()
foreach($email in $input) {
	write-host "Hello" $email
	$emails += $email
}

$count = 0
foreach($email in $emails) {
	$count++
	$stopwatch =  [system.diagnostics.stopwatch]::StartNew()
	Verify-Email -AccessToken $accessToken -email $email
	write-host "Retrieving" $email "which is" $count "of" $emails.Length "in" $stopwatch.Elapsed
}
