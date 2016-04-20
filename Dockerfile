FROM nginx:stable
MAINTAINER G5 Engineering <engineering@getg5.com>

STOPSIGNAL SIGQUIT

COPY index.html /usr/share/nginx/html/
COPY servers.conf /etc/nginx/conf.d/
