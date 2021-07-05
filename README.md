# Bash
## Setup 

You must create a file named `authorization`
This file should define two variables 
`clientId` containing the id of the client and `clientSecret` with the corresponding secret.
Example
```
clientId=028ff56a9da346d999421ec44d74d256
clientSecret=5jyQNyz6A3sUch27C9QqXZUoXSXKRIWWU7EEA6bkj94BckqRAFa0i68MLAQv5zZO
```

## Running
After proper setup, you can run the script 
```
./query-userservice.sh
```

## Testing 
Try to run 
```
./get-access-token.sh
```
to check if setup is correct.


# Powershell
## Setup 
Create a json file containing the desired credentials. The file must be named `secrets.json`.

```
{
	"clientId": "client id here",
	"clientSecret": "client secret goes here"
}
```

## Running 
The script is called query-userservice.ps
```
.\query-userservice.ps1
```

## Examples 

Show birtdate and username for all users matching a query: 
```
 .\Query-UserService.ps1 -queryExpression "Username == ""faester@gmail.com""" -userserviceEndpoint "https://userservicetest.jppol.dk" |.\Get-User.ps1 -userserviceEndpoint "https://userservicetest.jppol.dk" |select -ExpandProperty Properties |select -Property Birthdate,Username
```

Set Gender to null for all users with gender greater than 1.
```
 .\Query-UserService.ps1 -queryExpression "Gender > 1" |.\Get-User.ps1 |.\Update-User.ps1 -properties @{Gender=$null}
```

Block mails
```
 .\Query-UserService.ps1 -queryExpression "created() < 2016/06/01 && MailIsBlocked != 1 && usernameDomain() != ""example.com"""|.\Get-User.ps1 -userserviceEndpoint "https://userservicetest.jppol.dk"|.\Update-User.ps1 -properties @{"MailIsBlocked" = 1} -userserviceEndpoint "https://userservicetest.jppol.dk/"
```

### Validate emails 
```
gc C:\temp\email-validation\subset.csv |.\validate-email.ps1
```

## Read csv and update users 
```
gc .\validatedYouth.csv -TotalCount 2 |ConvertFrom-Csv -Delimiter `t|foreach{ new-object -typename psobject  -property @{ "Properties" = @{ "ValidatedYouth" = ($_.ValidatedYouth  | get-date ).ToString("O")}; "Identifier"=$_.Identifier } }  |.\Update-User-From-Input.ps1 -userserviceEndpoint https://userservice.jppol.dk
```
