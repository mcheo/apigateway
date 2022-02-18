#!/bin/sh

echo "Copy these version of files to respective folders"

cp dashboard.conf ../nginx/dashboard.conf

cp docker-compose.yml ../docker-compose.yml

cp nginx.conf ../nginx/nginx.conf

cp prometheus.yml ../prometheus.yml 
