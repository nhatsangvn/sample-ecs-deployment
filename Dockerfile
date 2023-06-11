FROM node:15.6.0-alpine
WORKDIR /src/rg-ops
COPY package*.json app.js Dockerfile ./
RUN npm install && rm -rf /root/.npm
EXPOSE 3000
CMD ["node", "app.js"]
