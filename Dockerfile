FROM node:16.19.0-alpine AS prod
WORKDIR /app
COPY package.json ./
RUN npm install --production

FROM node:16.19.0-alpine AS builder
WORKDIR /app
COPY package.json tsconfig.json /app/
RUN npm install
COPY . .
RUN npm run build

FROM node:16.19.0-alpine AS runner
COPY --from=prod /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./package.json
CMD ["npm", "run", "start"]