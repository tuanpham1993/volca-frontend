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

COPY --from=builder /app/cert.pem /etc/ssl/cert.pem

RUN ["cat", "/etc/ssl/cert.pem"]

COPY --from=builder /app/private.pem /etc/ssl/private.pem

RUN ["cat", "/etc/ssl/private.pem"]
