# Image nginx légère (alpine)
FROM nginx:1.27-alpine

# Supprimer la config par défaut
RUN rm /etc/nginx/conf.d/default.conf

# Copier notre config nginx (reverse proxy + static)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copier les fichiers statiques du frontend
COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80

# nginx s'exécute en foreground par défaut dans l'image officielle
CMD ["nginx", "-g", "daemon off;"]
