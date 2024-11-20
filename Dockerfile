FROM centos:7
RUN sed -i.bak 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && sed -i.bak 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
yum update -y
WORKDIR /root
RUN mkdir -p /etc/nginx/conf.d /etc/nginx/ssl && yum install nano git wget epel-release zip unzip -y
COPY Files/compile.sh /root/
RUN cd /root && chmod +x compile.sh  && ./compile.sh
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
COPY nginx.conf /usr/local/nginx/conf/nginx.conf
COPY modsecurity.conf /usr/local/nginx/conf/modsecurity/modsecurity.conf
EXPOSE 80:80 443:443
RUN /usr/local/nginx/sbin/nginx 
ENTRYPOINT ["/docker-entrypoint.sh"]

