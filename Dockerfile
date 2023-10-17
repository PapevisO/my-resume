FROM node:16.13.1-alpine

WORKDIR /usr/app

COPY package*.json ./

ENV CHROME_BIN="/usr/bin/chromium-browser" \
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD="true" \
    RESUME_PUPPETEER_NO_SANDBOX="true"

RUN set -x \
    && apk update \
    && apk upgrade \
    && apk add --no-cache \
    udev \
    ttf-freefont \
    chromium \
    && npm install puppeteer@16.1.0

RUN npm install

COPY . .
