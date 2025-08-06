# 📚 Guía Completa de Despliegue en Plesk

## 📋 Preparación Local (Antes de Subir)

### 1. Construir el Frontend
```bash
cd client
npm install
npm run build
cd ..
```

### 2. Preparar archivos para producción
```bash
# Crear archivo .env de producción (no subir el real)
cp .env.example .env.production
```

## 🚀 Métodos para Subir a Plesk

### Opción A: FTP/SFTP (Más común)

1. **Obtener credenciales FTP de Plesk:**
   - Panel Plesk → Sitios web y dominios → Acceso FTP
   - Crear cuenta FTP si no existe

2. **Usar FileZilla o similar:**
   ```
   Host: ftp.tudominio.com o IP del servidor
   Usuario: tu_usuario_ftp
   Password: tu_password_ftp
   Puerto: 21 (FTP) o 22 (SFTP)
   ```

3. **Subir estos archivos/carpetas:**
   ```
   ✅ Subir:
   /config/
   /models/
   /routes/
   /client/dist/     ← Build de React
   server.js
   package.json
   package-lock.json
   .env.example
   init-db.sql
   ecosystem.config.js
   deploy-plesk.sh
   .htaccess

   ❌ NO subir:
   /node_modules/
   /client/node_modules/
   /client/src/      ← Código fuente React
   .env              ← Archivo con credenciales reales
   .git/
   ```

### Opción B: Git (Si tienes SSH)

1. **Conectar por SSH:**
   ```bash
   ssh usuario@tuservidor.com
   ```

2. **Clonar repositorio:**
   ```bash
   cd ~/httpdocs  # o tu directorio web
   git clone https://github.com/tu-usuario/tu-repo.git .
   ```

3. **Instalar dependencias:**
   ```bash
   npm install --production
   ```

### Opción C: Panel de Archivos de Plesk

1. **Acceder al Administrador de Archivos:**
   - Panel Plesk → Archivos
   - Navegar a tu directorio httpdocs

2. **Subir archivo ZIP:**
   - Comprimir proyecto localmente (sin node_modules)
   - Subir ZIP mediante el panel
   - Extraer en el servidor

## ⚙️ Configuración en Plesk

### 1. Crear Base de Datos

1. **Panel Plesk → Bases de datos**
2. **Agregar base de datos:**
   ```
   Nombre: oauth_google
   Usuario: oauth_user
   Password: [generar uno seguro]
   ```

3. **Importar estructura:**
   - Abrir phpMyAdmin
   - Seleccionar base de datos `oauth_google`
   - Importar → Seleccionar `init-db.sql`
   - Ejecutar

### 2. Configurar Node.js

1. **Panel Plesk → Node.js**

2. **Configuración básica:**
   ```
   Node.js version: 18.x o superior
   Document Root: httpdocs/client/dist
   Application Root: httpdocs
   Application Startup File: server.js
   ```

3. **Variables de entorno (IMPORTANTE):**
   Click en "Application Variables" y agregar:
   ```
   NODE_ENV = production
   PORT = 5000
   
   # Base de datos (usar datos de paso 1)
   DB_HOST = localhost
   DB_PORT = 3306
   DB_NAME = oauth_google
   DB_USER = oauth_user
   DB_PASSWORD = [tu_password_db]
   
   # Google OAuth
   GOOGLE_CLIENT_ID = [tu_client_id_de_google]
   GOOGLE_CLIENT_SECRET = [tu_secret_de_google]
   GOOGLE_CALLBACK_URL = https://tudominio.com/auth/google/callback
   
   # URLs
   CLIENT_URL = https://tudominio.com
   SERVER_URL = https://tudominio.com
   
   # Seguridad (generar claves únicas)
   SESSION_SECRET = [genera-una-clave-aleatoria-larga]
   JWT_SECRET = [genera-otra-clave-aleatoria-larga]
   ```

4. **NPM Install:**
   - Click en "NPM Install"
   - Esperar a que termine

5. **Iniciar aplicación:**
   - Click en "Run script" → "start"
   - O click en "Restart App"

### 3. Configurar Proxy Reverso

1. **Panel Plesk → Apache & nginx Settings**

