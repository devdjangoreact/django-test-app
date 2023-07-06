#!/usr/bin/env bash

export IMAGE_django_web=$1
export IMAGE_nginx_proxy=$2

# chmod +r .env
ls -a

docker compose -f docker-compose.prod-deploy.yml up --detach
echo "success"
