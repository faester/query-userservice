function Get-AccessToken {
	try {
		$fromFile = $(Import-CliXml -Path .current-token)
		if (($fromFile -NE $null) -and ($fromFile.expiration -GT (get-date))) {
			write-host "Using cached token"
			return $fromFile.token
		}
	}
	catch {
		Write-Host "No token cache file found."
	}


	$credentials = $(Get-Content -Path .\secrets.json|ConvertFrom-Json)
	$ClientID = $credentials.clientId 
	$ClientSecret =  $credentials.clientSecret
	$pair = "$($ClientID):$($ClientSecret)"
	$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))

	try {
		$response = Invoke-Webrequest -Uri ($credentials.authEndpoint + "/connect/token") -Method POST -Body "grant_type=client_credentials&scope=userservice" -Headers @{ "Authorization" = "Basic " + $encodedCreds }
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

	$parsed = $($response |ConvertFrom-Json)

	$cacheable = @{token = $parsed.access_token; expiration = (Get-Date).AddSeconds($parsed.expires_in * 0.8) }
	$cacheable |Export-CliXml -Path .current-token -Encoding UTF8

	return $parsed.access_token
}
