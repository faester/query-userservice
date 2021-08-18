param ( [string]$ssoIdFile = "C:\temp\email-validation\email-validator-new.csv",
      	[string]$resultFile = "C:\temp\email-validation\validated-emails.csv"
)

Write-Host "Reading ssoids"
$count = 0
$ssoids = @{}
gc $ssoIdFile |ConvertFrom-CSV -Delimiter ";" | foreach {
	$count = $count + 1
	$ssoids[$_.email] = $_.sso_id	
	if ($count % 1000 -EQ 0) {
		Write-Host "Read $count ids"
	}
}

# Dette er en test...
Write-Host "Reading resultfile"
gc $resultfile |ConvertFrom-CSV|foreach  {
	$count = $count + 1
	$ssoid = $ssoids[$_.validatedEmail]
	Add-Member -InputObject $_ -NotePropertyName ssoid -NotePropertyValue $ssoid
	$_
	if ($count % 1000 -EQ 0) {
		Write-Host "Read $count ids"
	}
}
