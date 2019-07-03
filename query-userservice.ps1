param([string]$queryExpression = "advertizingOptOut==1", [string]$filePath = "user-query-result.txt")

function Get-AccessToken {
	param ( [string]$ClientID, [string]$ClientSecret)
	$pair = "$($ClientID):$($ClientSecret)"
	$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))

	$response = Invoke-Webrequest -Uri https://auth.medielogin.dk/connect/token -Method POST -Body "grant_type=client_credentials&scope=userservice" -Headers @{ "Authorization" = "Basic " + $encodedCreds }

	if ($response.StatusCode -NE 200) {
		Write-Host "Credentials was not accepted or some other bad thing happened." , $response.StatusCode, $response.StatusText
	}

	return $($response |ConvertFrom-Json).access_token
}

function Query-Userservice {
	param ([string]$AccessToken, [string]$queryExpression, [string]$filePath)

	"userid" |Out-File -FilePath $filePath -Encoding UTF8

	$queryExpressionJson = $($queryExpression |ConvertTo-Json)
	$maxPage = 1; 
	$headers = @{ "Authorization" = ("Bearer " + $AccessToken); "Content-Type" = "application/json"}

	for($currentPage = 0; $currentPage -lt $maxPage; $currentPage++) {
		$uri = "https://userservice.jppol.dk/ssouser.svc/query/?page=" + $currentPage
		$requestResult = Invoke-Webrequest -Uri $uri -Headers $headers -Body $queryExpressionJson -Method PUT
		$content = [System.Text.Encoding]::Utf8.GetString($requestResult.Content)
		$queryResult  = $($content | ConvertFrom-Json)
		$queryResult.IdsOfMatchingUsers |Out-File -FilePath $filePath -Encoding UTF8 -Append
		$maxPage = $queryResult.NumberOfPages
		Write-Host "Page", ($currentPage + 1), "of", $maxPage
	}
}

$credentials = $(Get-Content -Path .\secrets.json|ConvertFrom-Json)

$accessToken = Get-AccessToken -ClientID $credentials.clientId -ClientSecret $credentials.clientSecret

Query-Userservice -AccessToken $accessToken -queryExpression $queryExpression -filePath $filePath
