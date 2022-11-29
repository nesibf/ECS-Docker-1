
FROM ubuntu
ARG file_path
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install apache2 -y
RUN apt-get install apache2-utils -y
RUN rm /var/www/html/index.html
COPY  $file_path /var/www/html
EXPOSE 80
CMD ["apache2ctl","-D","FOREGROUND"]








