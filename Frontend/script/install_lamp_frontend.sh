#!/bin/bash

# Actualiza la lista de paquetes disponibles en los repositorios de Ubuntu
sudo apt-get update

# Instala el servidor web Apache de forma automática sin pedir confirmación (-y)
sudo apt-get install -y apache2

# Instala PHP junto con todas las extensiones que exige WordPress para su correcto funcionamiento
sudo apt-get install -y php libapache2-mod-php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc

# Instala el cliente de MySQL para poder realizar pruebas de conexión hacia el Backend si fuera necesario
sudo apt-get install -y mysql-client

# Reinicia el servicio de Apache para aplicar todos los cambios y cargar los módulos de PHP
sudo systemctl restart apache2