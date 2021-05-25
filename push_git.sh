#!/bin/bash

cd /srv/HuangPingyang1.github.io/
git pull origin main
if [ $? -eq 0 ]
then
	git add .
	git commit -m "build `date`"
	git push origin main
fi

echo -e "\e[36m pushed to github>>> \e[0m"
