#!/bin/bash

echo "Starting deployment to Plesk..."

# Install backend dependencies
echo "Installing backend dependencies..."
npm install

# Build frontend
echo "Building frontend..."
cd client
npm install
npm run build
cd ..

# Create logs directory if it doesn't exist
mkdir -p logs

# Create .env file from example if it doesn't exist
if [ ! -f .env ]; then
    echo "Creating .env file..."
    cp .env.example .env
    echo "Please update .env file with your Google OAuth credentials and MariaDB connection details"
fi

# Install PM2 globally if not installed
if ! command -v pm2 &> /dev/null; then
    echo "Installing PM2..."
    npm install -g pm2
fi

# Start/Restart the application with PM2
echo "Starting application with PM2..."
pm2 stop oauth-google-app 2>/dev/null
pm2 delete oauth-google-app 2>/dev/null
pm2 start ecosystem.config.js

# Save PM2 configuration
pm2 save
pm2 startup

echo "Deployment complete!"
echo "Don't forget to:"
echo "1. Update .env file with your Google OAuth credentials"
echo "2. Configure MariaDB connection in .env (DB_USER, DB_PASSWORD, etc.)"
echo "3. Run init-db.sql script in phpMyAdmin or MariaDB console"
echo "4. Set up reverse proxy in Plesk to port 5000"
echo "5. Configure Google OAuth redirect URI to your domain"