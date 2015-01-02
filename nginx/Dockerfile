FROM ubuntu
MAINTAINER goggin13@gmail.com

RUN apt-get update
RUN apt-get install -y vim wget dialog net-tools
RUN apt-get install -y nginx

RUN rm -v /etc/nginx/nginx.conf
ADD nginx.conf /etc/nginx/

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

EXPOSE 80

CMD service nginx start
