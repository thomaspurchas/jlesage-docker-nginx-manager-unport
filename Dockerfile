#
# nginx-proxy-manager Dockerfile
#
# https://github.com/jlesage/docker-nginx-proxy-manager
#

# Pull base image.
FROM jlesage/nginx-proxy-manager:latest

RUN \
    # Revert the management interface port to the unprivileged port 8181.
    sed-patch 's|8181 default|81 default|' /etc/nginx/conf.d/production.conf && \

    # Revert the HTTP port 80 to the unprivileged port 8080.
    sed-patch 's|8080;|80;|' /etc/nginx/conf.d/default.conf && \
    sed-patch 's|"8080";|"80";|' /etc/nginx/conf.d/default.conf && \
    # Hack in IPv6 support for lets encrypt
    sed-patch 's|listen 8080;|listen 80; listen [::]:80;|' /opt/nginx-proxy-manager/templates/letsencrypt-request.conf && \
    sed-patch 's|listen 8080;|listen 80;|' /opt/nginx-proxy-manager/templates/_listen.conf && \
    sed-patch 's|:8080;|:80;|' /opt/nginx-proxy-manager/templates/_listen.conf && \
    sed-patch 's|listen 8080 |listen 80 |' /opt/nginx-proxy-manager/templates/default.conf && \

    # Revert the HTTPs port 443 to the unprivileged port 4443.
    sed-patch 's|4443 |443 |' /etc/nginx/conf.d/default.conf && \
    sed-patch 's|"4443";|"443";|' /etc/nginx/conf.d/default.conf && \
    sed-patch 's|listen 4443 |listen 443 |' /opt/nginx-proxy-manager/templates/_listen.conf && \
    sed-patch 's|:4443;|:443;|' /opt/nginx-proxy-manager/templates/_listen.conf && \

    # Let nginx bind to low number ports without root
    apk add --no-cache libcap && \
    setcap 'cap_net_bind_service=+ep' /usr/sbin/nginx 


EXPOSE 81 80 443