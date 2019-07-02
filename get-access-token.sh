#!/bin/bash
source authorization
if [ -z "$clientId" ]
then
	echo "clientId is missing in the authorization file"
	exit 1
fi
if [ -z $clientSecret ]
then
	echo "clientSecret is missing in the authorization file"
	exit 2
fi
user="$clientId:$clientSecret"
curl https://auth.medielogin.dk/connect/token -X POST  -d "grant_type=client_credentials&scope=userservice" --user "$user" |jq -r .access_token
