#!/bin/bash

# Start SQL Server in the background
/opt/mssql/bin/sqlservr &

# Wait for SQL Server to be ready
echo "Waiting for SQL Server to start..."
for i in {1..50};
do
    /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "$MSSQL_SA_PASSWORD" -Q "SELECT 1" > /dev/null 2>&1
    if [ $? -eq 0 ]
    then
        echo "SQL Server is up and running!"
        break
    else
        echo "Not ready yet..."
        sleep 1
    fi
done

# Create the database
echo "Creating database ITIExaminationSystem..."
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "$MSSQL_SA_PASSWORD" -Q "CREATE DATABASE ITIExaminationSystem"

# Run all the SQL scripts in order
echo "Running setup scripts..."
for f in /db-setup/*.sql; do
    echo "Executing $f..."
    /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "$MSSQL_SA_PASSWORD" -d ITIExaminationSystem -i "$f"
done

echo "Database setup completed successfully."

# Keep the container running
tail -f /dev/null