function Get-AccessToken {
	$credentials = $(Get-Content -Path .\secrets.json|ConvertFrom-Json)
	$ClientID = $credentials.clientId 
	$ClientSecret =  $credentials.clientSecret
	$pair = "$($ClientID):$($ClientSecret)"
	$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))

	try {
		$response = Invoke-Webrequest -Uri https://auth.medielogin.dk/connect/token -Method POST -Body "grant_type=client_credentials&scope=userservice" -Headers @{ "Authorization" = "Basic " + $encodedCreds }
	}
	catch {
		$errorRecord = $_
		Write-Host $errorRecord.Exception
		Write-Host $errorRecord.ErrorDetails 
	}

	if ($response.StatusCode -NE 200) {
		Write-Host "Credentials was not accepted or some other bad thing happened." , $response.StatusCode, $response.StatusText
		$response
		exit 1
	}

	return $($response |ConvertFrom-Json).access_token
}
