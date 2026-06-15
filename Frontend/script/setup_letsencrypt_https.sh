#!/bin/bash

# Importa las variables del archivo .env (necesita el correo y el dominio de No-IP)
source .env

# Instala la herramienta Certbot y su extensión automatizada para el servidor web Apache
sudo apt-get install -y certbot python3-certbot-apache

# Solicita el certificado SSL/TLS a Let's Encrypt de forma automática, acepta los términos y configura Apache en HTTPS
sudo certbot --apache -m $CERT_EMAIL --agree-tos --no-eff-email -d $CERT_DOMAIN