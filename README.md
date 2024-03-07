# How to setup dev-enviroment for PHP8.3 and CakePHP 5 in Docker

Feel free to use the files or this documentation to get things up and running!

> [!TIP]
> We need to todo this so the following container and mapping is setup the right way and webroot is available.

First created the basic strucutures:
```shell
mkdir web mysql-data
docker run -v ${PWD}/web:/application webdevops/php-apache:8.3 composer create-project cakephp/app /application/
```
> [!IMPORTANT]
> Now you need to change the ownership of web from root back to your user, thats because the image doesnt support, user-remapping
```shell
chown -R 1000:1000 web/
OR
chown -R username:username web/
```


After saving the following code as `docker-compose.yml`, open a shell to start this with `docker-compose up`. 
```yaml
version: '3'
services:
    mysql8:
        #user: 1000:1000 # Optional
        image: mysql:8
        restart: unless-stopped
        container_name: mysql
        environment:
            MYSQL_ROOT_PASSWORD: root
            MYSQL_DATABASE: my_app
            MYSQL_USER: my_app
            MYSQL_PASSWORD: secret
        volumes:
            - ./mysql-data:/var/lib/mysql
        ports:
            - '9306:3306'

    cakephp:
        #user: 1000:1000 # Optional
        image: webdevops/php-apache:8.3
        restart: unless-stopped
        container_name: cakephp
        depends_on:
            - mysql8
        working_dir: /application/webroot
        volumes:
            - ./web:/application
        environment:
            - WEB_DOCUMENT_ROOT=/application/webroot
            - DATABASE_URL=mysql://my_app:secret@mysql/my_app
        ports:
            - "8099:80"
            
    adminer:
        image: adminer
        restart: always
        ports:
            - 8080:8080
```
In a second shell you can use the following to enter the dev-environment.
```shell
docker exec -ti cakephp bash
```
After that go to http://localhost:8099/ to see your page.
Happy coding! :+1: :sunglasses: 