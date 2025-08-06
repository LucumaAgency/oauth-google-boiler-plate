#!/bin/bash

echo "🚀 Deploy automático desde GitHub..."

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Función para log con color
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar que estamos en el directorio correcto
if [ ! -f "app.js" ] || [ ! -f "package.json" ]; then
    log_error "Este script debe ejecutarse desde el directorio raíz del proyecto"
    exit 1
fi

# Crear directorio temporal para deployment
log_info "Creando directorio de deployment..."
rm -rf deploy_temp
mkdir -p deploy_temp

# Instalar dependencias de producción
log_info "Instalando dependencias del backend..."
npm ci --only=production

# Construir frontend
log_info "Construyendo frontend..."
cd client
npm ci
npm run build

if [ ! -d "dist" ]; then
    log_error "Error: No se pudo construir el frontend"
    exit 1
fi

cd ..

# Copiar archivos necesarios
log_info "Preparando archivos para deployment..."
cp -r config models routes deploy_temp/
cp app.js package.json deploy_temp/
cp init-db.sql ecosystem.config.js deploy_temp/
cp .env.example .htaccess deploy_temp/
cp README.md DEPLOY-PLESK-GUIDE.md deploy_temp/

# Verificar que package-lock.json existe antes de copiarlo
if [ -f "package-lock.json" ]; then
    cp package-lock.json deploy_temp/
fi

# Copiar dist del frontend
mkdir -p deploy_temp/client
cp -r client/dist deploy_temp/client/

# Crear script de instalación para el servidor
cat > deploy_temp/install.sh << 'EOF'
#!/bin/bash
echo "🔧 Instalando dependencias en servidor..."
npm install --only=production

echo "🔄 Reiniciando aplicación..."
# Si usas PM2
if command -v pm2 &> /dev/null; then
    pm2 restart oauth-google-app 2>/dev/null || pm2 start app.js --name oauth-google-app
else
    echo "PM2 no encontrado. Reinicia manualmente desde Plesk Node.js"
fi

echo "✅ Deployment completado"
EOF

chmod +x deploy_temp/install.sh

# Mostrar resumen
log_info "Deployment preparado en ./deploy_temp/"
echo ""
echo "📁 Archivos incluidos:"
echo "   ✓ Backend (app.js, config, models, routes)"
echo "   ✓ Frontend construido (client/dist)"
echo "   ✓ Base de datos (init-db.sql)"
echo "   ✓ Configuración (ecosystem.config.js, .htaccess)"
echo "   ✓ Script de instalación (install.sh)"
echo ""
echo "📋 Próximos pasos:"
echo "   1. Subir deploy_temp/ a tu servidor Plesk"
echo "   2. Ejecutar ./install.sh en el servidor"
echo "   3. Configurar variables de entorno en Plesk"
echo ""
log_info "Deployment listo!"