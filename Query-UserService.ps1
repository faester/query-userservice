param([string]$queryExpression = "advertizingOptOut==1", [string]$filePath = "user-query-result.txt", [string]$userserviceEndpoint = "https://userservicetest.jppol.dk", [int]$maxPages = 0)

. .\Get-AccessToken.ps1

function Update-User([string]$AccessToken, [string]$userid, [object]$properties) {
	$headers = @{ "Authorization" = ("Bearer " + $AccessToken); "Content-Type" = "application/json+jsondate"}
	$user = Invoke-Webrequest -Uri ($userserviceEndpoint + "/ssouser.svc/user/" + $userid) -Method GET
	return $user
}

function Query-Userservice {
	param ([string]$AccessToken, [string]$queryExpression)

	$queryExpressionJson = $($queryExpression |ConvertTo-Json)
	$maxPage = 1; 
	$headers = @{ "Authorization" = ("Bearer " + $AccessToken); "Content-Type" = "application/json"}

	for($currentPage = 0; $currentPage -lt $maxPage; $currentPage++) {
		$uri = $userserviceEndpoint + "/ssouser.svc/query/?page=" + $currentPage
		$requestResult = Invoke-Webrequest -Uri $uri -Headers $headers -Body $queryExpressionJson -Method PUT
		$content = [System.Text.Encoding]::Utf8.GetString($requestResult.Content)
		$queryResult  = $($content | ConvertFrom-Json)
		$queryResult.IdsOfMatchingUsers 
		$maxPage = $queryResult.NumberOfPages
		if ($maxPages -GT 0) {
			$maxPage = $maxPages
		}
		Write-Host "Page", ($currentPage + 1), "of", $queryResult.NumberOfPages
	}
}


$accessToken = Get-AccessToken -ClientID $credentials.clientId -ClientSecret $credentials.clientSecret
Query-Userservice -AccessToken $accessToken -queryExpression $queryExpression 
