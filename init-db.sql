-- Script para inicializar la base de datos en MariaDB/MySQL
-- Ejecutar este script en Plesk o en tu servidor MariaDB

-- Crear la base de datos si no existe
CREATE DATABASE IF NOT EXISTS oauth_google CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Usar la base de datos
USE oauth_google;

-- Crear tabla de usuarios si no existe
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  googleId VARCHAR(255) UNIQUE,
  email VARCHAR(255) NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL,
  picture VARCHAR(500),
  provider VARCHAR(50) DEFAULT 'google',
  lastLogin DATETIME DEFAULT CURRENT_TIMESTAMP,
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_email (email),
  INDEX idx_googleId (googleId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Crear usuario para la aplicación (opcional, recomendado para producción)
-- Reemplaza 'tu_password' con una contraseña segura
-- CREATE USER IF NOT EXISTS 'oauth_user'@'localhost' IDENTIFIED BY 'tu_password';
-- GRANT ALL PRIVILEGES ON oauth_google.* TO 'oauth_user'@'localhost';
-- FLUSH PRIVILEGES;