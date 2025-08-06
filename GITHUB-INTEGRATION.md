# 🔄 Integración GitHub → Plesk

Guía completa para configurar deployment automático desde GitHub a tu servidor Plesk.

## 🎯 Opciones de Integración

### **Opción 1: GitHub Actions (Automático)** ⚡
Deploy automático cada vez que hagas push a `main`

### **Opción 2: Script Manual** 🛠️
Deploy manual ejecutando un script

### **Opción 3: Git Hooks en Plesk** 🔀
Si tu servidor Plesk tiene Git

---

## 🚀 **OPCIÓN 1: GitHub Actions (Recomendado)**

### **1. Configurar Secretos en GitHub:**

Ve a tu repositorio → **Settings** → **Secrets and variables** → **Actions**

Agrega estos secretos:
```
FTP_HOST = tudominio.com
FTP_USERNAME = [tu_usuario_ftp]
FTP_PASSWORD = [tu_password_ftp]
RESTART_WEBHOOK = [opcional - webhook para reiniciar app]
```

### **2. El workflow ya está configurado:**
- Archivo: `.github/workflows/deploy.yml` ✅
- Se ejecuta automáticamente en cada push a `main`

### **3. Qué hace automáticamente:**
1. ✅ Instala dependencias
2. ✅ Construye el frontend React
3. ✅ Prepara archivos para producción
4. ✅ Sube via FTP a Plesk
5. ✅ Reinicia la app (si webhook configurado)

---

## 🛠️ **OPCIÓN 2: Script Manual**

### **En tu máquina local:**

```bash
# Preparar deployment
./deploy-github.sh

# Resultado: carpeta deploy_temp/ lista para subir
```

### **Subir a Plesk:**
1. Comprimir `deploy_temp/` 
2. Subir a Plesk via FTP/Panel
3. Ejecutar `./install.sh` en el servidor

---

## 🔀 **OPCIÓN 3: Git Hooks (Si tienes SSH)**

### **1. Conectar por SSH:**
```bash
ssh usuario@tudominio.com
cd /tu_directorio_web
```

### **2. Clonar repositorio:**
```bash
git clone https://github.com/LucumaAgency/oauth-google-boiler-plate.git .
```

### **3. Configurar webhook para auto-pull:**
```bash
# Crear script de auto-deploy
cat > webhook-deploy.sh << 'EOF'
#!/bin/bash
cd /tu_directorio_web
git pull origin main
npm install --production
cd client && npm install && npm run build && cd ..
pm2 restart oauth-google-app
EOF

chmod +x webhook-deploy.sh
```

---

## 📋 **Configuración Inicial (Una sola vez)**

### **1. Obtener credenciales FTP de Plesk:**
- **Panel Plesk** → **Sitios web y dominios** → **Acceso FTP**
- Crear cuenta FTP si no existe
- Anotar: host, usuario, password

### **2. Configurar Variables de Entorno en Plesk:**
```
NODE_ENV=production
PORT=5000
DB_HOST=localhost
DB_PORT=3306
DB_NAME=[tu_nombre_db]
DB_USER=[tu_usuario_db]
DB_PASSWORD=[tu_password_db]
GOOGLE_CLIENT_ID=[tu_google_client_id]
GOOGLE_CLIENT_SECRET=[tu_google_client_secret]
GOOGLE_CALLBACK_URL=https://tudominio.com/auth/google/callback
CLIENT_URL=https://tudominio.com
SERVER_URL=https://tudominio.com
SESSION_SECRET=[genera_clave_aleatoria_larga]
JWT_SECRET=[genera_otra_clave_aleatoria]
```

### **3. Configurar Node.js en Plesk:**
```
Application Startup File: app.js
Document Root: /tu_dominio/client/dist
Application Root: /tu_dominio
```

---

## 🔄 **Flujo de Trabajo Recomendado**

### **Con GitHub Actions (Automático):**
1. Hacer cambios en tu código local
2. `git add -A && git commit -m "mensaje"`
3. `git push origin main`
4. ✅ GitHub Actions se ejecuta automáticamente
5. ✅ Tu sitio se actualiza en 2-3 minutos

### **Manual:**
1. Ejecutar `./deploy-github.sh` localmente
2. Subir `deploy_temp/` a Plesk
3. Ejecutar `./install.sh` en servidor

---

## 🔧 **Configurar Webhook para Reinicio Automático**

### **En Plesk, crear archivo webhook:**
```php
<?php
// webhook.php - Colocar en httpdocs/
if ($_POST['secret'] === 'tu_secret_seguro') {
    shell_exec('pm2 restart oauth-google-app 2>&1');
    echo "App restarted";
} else {
    http_response_code(403);
    echo "Forbidden";
}
?>
```

### **URL del webhook:**
`https://tudominio.com/webhook.php`

### **Agregar secret en GitHub:**
```
RESTART_WEBHOOK = https://tudominio.com/webhook.php
```

---

## 🐛 **Troubleshooting**

### **GitHub Actions falla:**
- Verificar secretos FTP en GitHub
- Revisar logs en Actions tab
- Verificar permisos FTP

### **Deploy manual no funciona:**
```bash
# Verificar que el script es ejecutable
chmod +x deploy-github.sh

# Ejecutar con debug
bash -x deploy-github.sh
```

### **App no reinicia:**
- Verificar webhook en Plesk logs
- Reiniciar manualmente desde Panel Node.js
- Verificar PM2: `pm2 status`

---

## ⚡ **Siguientes Pasos:**

1. **Configurar GitHub Actions** (Opción 1)
2. **Agregar secretos FTP** en GitHub
3. **Hacer un push** para probar
4. **Verificar** que el sitio se actualiza

¿Cuál opción prefieres configurar primero?