#!/bin/bash

echo "🚀 Preparando proyecto para subir a Plesk..."

# Build frontend
echo "📦 Construyendo frontend React..."
cd client
npm install
npm run build
cd ..

# Crear directorio de subida
echo "📁 Creando directorio para subir..."
mkdir -p plesk-upload

# Copiar archivos necesarios
echo "📋 Copiando archivos necesarios..."
cp -r config plesk-upload/
cp -r models plesk-upload/
cp -r routes plesk-upload/
cp -r client/dist plesk-upload/client/
cp server.js plesk-upload/
cp package.json plesk-upload/
cp package-lock.json plesk-upload/
cp .env.example plesk-upload/
cp init-db.sql plesk-upload/
cp ecosystem.config.js plesk-upload/
cp deploy-plesk.sh plesk-upload/
cp .htaccess plesk-upload/
cp README.md plesk-upload/
cp DEPLOY-PLESK-GUIDE.md plesk-upload/

# Crear .env de producción vacío
echo "🔐 Creando archivo .env de ejemplo..."
cp .env.example plesk-upload/.env.production.example

# Crear ZIP para subir
echo "🗜️ Creando archivo ZIP..."
cd plesk-upload
zip -r ../plesk-upload.zip . -x "*.DS_Store" -x "__MACOSX/*"
cd ..

echo "✅ Preparación completa!"
echo ""
echo "📦 Archivos listos en: ./plesk-upload/"
echo "🗜️ Archivo ZIP creado: ./plesk-upload.zip"
echo ""
echo "📝 Siguientes pasos:"
echo "1. Sube plesk-upload.zip a Plesk via FTP o Panel de Archivos"
echo "2. Extrae el ZIP en httpdocs/"
echo "3. Configura las variables de entorno en Panel Node.js"
echo "4. Ejecuta npm install desde Panel Node.js"
echo "5. Importa init-db.sql en phpMyAdmin"
echo ""
echo "📚 Consulta DEPLOY-PLESK-GUIDE.md para instrucciones detalladas"