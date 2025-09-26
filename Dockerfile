FROM node:18-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm install --omit=dev

COPY . .

# If your project requires a build step (e.g., admin panel), run it
RUN npm run build

EXPOSE 1337
CMD ["npm", "run", "start"]
