#!/usr/bin/env bash

export filename=mula-httpd-logs-$(date '+%d%m%Y-%H%M%S').tar
export filenameWeb=inventory.html
export name="mula"
export s3_bucket="upgrad-$name"
## checking packages for upgrades
apt update -y

## checking httpd installed
which apache2
RETURN=$?

if [ $RETURN == 0 ]; then
		echo "apache is already installed"
	else
			sudo apt-get update -y 
				sudo apt install apache2
			fi

## checking apache is running or not

RETURN=`systemctl apache2 status | grep -i running | wc -l`

if [ $RETURN == 1 ]; then
   echo "apache is already Running!"
else
   sudo systemctl start apache2 
fi

sudo systemctl enable apache2

cd /var/log/apache2
tar cvf /tmp/${filename} access.log error.log

#archiving log files from tmp to S3

cd /tmp/
aws s3 cp /tmp/$filename s3://$s3_bucket
