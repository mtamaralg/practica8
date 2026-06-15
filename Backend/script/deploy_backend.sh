#!/bin/bash

# Importa las variables de entorno configuradas en el archivo .env del Backend
source .env

# Abre el intérprete de comandos de MySQL como root de forma local para ejecutar las sentencias SQL siguientes
sudo mysql -u root <<< "
-- Elimina el usuario de WordPress si ya existiera de ejecuciones previas para evitar conflictos
DROP USER IF EXISTS '$DB_USER'@'$IP_MAQUINA_CLIENTE';

-- Crea la base de datos necesaria para WordPress aplicando codificación UTF-8 estándar
CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8 COLLATE utf8_general_ci;

-- Crea el usuario remoto asignándole explícitamente la IP de tu Frontend y su contraseña segura
CREATE USER '$DB_USER'@'$IP_MAQUINA_CLIENTE' IDENTIFIED BY '$DB_PASS';

-- Otorga todos los privilegios de administración sobre la base de datos al usuario remoto recién creado
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'$IP_MAQUINA_CLIENTE';

-- Recarga y actualiza de inmediato las tablas de permisos internos de MySQL para aplicar los cambios
FLUSH PRIVILEGES;
"