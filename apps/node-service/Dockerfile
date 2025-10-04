# Stage 1 - build
FROM node:18-alpine AS build

WORKDIR /app
COPY package*.json ./
RUN npm install --production
COPY . .

# Stage 2 - runtime
FROM node:18-alpine

WORKDIR /app
COPY --from=build /app /app
EXPOSE 3000

CMD ["npm", "start"]

