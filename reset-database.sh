#!/bin/bash

echo "Resetting MoRS Management System Database..."
echo

echo "WARNING: This will completely delete all database data!"
echo "This action cannot be undone!"
echo
read -p "Are you sure you want to continue? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Operation cancelled."
    exit 0
fi

echo
echo "Stopping all containers..."
docker-compose down

echo
echo "Removing database volume..."
if docker volume rm mors_managementsystem_mors_database_data 2>/dev/null; then
    echo "Database volume removed successfully!"
else
    echo "Database volume may not exist or already removed."
fi

echo
echo "Starting system with fresh database..."
docker-compose up --build -d

echo
echo "Database reset complete!"
echo
echo "What happened:"
echo "   Old database completely deleted"
echo "   New database created automatically"
echo "   Latest migrations applied"
echo "   Fresh data seeded"
echo
echo "Available services:"
echo "   API: http://localhost:5000"
echo "   RabbitMQ Management: http://localhost:15672 (user: mors_user, pass: mors_password123)"
echo "   SQL Server: localhost:1433 (user: SA, pass: MoRS_Database123!)"
echo
