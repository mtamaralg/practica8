#!/bin/bash

# Actualiza la lista de paquetes disponibles en los repositorios de Ubuntu
sudo apt-get update

# Instala el servidor de bases de datos MySQL Server
sudo apt-get install -y mysql-server

# Reemplaza la directiva bind-address de '127.0.0.1' a '0.0.0.0' para que MySQL escuche conexiones externas
sudo sed -i "s/^bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

# Reinicia el servicio de MySQL para aplicar la nueva configuración de red y permitir accesos remotos
sudo systemctl restart mysql