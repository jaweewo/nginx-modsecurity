# nginx-modsecurity
This repo contains the files for launching Nginx with modsecurity on a docker container.
## HOW TO USE
Just map a volume matching /etc/nginx/conf.d and put your conf files inside.

Example: 
docker run -v /my/folder/configs:/etc/nginx/conf.d --name nginx jaweewo/nginx-modsec:latest
