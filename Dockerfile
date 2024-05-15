FROM node:14.21.3-alpine3.17

WORKDIR /app

COPY . .

RUN npm i sequelize-cli -g
RUN npm install

EXPOSE 5000

CMD [ "npm","start" ]
