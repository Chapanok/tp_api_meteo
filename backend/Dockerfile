# ---- Stage 1 : installer les dépendances ----
FROM node:20-alpine AS deps
WORKDIR /app
COPY package.json ./
RUN npm install --omit=dev

# ---- Stage 2 : image finale slim ----
FROM node:20-alpine
WORKDIR /app
# Copier uniquement node_modules depuis le stage précédent
COPY --from=deps /app/node_modules ./node_modules
COPY . .
EXPOSE 3000
# Utilisateur non-root pour la sécurité
USER node
CMD ["node", "server.js"]
