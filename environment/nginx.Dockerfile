FROM nginx:1.19
RUN apt-get update -y \
   && apt-get install -y nano

COPY ./configs/nginx/default.conf /etc/nginx/conf.d/