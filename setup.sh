#!/usr/bin/env bash
mkdir web mysql-data
docker run -ti -v ${PWD}/web:/application webdevops/php-apache:8.3 composer create-project cakephp/app /application/
sudo chown -R 1000:1000 web