2. **En "Additional nginx directives":**
   ```nginx
   # Proxy para API backend
   location /auth {
       proxy_pass http://127.0.0.1:5000;
       proxy_http_version 1.1;
       proxy_set_header Upgrade $http_upgrade;
       proxy_set_header Connection 'upgrade';
       proxy_set_header Host $host;
       proxy_cache_bypass $http_upgrade;
       proxy_set_header X-Real-IP $remote_addr;
       proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
       proxy_set_header X-Forwarded-Proto $scheme;
   }

   location /api {
       proxy_pass http://127.0.0.1:5000;
       proxy_http_version 1.1;
       proxy_set_header Upgrade $http_upgrade;
       proxy_set_header Connection 'upgrade';
       proxy_set_header Host $host;
       proxy_cache_bypass $http_upgrade;
       proxy_set_header X-Real-IP $remote_addr;
       proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
       proxy_set_header X-Forwarded-Proto $scheme;
   }

   # Servir React app
   location / {
       try_files $uri $uri/ /index.html;
   }
   ```

3. **Aplicar cambios**

### 4. SSL/HTTPS (Importante)

1. **Panel Plesk → SSL/TLS Certificates**
2. **Instalar Let's Encrypt** (gratis):
   - Click "Install"
   - Marcar "www" subdomain
   - Install

## 🔧 Configurar Google OAuth

1. **Ir a [Google Cloud Console](https://console.cloud.google.com/)**

2. **APIs y servicios → Credenciales**

3. **Actualizar URIs autorizadas:**
   ```
   Orígenes autorizados de JavaScript:
   - https://tudominio.com
   - https://www.tudominio.com
   
   URIs de redirección autorizadas:
   - https://tudominio.com/auth/google/callback
   - https://www.tudominio.com/auth/google/callback
   ```

## 📝 Comandos Post-Instalación

### Conectar por SSH (si está disponible):

```bash
# Navegar al directorio
cd ~/httpdocs

# Ver logs de Node.js
tail -f logs/out.log

# Reiniciar aplicación
npm run start

# Verificar que la app está corriendo
curl http://localhost:5000

# Verificar conexión a MariaDB
mysql -u oauth_user -p oauth_google -e "SHOW TABLES;"
```

## 🐛 Solución de Problemas

### Error: "Cannot find module"
```bash
# En Panel Plesk → Node.js
# Click en "NPM Install" nuevamente
```

### Error: "ECONNREFUSED" base de datos
```bash
# Verificar credenciales en variables de entorno
# Verificar que MariaDB está activa en Plesk
```

### Error: "502 Bad Gateway"
```bash
# Reiniciar app desde Panel Node.js
# Verificar puerto 5000 en variables de entorno
# Revisar logs en ~/httpdocs/logs/
```

### La app no carga
```bash
# Verificar que el build de React existe
ls ~/httpdocs/client/dist

# Si no existe, construir:
cd ~/httpdocs/client
npm install
npm run build
```

## ✅ Verificación Final

1. **Visitar:** `https://tudominio.com`
2. **Probar login con Google**
3. **Verificar redirección y dashboard**

## 📱 Monitoreo

### Usando PM2 (si tienes SSH):
```bash
# Instalar PM2
npm install -g pm2

# Iniciar con PM2
pm2 start ecosystem.config.js

# Ver estado
pm2 status

# Ver logs
pm2 logs

# Monitoreo
pm2 monit
```

### Desde Plesk:
- Panel → Node.js → Ver logs
- Panel → Logs → Access/Error logs

## 🔐 Seguridad Final

1. **Cambiar permisos de archivos:**
   ```bash
   chmod 600 .env
   chmod 644 .htaccess
   chmod 755 deploy-plesk.sh
   ```

2. **Actualizar passwords:**
   - Cambiar SESSION_SECRET y JWT_SECRET
   - Usar passwords fuertes para DB

3. **Configurar firewall:**
   - Solo permitir puerto 443 (HTTPS)
   - Bloquear acceso directo a puerto 5000

## 📞 Soporte

Si algo no funciona:
1. Revisar logs en Plesk → Logs
2. Verificar variables de entorno
3. Confirmar que Google OAuth está configurado
4. Revisar que la base de datos fue creada correctamente