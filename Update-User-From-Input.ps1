param([string]$userserviceEndpoint)

# Copy from input to new object
$users = @()

$input | foreach {
	$users += $_
}

Write-Host ($users|convertto-json)

. .\Get-AccessToken.ps1

function Update-User([string]$AccessToken, [Object]$user) {
	$user.Identifier 
	$retrieved = $user.Identifier |.\get-user.ps1 -userserviceEndpoint $userserviceEndpoint
	$headers = @{ "Authorization" = ("Bearer " + $AccessToken); "Content-Type" = "application/json"; "If-Match" = $retrieved.Version}
	$json = ($user |ConvertTo-Json)
	$response = Invoke-Webrequest -Uri ($userserviceEndpoint + "/ssouser.svc/user/" + $user.Identifier) -Method PUT -Headers $headers -Body $json
}

$accessToken = Get-AccessToken -ClientID $credentials.clientId -ClientSecret $credentials.clientSecret

$users | foreach {
	Update-User $accessToken $_ 
}
