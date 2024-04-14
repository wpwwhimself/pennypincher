FROM node:alpine

WORKDIR /var/www

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

RUN npm run build
CMD ["npm", "run", "start"]