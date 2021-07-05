param([string]$userserviceEndpoint)

# Copy from input to new object
$userids = @()

$input | foreach {
	$userids += $_
}

Write-Host ($users|convertto-json)

. .\Get-AccessToken.ps1

function Cancel-Delete([string]$AccessToken, [string]$userid) {
	$headers = @{ "Authorization" = ("Bearer " + $AccessToken); "Content-Type" = "application/json"; "If-Match" = $retrieved.Version}
	$response = Invoke-Webrequest -Uri ($userserviceEndpoint + "/ssouser.svc/user/" + $userid + "?action=cancel") -Method DELETE -Headers $headers -Body $json
}

$accessToken = Get-AccessToken -ClientID $credentials.clientId -ClientSecret $credentials.clientSecret

$userids | foreach {
	$retrieved = $_ |.\get-user.ps1 -userserviceEndpoint $userserviceEndpoint
	if ($retrieved.PendingDelete  -NE $Null) {
		Write-Host "Has pending delete $_"
		Cancel-Delete $accessToken $_
		$_
	}
}
