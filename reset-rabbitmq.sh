#!/bin/bash

echo "Resetting MoRS Management System RabbitMQ Data..."
echo

echo "WARNING: This will delete all RabbitMQ data!"
echo "This includes queued messages, user preferences, and configurations!"
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
echo "Removing RabbitMQ volume..."
if docker volume rm mors_managementsystem_mors_rabbitmq_data 2>/dev/null; then
    echo "RabbitMQ volume removed successfully!"
else
    echo "RabbitMQ volume may not exist or already removed."
fi

echo
echo "Starting system with fresh RabbitMQ..."
docker-compose up --build -d

echo
echo "Waiting for services to initialize..."
sleep 30

echo
echo "RabbitMQ reset complete!"
echo
echo "What happened:"
echo "   Old RabbitMQ data completely deleted"
echo "   New RabbitMQ created with default settings"
echo "   All queued messages cleared"
echo "   Fresh configuration applied"
echo
echo "Available services:"
echo "   API: http://localhost:5000"
echo "   RabbitMQ Management: http://localhost:15672 (user: mors_user, pass: mors_password123)"
echo "   SQL Server: localhost:1433 (user: SA, pass: MoRS_Database123!)"
echo
echo "You can now run your Flutter desktop and mobile apps!"
