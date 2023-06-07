FROM ruby:2.6
FROM node:15
WORKDIR /src/rg-ops
COPY package*.json app.js ./
RUN npm install
EXPOSE 3000
CMD ["node", "app.js"]

ENV BASIC_AUTH_USER=admin
ENV BASIC_AUTH_PASSWORD=super-secret-password
