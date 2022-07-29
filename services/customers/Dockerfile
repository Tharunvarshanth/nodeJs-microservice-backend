FROM node:16.16.0-alpine
WORKDIR /usr/src/app
COPY ./package.json ./
COPY ./.babelrc ./
COPY ./src ./src
RUN npm install
#RUN npm ci --only=production && npm cache clean --force
ENV NODE_ENV production
RUN npm run build
CMD npm start
