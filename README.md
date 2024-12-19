# Portal de SFleet

Este es un proyecto de Ruby on Rails que corre en Docker con SQlite.
Tailwind CSS y Hotwired.

## Requisitos Previos

* Docker

## Configuración Inicial

1. Clonar el repositorio:

```bash
git clone https://github.com/andyro/sfleet_portal.git
```

2. Ingresar al directorio del proyecto:

```bash
cd sfleet_portal
```

3. Iniciar el servidor con Docker:

```bash
docker build -t sfleet_portal .
```

Crea el contenedor y corre el servidor.

```bash
docker create --name sfleet-portal-container -v `pwd`:/sfleet_portal -p 3000:3000 sfleet-portal
```

4. Iniciar el contenedor:

```bash
docker start sfleet-portal-container
```

6. Editar los secrets.

```bash
docker exec -it sfleet-portal-container EDITOR="nano --wait" rails credentials:edit
```

Crear secrets para JWT:

```bash
docker exec -it sfleet-portal-container bundle exec rails secret
```

Copiar el resultado y agregar en `devise_jwt_secret_key`.


El resultado debe ser algo como:

```
secret_key_base: f976c2c43a5131e20a1f8d3b8b129567c63c9e15e4f7e36cb7736b7109ad073fe18a4d6ffa077b6e0db63d9408deaceb31d625e54c1b0cfe0d88fd1cb6bef7e1
devise_jwt_secret_key: 5b377e0b3d702c63d859f92f8c5dbd99fd404150f671065b98a949ff7aebf1658f2eefb38070cd42ae86bfc85751a2ccb9e3a5cd422597d9d37af027eebbd9ef
```

7. Correr las migraciones:

```bash
docker exec -it sfleet-portal-container rails db:migrate
```

6. Correr las seeders:

```bash
docker exec -it sfleet-portal-container rails db:seed
```

7. Acceder a la aplicación en http://localhost:3000/users/sign_in

8. Usar el email `admin@sfleet.com` y la contraseña `12345678` para iniciar sesión.

# API

Para acceder a la API, se debe usar el token de autenticación.

```bash
curl -H "Authorization: Bearer <token>" http://localhost:3000/api/v1/cars
```

Se puede obtener el token de autenticación mediante un login con el email y contraseña del usuario en la ruta `/api/v1/login`.

```bash
curl -X POST -H "Content-Type: application/json" -d '{"email":"admin@sfleet.com","password":"12345678"}' http://localhost:3000/api/v1/login
```

El token se debe usar en el header de la petición como `Authorization: Bearer <token>`.

# API de Servicios de Mantenimiento

Para acceder a la API de servicios de mantenimiento, se debe usar el token de autenticación.

```bash
curl -H "Authorization: Bearer <token>" http://localhost:3000/api/v1/maintenance_services
```

El proyecto cuenta con un 96% de cobertura de pruebas.

Para ejecutar las pruebas:

```bash
docker exec -it sfleet-portal-container bundle exec rspec
```

# Stack Utilizado

* Ruby 3.2.0
* Rails 8.0.1
* SQlite
* Tailwind CSS
* Hotwired
* RSpec
* FactoryBot
* Faker

## Features

* Autenticación
* API REST
* API de Servicios de Mantenimiento con paginación
* API de Mantenimiento de Vehículos con paginación
* Vistas de Mantenimiento de Vehículos
* Búsqueda de Carros por placa y estado
* Vistas de Carros con paginación




