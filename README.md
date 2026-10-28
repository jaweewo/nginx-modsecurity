# Nginx con ModSecurity

Imagen Docker de Nginx compilado con el conector de ModSecurity v3 y el módulo NTLM. ModSecurity y OWASP Core Rule Set (CRS) están habilitados en la configuración incluida.

[![CI](https://github.com/jaweewo/nginx-modsecurity/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/jaweewo/nginx-modsecurity/actions/workflows/main.yml)

## Versiones y publicación

- Nginx 1.30.6
- OpenSSL 3.5.x (rama LTS; la imagen se compila con la versión empaquetada por Alpine)
- Alpine Linux 3.24.3
- Imagen: [`jaweewo/nginx-modsecurity:main`](https://hub.docker.com/r/jaweewo/nginx-modsecurity)

Cada actualización de `main` construye la imagen, verifica la configuración y las versiones, prueba una respuesta HTTP y, si las pruebas pasan, publica la etiqueta `main` en Docker Hub.

## Inicio rápido con Docker Compose

Desde la raíz del repositorio, crea `Examples/conf.d` y `Examples/ssl`. Coloca la configuración de tus sitios (`*.conf`) en `Examples/conf.d` y ejecuta:

```sh
docker compose -f Examples/docker-compose.yml up -d
```

Nginx estará disponible en [http://localhost](http://localhost). Puedes comprobar el estado y consultar los logs con:

```sh
docker compose -f Examples/docker-compose.yml ps
docker compose -f Examples/docker-compose.yml logs -f nginx
```

Para detener el servicio:

```sh
docker compose -f Examples/docker-compose.yml down
```

El ejemplo monta la configuración como solo lectura en `/etc/nginx/conf.d`. ModSecurity está activado globalmente en la configuración principal; las reglas CRS incluidas se aplican a las solicitudes de los sitios.

## HTTPS

El ejemplo monta `Examples/ssl` en `/etc/nginx/ssl`, pero no activa HTTPS por defecto: hace falta configurar un servidor TLS y disponer de un certificado y una clave. Por ejemplo, en un archivo `.conf` de `Examples/conf.d`:

```nginx
server {
    listen 443 ssl;
    server_name example.com;

    ssl_certificate /etc/nginx/ssl/fullchain.pem;
    ssl_certificate_key /etc/nginx/ssl/privkey.pem;

    location / {
        return 200 "HTTPS listo\n";
    }
}
```

Coloca los archivos del certificado en `Examples/ssl` y habilita el mapeo del puerto `443` en `Examples/docker-compose.yml` antes de iniciar o recrear el servicio.

## Configuración

Nginx carga los archivos `*.conf` de `/etc/nginx/conf.d`. La configuración principal y las reglas CRS están dentro de la imagen. Si modificas la configuración, puedes validarla con:

```sh
docker compose -f Examples/docker-compose.yml exec nginx \
  /usr/local/nginx/sbin/nginx -t
```

Después de editar archivos montados, recarga Nginx:

```sh
docker compose -f Examples/docker-compose.yml exec nginx \
  /usr/local/nginx/sbin/nginx -s reload
```

> ModSecurity está configurado con `SecRuleEngine On`. Prueba y ajusta tus reglas y exclusiones antes de exponer el servicio a tráfico de producción.
