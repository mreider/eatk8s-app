FROM node:12
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 8080
RUN chmod +x endless.sh
RUN chmod +x grocer-start.sh
CMD [ "node", "app.js" ]