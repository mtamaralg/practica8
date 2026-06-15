# Práctica 1.8 — Arquitectura LAMP en dos niveles con WordPress en AWS

**Despliegue de Aplicaciones Web · Curso 2023/2024**

---

## Descripción

En esta práctica se automatiza la instalación y configuración de una aplicación web **LAMP** distribuida en **dos máquinas virtuales EC2** de Amazon Web Services (AWS), con Ubuntu Server. La arquitectura separa la capa de *front-end* (Apache + PHP + WordPress) y la capa de *back-end* (MySQL) en instancias independientes.

### Arquitectura de dos niveles

```
Internet
   │
   ▼
┌─────────────────────────┐
│  Front-end (EC2)        │
│  Apache HTTP Server     │
│  PHP                    │
│  WordPress              │
└────────────┬────────────┘
             │ Red privada AWS
             ▼
┌─────────────────────────┐
│  Back-end (EC2)         │
│  MySQL Server           │
└─────────────────────────┘
```

---

## Estructura del repositorio

```
practica8/
├── README.md
├── Frontend/
│   └── install_frontend.sh     # Script de instalación del front-end (Apache, PHP, WordPress)
└── Backend/
    └── script/
        └── install_backend.sh  # Script de instalación del back-end (MySQL)
```

---

## Descripción del proceso de instalación

### 1. Creación de instancias EC2 en AWS

Se crean dos instancias EC2 en AWS con la última versión de Ubuntu Server:

- **Instancia Front-end**: ejecuta Apache HTTP Server, PHP y WordPress.
- **Instancia Back-end**: ejecuta MySQL Server.

Ambas instancias deben estar en la misma red privada de AWS para que puedan comunicarse entre sí.

---

### 2. Configuración del Back-end (MySQL)

#### 2.1. Instalación de MySQL Server

```bash
sudo apt update
sudo apt install -y mysql-server
```

#### 2.2. Permitir conexiones remotas

Se edita el archivo de configuración de MySQL:

```
/etc/mysql/mysql.conf.d/mysqld.cnf
```

Se localiza la directiva `bind-address` y se modifica para aceptar conexiones desde la red privada de AWS:

```ini
[mysqld]
bind-address = 0.0.0.0
```

Se reinicia el servicio:

```bash
sudo systemctl restart mysql
```

#### 2.3. Creación de la base de datos y usuario para WordPress

```sql
CREATE DATABASE wordpress_db;
CREATE USER 'wp_user'@'%' IDENTIFIED BY 'wp_password';
GRANT ALL PRIVILEGES ON wordpress_db.* TO 'wp_user'@'%';
FLUSH PRIVILEGES;
```

> **Nota:** En un entorno de producción se recomienda restringir el acceso del usuario a la IP privada del servidor front-end en lugar de usar `%`.

---

### 3. Configuración del Front-end (Apache + PHP + WordPress)

#### 3.1. Instalación de Apache y PHP

```bash
sudo apt update
sudo apt install -y apache2
sudo apt install -y php libapache2-mod-php php-mysql php-curl php-gd \
    php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip
```

#### 3.2. Descarga y configuración de WordPress

```bash
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
sudo cp -r wordpress/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/
```

#### 3.3. Configuración de WordPress para conectar con el Back-end

Se copia el archivo de configuración de ejemplo y se editan los parámetros de conexión a la base de datos:

```bash
sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
```

Se configuran los siguientes valores apuntando a la IP privada de la instancia de MySQL:

```php
define('DB_NAME',     'wordpress_db');
define('DB_USER',     'wp_user');
define('DB_PASSWORD', 'wp_password');
define('DB_HOST',     'IP_PRIVADA_BACKEND');
```

#### 3.4. Configuración de Apache

Se habilita el módulo `rewrite` para que WordPress pueda usar URLs amigables:

```bash
sudo a2enmod rewrite
sudo systemctl restart apache2
```

Se configura el virtualhost en `/etc/apache2/sites-available/000-default.conf` para que `AllowOverride` esté en `All`.

---

### 4. Comprobación de la conectividad entre instancias

Desde la instancia front-end, verificar que es posible conectarse al servidor MySQL:

```bash
mysql -h IP_PRIVADA_BACKEND -u wp_user -p wordpress_db
```

Si la conexión falla, comprobar:

- Que el grupo de seguridad de la instancia back-end permite el tráfico TCP en el puerto **3306** desde la IP privada del front-end.
- Que el valor de `bind-address` en MySQL es correcto.
- Que el usuario tiene los privilegios necesarios.

---

## Scripts de Bash

### `Backend/script/install_backend.sh`

Script de automatización de la instalación y configuración de MySQL Server en la instancia back-end.

Acciones que realiza:

1. Actualización del sistema (`apt update` y `apt upgrade`).
2. Instalación de MySQL Server.
3. Modificación del archivo `mysqld.cnf` para permitir conexiones remotas.
4. Reinicio del servicio MySQL.
5. Creación de la base de datos y el usuario de WordPress con los privilegios necesarios.

### `Frontend/install_frontend.sh`

Script de automatización de la instalación y configuración del servidor web en la instancia front-end.

Acciones que realiza:

1. Actualización del sistema.
2. Instalación de Apache HTTP Server.
3. Instalación de PHP y los módulos necesarios para WordPress.
4. Descarga e instalación de WordPress en `/var/www/html/`.
5. Configuración del archivo `wp-config.php` con los datos de conexión al back-end.
6. Configuración de permisos del directorio web.
7. Habilitación del módulo `rewrite` de Apache y reinicio del servicio.

---

## Referencias

- [Wikipedia — LAMP](https://es.wikipedia.org/wiki/LAMP)
- [Amazon Web Services](https://aws.amazon.com/es/)
- [Apache HTTP Server](https://httpd.apache.org)
- [PHP](https://www.php.net)
- [MySQL](https://www.mysql.com)
- [WordPress](https://wordpress.org)
- [Práctica 1.8 — José Juan Sánchez](https://josejuansanchez.org/daw/practica-01-08/index.html)

---

## Licencia

Este repositorio se publica con fines educativos en el marco del módulo de **Despliegue de Aplicaciones Web**.
