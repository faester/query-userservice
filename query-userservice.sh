#!/bin/bash
accessToken=$(./get-access-token.sh)
authHeader="Authorization: Bearer ${accessToken}"
maxPage=1
currentPage=0

while [ $currentPage -lt $maxPage ]
do
	echo "page $currentPage of $maxPage" >&2
	curl https://userservice.jppol.dk/ssouser.svc/query/?page=$currentPage -H "Content-Type: application/json" -H "${authHeader}" -X PUT -d "'advertizingOptOut==1'" >x.x
	maxPage=$(cat x.x|jq .NumberOfPages)
	cat x.x | jq -r .IdsOfMatchingUsers[] 

	currentPage=$((currentPage+1))
done
