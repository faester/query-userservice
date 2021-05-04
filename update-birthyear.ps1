while ($true) {
	.\Query-UserService.ps1 -queryExpression "!isnull(Birthdate) && isnull(BirthYear)" -maxPages 1 -userserviceEndpoint "https://userservicetest.jppol.dk/" |.\Get-User.ps1 -userserviceEndpoint "https://userservicetest.jppol.dk/" | .\update-user.ps1 -properties @{ "BirthYear" = $_.Properties.Birthdate.Year } -userserviceEndpoint "https://userservicetest.jppol.dk" 
	# .\Query-UserService.ps1 -queryExpression "!isnull(Birthdate) && isnull(BirthYear)" -maxPages 1 -userserviceEndpoint "https://userservicetest.jppol.dk/" |.\Get-User.ps1 -userserviceEndpoint "https://userservicetest.jppol.dk/"  |.\Update-User.ps1 -properties @{"BirthYear" = $_.Birthdate.Year } -userserviceEndpoint "https://userservicetest.jppol.dk/"
}

# .\update-birthyear.ps1 |Select -ExpandProperty Properties  |Select Birthdate |foreach{ $_.Birthdate.Year }
