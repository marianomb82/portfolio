#!/bin/bash

xCOMPLETED='false'
while [[ $xCOMPLETED=='false' ]]; do
	mysql -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" > /dev/null
	xMYSQL_UP=$?
	echo "xMYSQL_UP=$xMYSQL_UP"
	if [[ $xMYSQL_UP -eq 0 ]]; then
		xCOMPLETED='true'
		echo "xCOMPLETED=$xCOMPLETED"
		mysql -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD -e "SELECT * FROM cds.usuario LIMIT 1;" > /dev/null
		xMYSQL_STATUS=$?
		if [[ $xMYSQL_STATUS -ne 0 ]]; then 
			mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE < /script/localhost.sql  
		fi
		break
	fi
	sleep 5
done
