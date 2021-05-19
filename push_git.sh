#!/bin/bash

cd /srv/HuangPingyang1.github.io/
git pull origin main
git add .
git commit -m "build `date`"
git push origin main
