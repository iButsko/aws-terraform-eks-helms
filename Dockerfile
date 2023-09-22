FROM nginx:latest


COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /data/www/index.html
COPY api/index.html /data/www/api/index.html
COPY service/index.html /data/www/service/index.html
VOLUME [ "/data/www" ]
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]