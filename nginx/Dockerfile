FROM docker.io/nginx:alpine

ADD config/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80 443

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]