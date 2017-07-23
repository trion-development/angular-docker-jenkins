FROM nginx:alpine

EXPOSE 8080
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
RUN chown -R nginx /etc/nginx

COPY dist /usr/share/nginx/html/

CMD ["/bin/sh","-c","nginx -g 'daemon off;'"]

