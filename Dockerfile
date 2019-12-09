FROM node:10
WORKDIR /user/src/app
COPY package*.json ./
RUN npm install 
copy . .
EXPOSE 4000
CMD ["node", "app/server.js"]