# ⚡ Guía Rápida - Subir a Plesk en 10 minutos

## 🎯 Resumen Rápido
1. Preparar archivos localmente
2. Subir por FTP o Panel
3. Configurar base de datos
4. Configurar Node.js
5. Listo!

---

## 📦 PASO 1: Preparar Archivos Localmente

Ejecuta este comando:
```bash
./prepare-for-upload.sh
```

Esto creará `plesk-upload.zip` con todo listo.

---

## 📤 PASO 2: Subir a Plesk

### Opción A: Panel de Archivos (Más fácil)
1. Plesk → **Archivos**
2. Click **Subir**
3. Selecciona `plesk-upload.zip`
4. Click derecho → **Extraer**

### Opción B: FTP
1. Abre FileZilla
2. Conecta con tus credenciales FTP
3. Sube el contenido de `plesk-upload/` a `httpdocs/`

---

## 🗄️ PASO 3: Base de Datos

1. Plesk → **Bases de datos** → **Agregar base de datos**
   ```
   Nombre: oauth_google
   Usuario: oauth_user
   Password: [click generar]
   ```

2. Click en **phpMyAdmin**
3. Selecciona `oauth_google`
4. Tab **Importar** → Selecciona `init-db.sql` → **Continuar**

---

## 🚀 PASO 4: Configurar Node.js

1. Plesk → **Node.js**

2. **Configuración básica:**
   ```
   Node.js version: 18.x
   Document Root: /client/dist
   Application Root: /
   Application File: server.js
   ```

3. **Variables de entorno** (click en Application Variables):

   Copia y pega (reemplaza los valores entre []):
   ```
   NODE_ENV=production
   PORT=5000
   DB_HOST=localhost
   DB_PORT=3306
   DB_NAME=oauth_google
   DB_USER=oauth_user
   DB_PASSWORD=[password del paso 3]
   GOOGLE_CLIENT_ID=[tu-client-id-google]
   GOOGLE_CLIENT_SECRET=[tu-secret-google]
   GOOGLE_CALLBACK_URL=https://[tudominio.com]/auth/google/callback
   CLIENT_URL=https://[tudominio.com]
   SERVER_URL=https://[tudominio.com]
   SESSION_SECRET=sdfj348fj34jf934jf93j4f93j4f
   JWT_SECRET=dsfkj3948fj349fj349fj34f9j34f9
   ```

4. Click **NPM Install**
5. Click **Restart App**

---

## 🔧 PASO 5: Configurar Nginx

1. Plesk → **Apache & nginx Settings**

2. En **Additional nginx directives**, pega:
   ```nginx
   location /auth {
       proxy_pass http://127.0.0.1:5000;
       proxy_http_version 1.1;
       proxy_set_header Upgrade $http_upgrade;
       proxy_set_header Connection 'upgrade';
       proxy_set_header Host $host;
   }

   location /api {
       proxy_pass http://127.0.0.1:5000;
       proxy_http_version 1.1;
       proxy_set_header Upgrade $http_upgrade;
       proxy_set_header Connection 'upgrade';
       proxy_set_header Host $host;
   }

   location / {
       try_files $uri $uri/ /index.html;
   }
   ```

3. Click **OK**

---

## 🔐 PASO 6: Google OAuth

1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. **APIs y servicios** → **Credenciales**
3. Edita tu OAuth 2.0 Client
4. Agrega:
   - Orígenes: `https://tudominio.com`
   - Redirect URI: `https://tudominio.com/auth/google/callback`

---

## ✅ LISTO!

Visita `https://tudominio.com` y prueba el login con Google.

---

## 🆘 Problemas Comunes

### "502 Bad Gateway"
- Plesk → Node.js → **Restart App**

### "Cannot connect to database"
- Verifica password de DB en variables de entorno
- Confirma que la DB existe en phpMyAdmin

### "Google OAuth error"
- Verifica CLIENT_ID y SECRET
- Confirma que la URL callback es exacta

### Ver logs:
- Plesk → Node.js → **Show Logs**

---

## 📱 Comandos Útiles (si tienes SSH)

```bash
# Ver logs en tiempo real
tail -f ~/httpdocs/logs/out.log

# Reiniciar app
cd ~/httpdocs && npm restart

# Verificar DB
mysql -u oauth_user -p oauth_google -e "SHOW TABLES;"
```