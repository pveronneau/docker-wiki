FROM docker.io/nginx:alpine
COPY config/default.conf /etc/nginx/conf.d/
STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]