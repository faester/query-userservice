param ([string]$ssoid, [string]$brand, [long]$textId, [string]$source, [string]$permissionType)

$credentials = $(Get-Content -Path .\secrets.json|ConvertFrom-Json)
$apiToken = $credentials.permissionServiceApiToken
$authorization = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($apiToken+":"))

$user = @{"userId" = $ssoid; "userType" = "sso"}
$permission = @{"action" = "Remove"; "type" = $permissionType; "brand" = $brand; "textId" = $textId; "source" = $source }

$requestBody = @{ "user" = $user; "permission" = $permission }

$uri = "https://permissions.services.jppol.dk/api/v2/permissions"
$body = $($requestBody | ConvertTo-Json)


Invoke-Webrequest -Uri $uri -Method POST -Body $body -Headers @{ "Authorization" = ("Basic " + $authorization); "Content-Type" = "application/json" }
