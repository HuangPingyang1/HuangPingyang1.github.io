#!/bin/bash

git pull origin main
if [ $? -eq 0 ]
then
	git add .
	git commit -m "build `date`"
	git push origin main
	if [ $? -eq 0 ];then
		echo -e "\e[36m Pushed to GitHub Successfully!! \e[0m"
	fi
fi
