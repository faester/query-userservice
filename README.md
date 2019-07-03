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
