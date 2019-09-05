. .\Get-AccessToken.ps1

function Get-User([string]$AccessToken, [string]$userid) {
	$headers = @{ "Authorization" = ("Bearer " + $AccessToken); "Content-Type" = "application/json+jsondate"}
	$response = Invoke-Webrequest -Uri ("https://userservice.jppol.dk/ssouser.svc/user/" + $userid) -Method GET -Headers $headers
	$response|ConvertFrom-Json
}

$accessToken = Get-AccessToken -ClientID $credentials.clientId -ClientSecret $credentials.clientSecret
foreach($userid in $input) {
	write-host "Retrieving" $userid
	Get-User -AccessToken $accessToken -userid $userid 
}
