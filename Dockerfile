# Usa la última imagen base de Alpine
FROM alpine:latest

# Actualiza los índices de paquetes y configura el entorno de trabajo
RUN apk update && apk add --no-cache bash nano git wget zip unzip

WORKDIR /root

# Crea los directorios necesarios y copia el script de compilación
RUN mkdir -p /etc/nginx/conf.d /etc/nginx/ssl
COPY Files/compile.sh /root/

# Asegúrate de que el script sea ejecutable y compila Nginx con ModSecurity
RUN chmod +x /root/compile.sh && /root/compile.sh

# Copia los archivos de configuración al contenedor
COPY nginx.conf /usr/local/nginx/conf/nginx.conf
COPY modsecurity.conf /usr/local/nginx/conf/modsecurity/modsecurity.conf
COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY Files/unicode.mapping /usr/local/nginx/conf/modesecurity/unicode.mapping
# Haz que el entrypoint script sea ejecutable
RUN chmod +x /docker-entrypoint.sh

# Expone los puertos para HTTP y HTTPS
EXPOSE 80 443

# Establece el punto de entrada del contenedor
ENTRYPOINT ["/docker-entrypoint.sh"]

# Define el comando por defecto
#CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]