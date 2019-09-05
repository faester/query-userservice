param([Object]$properties)

. .\Get-AccessToken.ps1

function Update-User([string]$AccessToken, [Object]$user) {
	$headers = @{ "Authorization" = ("Bearer " + $AccessToken); "Content-Type" = "application/json"; "If-Match" = $user.Version}
	$json = ($user |ConvertTo-Json)
	$response = Invoke-Webrequest -Uri ("https://userservice.jppol.dk/ssouser.svc/user/" + $user.Identifier) -Method PUT -Headers $headers -Body $json
	return $user
}

$accessToken = Get-AccessToken -ClientID $credentials.clientId -ClientSecret $credentials.clientSecret
foreach($user in $input) {
	$user.Properties = $properties
	Update-user -AccessToken $accessToken -user $user 
}
