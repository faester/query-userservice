param([Parameter(Mandatory = $True)][String]$accessToken) 


$parts = $accessToken.split(".")

if ($parts.Length -NE 3) {
	Write-Error "Your access token seems to be broken."
	Exit 1
}

function Convert-FromBase64($stringToConvert) {
	while ($stringToConvert.Length % 4 -NE 0) {
		$stringToConvert += "="
	}
	$stringToConvert = $stringToConvert -replace "-", "+"
	$stringToConvert = $stringToConvert -replace "_", "/"
	$array = [System.Convert]::FromBase64String($stringToConvert)

	$converted = [System.Text.Encoding]::UTF8.GetString($array)
	return $converted
}

$tokenBody = (Convert-FromBase64($parts[1]) |ConvertFrom-Json)
Write-Host "Token BODY"
Write-Host $tokenBody

Write-Host "Subject" $tokenBody.sub

$url = "https://userservice.jppol.dk/ssouser.svc/user/" + $tokenBody.sub

Write-Host "Performing request @ $url"

$headers = @{"Authorization" = "Bearer " + $accessToken; "Accept" = "application/json+jsondate"}

$response =  (iwr -Method GET -Uri $url -Headers $headers)

$userData = $response.Content |ConvertFrom-Json

return $userData

