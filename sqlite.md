# **SQLite Reference Guide for Task Manager API Assignment**

## **What is SQLite?**

**SQLite** is a lightweight, serverless, self-contained SQL database engine that is commonly used for local storage in applications. It stores the entire database in a single file, making it ideal for prototyping and small applications. Unlike traditional databases, SQLite doesn’t require a separate server process.

**sqlite3** is a built-in Python module that provides an interface to interact with SQLite databases. It allows you to execute SQL queries, manage transactions, and work with database connections. You can find more information in the [SQLite Documentation](https://www.sqlite.org/docs.html).
### **Key Features of SQLite:**
- No setup or configuration is required.
- Database is stored as a single `.db` file.
- SQL syntax is similar to other relational databases like MySQL and PostgreSQL.
- Fast, simple, and portable.

---

## **Using SQLite in Your Assignment**
In this assignment, you will interact with an **SQLite** database using SQL queries within the FastAPI routes. The `database.py` file provides utility functions to initialize the database (`init_db()`) and create a connection (`get_db_connection()`). Each route in `server.py` executes **SQL queries** to perform CRUD operations on the `tasks` table.

### **Database Table Structure:**
| **Column**   | **Type**   | **Description**                |
|--------------|------------|---------------------------------|
| `id`         | `INTEGER`  | Auto-incremented primary key    |
| `title`      | `TEXT`     | Title of the task               |
| `description`| `TEXT`     | Detailed description of the task|
| `completed`  | `BOOLEAN`  | Indicates whether the task is complete |

---

## **SQL Queries You Will Use**
Below is a reference to the types of SQL queries you will use for each CRUD operation.

### **1. Create a Task (`POST /tasks/`)**
To insert a new task into the `tasks` table, use the `INSERT INTO` SQL query:
```sql
INSERT INTO tasks (title, description, completed) VALUES (?, ?, ?)
```
- **Parameters:** `(task_data.title, task_data.description, task_data.completed)`
- The `?` placeholders are replaced with the corresponding values to prevent SQL injection.

**Python Code Example:**
```python
from cc_simple_server.database import get_db_connection 
from cc_simple_server.models import TaskRead
...
conn = get_db_connection()
cursor = conn.cursor()
cursor.execute(
    "INSERT INTO tasks (title, description, completed) VALUES (?, ?, ?)",
    (task_data.title, task_data.description, task_data.completed),
)
conn.commit()

# get the id of the newly created task
task_id = cursor.lastrowid

# fetch the created task to return it
cursor.execute("SELECT * FROM tasks WHERE id = ?", (task_id,))
row = cursor.fetchone()
conn.close()

# convert database row to taskread object
return TaskRead(**dict(row))
```

### **2. Retrieve All Tasks (`GET /tasks/`)**
To fetch all tasks from the database, use the `SELECT` SQL query:
```sql
SELECT * FROM tasks
```
- This query retrieves all columns (`id`, `title`, `description`, `completed`) from the `tasks` table.

**Python Code Example:**
```python
from cc_simple_server.database import get_db_connection 
from cc_simple_server.models import TaskRead
...
conn = get_db_connection()
cursor = conn.cursor()
cursor.execute("SELECT * FROM tasks")
rows = cursor.fetchall()
conn.close()

# convert database rows to taskread objects
return [TaskRead(**dict(row)) for row in rows]
```
- `fetchall()` returns all rows as a list of dictionaries.
- Convert each row to a `TaskRead` object for proper API response format.

### **3. Update a Task (`PUT /tasks/{task_id}/`)**
To update an existing task by its ID, use the `UPDATE` SQL query:
```sql
UPDATE tasks SET title = ?, description = ?, completed = ? WHERE id = ?
```
- **Parameters:** `(task_data.title, task_data.description, task_data.completed, task_id)`
- The `WHERE id = ?` clause ensures only the specified task is updated.

**Python Code Example:**
```python
from fastapi import HTTPException
from cc_simple_server.database import get_db_connection 
from cc_simple_server.models import TaskRead
...
conn = get_db_connection()
cursor = conn.cursor()

# first, check if the task exists
cursor.execute("SELECT * FROM tasks WHERE id = ?", (task_id,))
existing_task = cursor.fetchone()
if not existing_task:
    conn.close()
    raise HTTPException(status_code=404, detail="Task not found")

# update the task
cursor.execute(
    "UPDATE tasks SET title = ?, description = ?, completed = ? WHERE id = ?",
    (task_data.title, task_data.description, task_data.completed, task_id),
)
conn.commit()

# fetch the updated task
cursor.execute("SELECT * FROM tasks WHERE id = ?", (task_id,))
updated_row = cursor.fetchone()
conn.close()

# return the updated task
return TaskRead(**dict(updated_row))
```

### **4. Delete a Task (`DELETE /tasks/{task_id}/`)**
To delete a task by its ID, use the `DELETE` SQL query:
```sql
DELETE FROM tasks WHERE id = ?
```
- **Parameters:** `(task_id,)`

**Python Code Example:**
```python
from fastapi import HTTPException
from cc_simple_server.database import get_db_connection 
...
conn = get_db_connection()
cursor = conn.cursor()

# first, check if the task exists
cursor.execute("SELECT * FROM tasks WHERE id = ?", (task_id,))
existing_task = cursor.fetchone()
if not existing_task:
    conn.close()
    raise HTTPException(status_code=404, detail="Task not found")

# delete the task
cursor.execute("DELETE FROM tasks WHERE id = ?", (task_id,))
conn.commit()
conn.close()

# return success message
return {"message": f"Task {task_id} deleted successfully"}
```

---

## **HTTP Status Codes and Error Handling**

### **HTTP Status Codes:**
- **200 OK**: Successful GET, PUT, DELETE operations
- **404 Not Found**: Task with specified ID does not exist
- **500 Internal Server Error**: Database or server errors (handled automatically by FastAPI)

### **Error Handling Pattern:**
```python
from fastapi import HTTPException

# check if task exists before update/delete operations
cursor.execute("SELECT * FROM tasks WHERE id = ?", (task_id,))
if not cursor.fetchone():
    conn.close()
    raise HTTPException(status_code=404, detail="Task not found")
```

### **Key Points:**
- **Always check existence**: Before updating or deleting, verify the task exists
- **Close connections**: Always close database connections, especially in error cases
- **Use HTTPException**: Raises proper HTTP error responses
- **Parameterized queries**: Always use `?` placeholders to prevent SQL injection

---

## **Additional Tips:**
- **Database Connection:** Ensure that each database connection (`conn`) is properly closed after executing queries to avoid resource leaks.
- **Transactions:** The `conn.commit()` call is used to save changes (insert, update, delete). Without `commit()`, the changes will not be saved.
- **Row Factory:** The database connection uses `sqlite3.Row` factory, allowing access to columns by name and conversion to dictionaries with `dict(row)`.

---

## **Example SQL Flow for CRUD Operations:**

### **Creating a Task (`POST /tasks/`):**
1. The client sends a `POST` request with the task details.
2. The server runs an `INSERT INTO` SQL query to store the task.
3. The server responds with the created task details.

### **Retrieving All Tasks (`GET /tasks/`):**
1. The server runs a `SELECT * FROM tasks` query.
2. The server formats the results and returns them as a list of tasks.

### **Updating a Task (`PUT /tasks/{task_id}/`):**
1. The client sends a `PUT` request with updated task details.
2. The server checks if the task exists (`SELECT * FROM tasks WHERE id = ?`).
3. If the task exists, the server runs an `UPDATE` SQL query.
4. The server responds with the updated task details.

### **Deleting a Task (`DELETE /tasks/{task_id}/`):**
1. The client sends a `DELETE` request for a task ID.
2. The server checks if the task exists.
3. If the task exists, the server runs a `DELETE FROM tasks WHERE id = ?` query.
4. The server responds with a confirmation message.
