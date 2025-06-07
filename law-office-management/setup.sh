#!/bin/bash

# Make script executable
chmod +x setup.sh

echo "Setting up Law Office Management System..."

# Install PHP dependencies
echo "Installing PHP dependencies..."
composer install

# Copy environment file
echo "Creating environment file..."
cp .env.example .env

# Generate application key
echo "Generating application key..."
php artisan key:generate

# Install Node.js dependencies
echo "Installing Node.js dependencies..."
npm install

# Build assets
echo "Building assets..."
npm run build

# Create database
echo "Setting up database..."
read -p "Enter your MySQL root password (leave empty if none): " rootpass

if [ -z "$rootpass" ]; then
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS law_office_management;"
else
    mysql -u root -p"$rootpass" -e "CREATE DATABASE IF NOT EXISTS law_office_management;"
fi

# Run migrations and seeders
echo "Running migrations and seeders..."
php artisan migrate:fresh --seed

# Set proper permissions
echo "Setting file permissions..."
chmod -R 775 storage bootstrap/cache
chown -R $USER:www-data storage bootstrap/cache

echo "Setup complete! You can now run the application with:"
echo "php artisan serve"
echo "Visit http://localhost:8000 in your browser"
