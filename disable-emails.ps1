while ($true) {
	.\Query-UserService.ps1 -queryExpression "created() < 2019/05/01-11:26:00 && MailIsBlocked != 1 && usernameDomain() != ""example.com""" -maxPages 1 -userserviceEndpoint "https://userservicetest.jppol.dk/" |.\Get-User.ps1 -userserviceEndpoint "https://userservicetest.jppol.dk/"  |.\Update-User.ps1 -properties @{"MailIsBlocked" = 1} -userserviceEndpoint "https://userservicetest.jppol.dk/"
}
