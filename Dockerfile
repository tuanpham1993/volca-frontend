FROM nginx:1.17-alpine

COPY . .

RUN ["mkdir", "-p", "/www/volca"]

RUN ["cp", "-r", "./dist", "/www/volca/"]

RUN ["cp", "./nginx.conf", "/etc/nginx/nginx.conf"]
