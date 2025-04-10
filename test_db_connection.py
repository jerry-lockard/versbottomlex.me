import os
import sys
import psycopg2

connection_string = "postgres://dakota:12232015@localhost:5432/versbottomlex"

try:
    # Connect to the database
    conn = psycopg2.connect(connection_string)
    
    # Create a cursor
    cur = conn.cursor()
    
    # Execute a test query
    cur.execute("SELECT 'Connection successful!' AS status;")
    
    # Fetch and print the result
    result = cur.fetchone()
    print(result[0])
    
    # Close the cursor and connection
    cur.close()
    conn.close()
    
    sys.exit(0)
except Exception as e:
    print(f"Error: {e}")
    sys.exit(1)
