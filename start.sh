#!/bin/sh
if [ $# -eq 0 ]
  then
    echo '#argument is UPDATE or IMPORT. Please check the argument when call script again. With UPDATE, you need add the UPDATE command in script.sh'
    exit 1
fi

databaseName="wordpress"
databaseUserName="wordpress"
databasePassword="wordpress"
databaseRootPass="password"

cp -f docker-compose.yaml docker.txt
cp -f wp-config.php config.txt

sed "s/MYSQL_ROOT_PASSWORD: password/MYSQL_ROOT_PASSWORD: ${databaseRootPass}/" docker.txt > docker1.txt
sed "s/MYSQL_DATABASE: wordpress/MYSQL_DATABASE: ${databaseName}/" docker1.txt > docker2.txt
sed "s/MYSQL_USER: wordpress/MYSQL_USER: ${databaseUserName}/" docker2.txt > docker3.txt
sed "s/MYSQL_PASSWORD: wordpress/MYSQL_PASSWORD: ${databasePassword}/" docker3.txt > docker4.txt
sed "s/WORDPRESS_DB_USER: wordpress/WORDPRESS_DB_USER: ${databaseUserName}/" docker4.txt > docker5.txt
sed "s/WORDPRESS_DB_PASSWORD: wordpress/WORDPRESS_DB_PASSWORD: ${databasePassword}/" docker5.txt > docker6.txt

rm -f docker-compose.yaml
rm -f docker.txt docker1.txt docker2.txt docker3.txt docker4.txt docker5.txt
mv -f docker6.txt docker-compose.yaml


sed "s/define('DB_NAME', 'xxx');/define('DB_NAME', '${databaseName}');/" config.txt > config1.txt 
sed "s/define('DB_USER', 'xxx');/define('DB_USER', '${databaseUserName}');/" config1.txt > config2.txt 
sed "s/define('DB_PASSWORD', 'xxx');/define('DB_PASSWORD', '${databasePassword}');/" config2.txt > config3.txt 

rm -f wp-config.php
rm -f config.txt config1.txt config2.txt
mv -f config3.txt wp-config.php

docker-compose build
docker-compose up -d
echo ">>>>>>>> DONE  CREATE DOCKER .... WAIT FOR CREATE DATABASE"
sleep 3
echo ">>>>>>>> RUN SCRIPT IMPORT"
docker exec -i viettelpost_mysql sh script.sh $1
echo ">>>>>>>> END!"
