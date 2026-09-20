FROM node:24-bookworm-slim
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev --ignore-scripts && mkdir /data && chown node:node /data
COPY --chown=node:node public ./public
COPY --chown=node:node server ./server
COPY --chown=node:node drizzle ./drizzle
USER node
ENV NODE_ENV=production PORT=3000 DB_PATH=/data/poker.sqlite
EXPOSE 3000
CMD ["node","server/node.mjs"]
