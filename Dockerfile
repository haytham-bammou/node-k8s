FROM docker.io/nginx:alpine
COPY dist/ /usr/share/nginx/html
EXPOSE 80
