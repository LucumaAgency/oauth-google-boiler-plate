# Google OAuth Boilerplate for Plesk con MariaDB

MVP de autenticación con Google OAuth 2.0 usando React (Vite) y Node.js con MariaDB, optimizado para despliegue en Plesk.

## Características

- ✅ Autenticación con Google OAuth 2.0
- ✅ Frontend React con Vite
- ✅ Backend Node.js con Express
- ✅ MariaDB (integrada en Plesk) para almacenamiento
- ✅ Sequelize ORM para manejo de base de datos
- ✅ JWT para manejo de sesiones
- ✅ Configuración lista para Plesk
- ✅ PM2 para gestión de procesos

## Requisitos Previos

- Node.js 16+
- MariaDB/MySQL (incluida en Plesk)
- Cuenta de Google Cloud Console
- Servidor con Plesk

## Configuración Google OAuth

1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Crea un nuevo proyecto o selecciona uno existente
3. Habilita Google+ API
4. Crea credenciales OAuth 2.0
5. Configura las URIs de redirección:
   - Desarrollo: `http://localhost:5000/auth/google/callback`
   - Producción: `https://tudominio.com/auth/google/callback`

## Instalación Local

### 1. Clonar el repositorio
```bash
git clone [tu-repositorio]
cd oauth-google-boiler-plate
```

### 2. Configurar base de datos MariaDB
```bash
# Conectar a MariaDB/MySQL
mysql -u root -p

# Ejecutar el script de inicialización
source init-db.sql

# O manualmente:
CREATE DATABASE oauth_google;
```

### 3. Configurar variables de entorno
```bash
cp .env.example .env
# Edita .env con tus credenciales de MariaDB y Google OAuth
```

### 4. Instalar dependencias del backend
```bash
npm install
```

### 5. Instalar dependencias del frontend
```bash
cd client
npm install
cd ..
```

### 6. Ejecutar en desarrollo
```bash
# Terminal 1 - Backend
npm run dev

# Terminal 2 - Frontend
npm run client
```

## Configuración en Plesk

### 1. Crear base de datos en Plesk
- Ve a "Bases de datos" en tu panel de Plesk
- Crea una nueva base de datos llamada `oauth_google`
- Crea un usuario con todos los privilegios
- Ejecuta el script `init-db.sql` en phpMyAdmin

### 2. Subir archivos al servidor
Sube todos los archivos a tu directorio en Plesk

### 3. Configurar Node.js en Plesk
- Ve a tu dominio en Plesk
- Configuración de Node.js
- Document Root: `/client/dist`
- Application Root: `/`
- Application Startup File: `server.js`

### 4. Configurar variables de entorno en Plesk
En la configuración de Node.js, agrega las variables de entorno:
```
NODE_ENV=production
DB_HOST=localhost
DB_PORT=3306
DB_NAME=oauth_google
DB_USER=tu_usuario_db
DB_PASSWORD=tu_password_db
GOOGLE_CLIENT_ID=tu_client_id
GOOGLE_CLIENT_SECRET=tu_client_secret
GOOGLE_CALLBACK_URL=https://tudominio.com/auth/google/callback
CLIENT_URL=https://tudominio.com
SERVER_URL=https://tudominio.com
SESSION_SECRET=una_clave_secreta_segura
JWT_SECRET=otra_clave_secreta_segura
```

### 5. Ejecutar script de despliegue
```bash
chmod +x deploy-plesk.sh
./deploy-plesk.sh
```

### 6. Configurar Proxy Reverso en Plesk
- Apache & nginx Settings
- Additional nginx directives:
```nginx
location /auth {
    proxy_pass http://localhost:5000;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $host;
    proxy_cache_bypass $http_upgrade;
}

location /api {
    proxy_pass http://localhost:5000;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $host;
    proxy_cache_bypass $http_upgrade;
}
```

## Estructura del Proyecto

```
oauth-google-boiler-plate/
├── server.js                 # Servidor Express principal
├── package.json             # Dependencias del backend
├── .env                     # Variables de entorno (no subir a git)
├── .env.example            # Ejemplo de variables de entorno
├── init-db.sql             # Script para inicializar MariaDB
├── ecosystem.config.js     # Configuración PM2
├── deploy-plesk.sh        # Script de despliegue
├── .htaccess              # Configuración Apache para Plesk
├── config/
│   ├── database.js        # Configuración de Sequelize/MariaDB
│   └── passport.js        # Configuración de Passport.js
├── models/
│   └── User.js           # Modelo de usuario Sequelize
├── routes/
│   ├── auth.js           # Rutas de autenticación
│   └── user.js           # Rutas de usuario
└── client/               # Frontend React
    ├── package.json
    ├── vite.config.js
    ├── src/
    │   ├── App.jsx
    │   ├── components/
    │   │   ├── Login.jsx
    │   │   ├── Dashboard.jsx
    │   │   ├── AuthSuccess.jsx
    │   │   └── ProtectedRoute.jsx
    │   └── ...
    └── dist/            # Build de producción
```

## API Endpoints

### Autenticación
- `GET /auth/google` - Iniciar login con Google
- `GET /auth/google/callback` - Callback de Google OAuth
- `GET /auth/logout` - Cerrar sesión
- `GET /auth/current` - Obtener usuario actual

### Usuario
- `GET /api/user/profile` - Obtener perfil del usuario (requiere JWT)
- `PUT /api/user/profile` - Actualizar perfil del usuario (requiere JWT)

## Base de Datos

### Tabla: users
| Campo | Tipo | Descripción |
|-------|------|-------------|
| id | INT | ID único del usuario |
| googleId | VARCHAR(255) | ID de Google |
| email | VARCHAR(255) | Email del usuario |
| name | VARCHAR(255) | Nombre del usuario |
| picture | VARCHAR(500) | URL de la foto |
| provider | VARCHAR(50) | Proveedor OAuth |
| lastLogin | DATETIME | Último login |
| createdAt | DATETIME | Fecha de creación |
| updatedAt | DATETIME | Última actualización |

## Seguridad

- Las contraseñas no se almacenan (solo OAuth)
- Tokens JWT con expiración de 7 días
- Sesiones seguras con httpOnly cookies
- Headers de seguridad configurados
- CORS configurado para el dominio específico
- Conexión segura a MariaDB

## Troubleshooting

### Error de conexión a MariaDB
```bash
# Verificar que MariaDB está corriendo
sudo systemctl status mariadb

# En Plesk, verificar en phpMyAdmin
```

### Error de Google OAuth
- Verifica que las URIs de redirección coincidan exactamente
- Asegúrate de que el CLIENT_ID y CLIENT_SECRET sean correctos

### Error en Plesk
- Verifica los logs en `/logs/`
- Revisa la configuración del proxy reverso
- Asegúrate de que el puerto 5000 no esté bloqueado
- Verifica las credenciales de MariaDB en Plesk

### Error de Sequelize
```bash
# Si hay problemas con las tablas, sincroniza manualmente:
node -e "require('./config/database').connectDB()"
```

## Comandos Útiles

```bash
# Verificar conexión a MariaDB
mysql -u tu_usuario -p -h localhost oauth_google

# Ver tablas creadas
SHOW TABLES;

# Ver estructura de la tabla users
DESCRIBE users;

# Reiniciar PM2
pm2 restart oauth-google-app

# Ver logs
pm2 logs oauth-google-app
```

## Licencia

MIT