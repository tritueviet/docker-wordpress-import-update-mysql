#!/bin/sh
if [ $# -eq 0 ]
  then
    echo '#argument is UPDATE or IMPORT. Please check the argument when call script again'
    exit 1
fi

echo $1

echo ">>>>  Setup database initialization <<<<"

while true
do
    netstat -uplnt | grep :3306 | grep LISTEN > /dev/null
    verifier=$?
    if [ 0 = $verifier ]
        then
			if [ $1 = "IMPORT" ];
				then
					#write some IMPORT in "" here
					echo "Running MYSQL IMPORT =>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
					/usr/bin/mysql --user=$MYSQL_USER --password=$MYSQL_PASSWORD --force --database=$MYSQL_DATABASE < file.sql
					echo "IMPORT DONE"
					/usr/bin/mysql --user=$MYSQL_USER --password=$MYSQL_PASSWORD --execute "UPDATE ${MYSQL_DATABASE}.wp_options SET option_value = 'https://viettelpost.com.vn' WHERE option_id = 1 or option_id = 2;"
				else
					#write some UPDATE in "" here, update split with ;
					/usr/bin/mysql --user=$MYSQL_USER --password=$MYSQL_PASSWORD --execute ""
			fi
            break
        else
            echo "MYSQL is not running yet"
            sleep 2
    fi
done

echo ">>>>>>>> DONE SCRIPT!"
exit 1
