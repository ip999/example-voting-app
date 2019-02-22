FROM node:8.15.0-alpine

VOLUME /artillery
WORKDIR /artillery

ADD . /artillery

RUN npm install -g artillery@1.6.0-26 --allow-root --unsafe-perm=true
