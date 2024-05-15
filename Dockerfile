FROM node:14

WORKDIR /app

COPY . .

RUN npm i sequelize-cli -g
RUN npm install

EXPOSE 5000

CMD [ "npm","start" ]
