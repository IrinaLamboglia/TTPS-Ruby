# Avivas Inventory

## Descripción

Avivas Inventory es una aplicación de gestión de inventarios que permite a los administradores, gerentes y empleados gestionar productos, ventas y usuarios. La aplicación está construida con Ruby on Rails y utiliza Devise para la autenticación de usuarios.

## Decisiones de Diseño Importantes

### 1. Autenticación y Autorización
- **Devise**: Se utiliza Devise para la autenticación de usuarios. Los usuarios pueden registrarse, iniciar sesión, recuperar contraseñas y cerrar sesión.
- **Roles de Usuario**: Se implementaron roles de usuario (admin, gerente, empleado, común) para controlar el acceso a diferentes partes de la aplicación. Los roles se gestionan a través de un modelo `Role` asociado al modelo `User`.
  - Los usuarios con rol **común** no tienen permisos en el sistema y no pueden iniciar sesión.
- **Bloqueo de Usuarios**: Se añadió un campo `active` al modelo `User` para indicar si un usuario está activo o bloqueado. Los usuarios bloqueados no pueden iniciar sesión.

### 2. Gestión de Productos
- **CRUD de Productos**: Los administradores, gerentes y empleados pueden crear, leer, actualizar y eliminar productos. 
- **Imágenes de Productos**: Se permite subir imágenes para los productos utilizando Active Storage.

### 3. Gestión de Ventas
- **CRUD de Ventas**: Los administradores, gerentes y empleados pueden crear, leer, actualizar y cancelar ventas. Las ventas canceladas se marcan como "Canceladas" y no se pueden modificar.
- **Paginación**: Se implementó la paginación para la lista de ventas utilizando la gema `kaminari`.

### 4. Gestión de Usuarios
- **CRUD de Usuarios**: Los administradores y gerentes pueden crear, leer, actualizar y eliminar usuarios. Los administradores también pueden activar y desactivar usuarios.
- **Autogestión de Perfil**: Los usuarios pueden editar su propio perfil, pero no pueden desactivar su propia cuenta ni editar su rol.

### Permisos Aplicados
- **Administrador**: Tiene acceso a todas las funcionalidades de la aplicación.
- **Gerente**: Tiene acceso a la administración de productos y ventas y puede gestionar usuarios, pero no puede crear ni modificar usuarios con el rol de administrador.
- **Empleado**: Tiene acceso a la administración de productos y ventas, pero no puede gestionar usuarios.

## Requisitos Técnicos

- Ruby 3.0.0
- Rails 6.1.4
- SQLite 3
- Node.js 14+
- Yarn 1.22+

## Pasos para Hacer Funcionar la Aplicación

### 1. Clonar el Repositorio

```sh
git clone https://github.com/tu-usuario/avivas-inventory.git
cd avivas-inventory
code .
```

### 2. Instalar Dependencias

- bundle install
- yarn install
- bundle update


### 3.Configurar la Bases de Datos
- rails db:create
- rails db:migrate
- rails db:seed
- 
### 4. Precompilar los archivos
- rails assets:precompile

### 5. Iniciar servidor
- rails server

### 6. Acceder a la Aplicación
- Accede al link http://localhost:3000 y navega por la aplicacion Avivas Inventory

### 7. Usuarios de Prueba

Después de correr el seed, puedes ingresar a la aplicación con los siguientes usuarios:

```plaintext
# Admin
Email: admin@example.com
Contraseña: password

# Gerentes
Email: gerente1@example.com
Contraseña: password

Email: gerente2@example.com
Contraseña: password

# Empleados
Email: empleado1@example.com
Contraseña: password

Email: empleado2@example.com
Contraseña: password
```

Este proyecto está licenciado bajo la Licencia MIT. Consulta el archivo LICENSE para más detalles.
