param([string]$queryExpression = "advertizingOptOut==1", [string]$filePath = "user-query-result.txt")

. .\Get-AccessToken.ps1

function Update-User([string]$AccessToken, [string]$userid, [object]$properties) {
	$headers = @{ "Authorization" = ("Bearer " + $AccessToken); "Content-Type" = "application/json+jsondate"}
	$user = Invoke-Webrequest -Uri ("https://userservice.jppol.dk/ssouser.svc/user/" + $userid) -Method GET
	return $user
}

function Query-Userservice {
	param ([string]$AccessToken, [string]$queryExpression)

	$queryExpressionJson = $($queryExpression |ConvertTo-Json)
	$maxPage = 1; 
	$headers = @{ "Authorization" = ("Bearer " + $AccessToken); "Content-Type" = "application/json"}

	for($currentPage = 0; $currentPage -lt $maxPage; $currentPage++) {
		$uri = "https://userservice.jppol.dk/ssouser.svc/query/?page=" + $currentPage
		$requestResult = Invoke-Webrequest -Uri $uri -Headers $headers -Body $queryExpressionJson -Method PUT
		$content = [System.Text.Encoding]::Utf8.GetString($requestResult.Content)
		$queryResult  = $($content | ConvertFrom-Json)
		$queryResult.IdsOfMatchingUsers 
		$maxPage = $queryResult.NumberOfPages
		Write-Host "Page", ($currentPage + 1), "of", $maxPage
	}
}


$accessToken = Get-AccessToken -ClientID $credentials.clientId -ClientSecret $credentials.clientSecret
Write-Host "Received access token" $accessToken

Query-Userservice -AccessToken $accessToken -queryExpression $queryExpression 
