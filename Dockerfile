FROM node:10-alpine AS builder

COPY . /app/

WORKDIR /app

RUN ["yarn"]

RUN ["yarn", "build"]

#------------------------------------------------------

FROM nginx:1.17-alpine

RUN ["mkdir", "-p", "/www/volca/dist"]

COPY --from=builder /app/dist /www/volca/dist

COPY --from=builder /app/nginx.conf /etc/nginx/nginx.conf
