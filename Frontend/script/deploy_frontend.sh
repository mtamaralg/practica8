#!/bin/bash

# Importa las variables configuradas en el archivo .env para usarlas en este script
source .env

# Elimina el archivo index.html por defecto de Apache para que no bloquee la visualización de WordPress
sudo rm -f /var/www/html/index.html

# Descarga la última versión oficial de WordPress en formato comprimido dentro de la carpeta /tmp
wget https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz

# Descomprime el archivo descargado directamente en el directorio web (/var/www/html) omitiendo la carpeta raíz del zip
sudo tar -xvzf /tmp/wordpress.tar.gz -C /var/www/html/ --strip-components=1

# Copia la plantilla de configuración de ejemplo para crear el archivo wp-config.php definitivo
sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

# Modifica con 'sed' el archivo wp-config.php reemplazando los textos genéricos por tus variables del .env
sudo sed -i "s/database_name_here/$DB_NAME/" /var/www/html/wp-config.php
sudo sed -i "s/username_here/$DB_USER/" /var/www/html/wp-config.php
sudo sed -i "s/password_here/$DB_PASS/" /var/www/html/wp-config.php
sudo sed -i "s/localhost/$IP_SERVIDOR_MYSQL/" /var/www/html/wp-config.php

# Cambia el propietario de todos los archivos al usuario 'www-data' (el usuario interno que usa Apache)
sudo chown -R www-data:www-data /var/www/html/

# Configura los permisos de seguridad estándar (directorios legibles y ejecutables) para la web
sudo chmod -R 755 /var/www/html/

# Elimina el archivo comprimido temporal para mantener limpio el almacenamiento del servidor
rm /tmp/wordpress.tar.gz