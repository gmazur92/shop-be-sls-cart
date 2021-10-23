FROM node:14.17 AS base
WORKDIR app

COPY package*.json ./

RUN echo "Node:" && \
  node -v && \
  echo "NPM:" && \
  npm -v && \
  npm install

COPY . .

RUN npm run build && \
  npm cache clean --force && \
  rm -rf app/src

FROM node:14.17-alpine3.13

WORKDIR app

COPY --from=base /app/node_modules ./node_modules
COPY --from=base /app/dist ./dist

EXPOSE 4000

ENTRYPOINT ["node", "dist/main.js"]
