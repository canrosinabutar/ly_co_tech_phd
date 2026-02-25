FROM node:20-alpine
WORKDIR /ghost
COPY package*.json ./
RUN npm install > /dev/null 2>&1
COPY tsconfig.json .
COPY src ./src
# Jalankan Actor sebagai proses utama (menunggu interaksi user)
ENTRYPOINT ["npx", "ts-node", "src/actor/ghost-actor.ts"]
