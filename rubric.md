# **Task Manager API Assignment Grading Rubric**

## **Overview**

Implement a Task Manager API using FastAPI and SQLite, then containerize it with Docker. The assignment is graded holistically based on API functionality and containerization.

---

## **Grading Rubric - Total Score: 15 Points**

### **API Implementation Tests (10 Points)**
Each API test is worth **2 points**:

| **Test Name**     | **Description**                                | **Points** |
|-------------------|-------------------------------------------------|------------|
| `test_read_root`  | Tests the root endpoint (`GET /`).               | 2 points   |
| `test_create_task`| Tests creating a task (`POST /tasks/`).          | 2 points   |
| `test_get_tasks`  | Tests retrieving all tasks (`GET /tasks/`).      | 2 points   |
| `test_update_task`| Tests updating a task (`PUT /tasks/{task_id}/`). | 2 points   |
| `test_delete_task`| Tests deleting a task (`DELETE /tasks/{task_id}/`). | 2 points   |

### **Docker Containerization (5 Points)**
All-or-nothing Docker implementation:

| **Component**          | **Requirements**                               | **Points** |
|------------------------|------------------------------------------------|------------|
| **Complete Docker Implementation** | Multi-stage Dockerfile builds successfully, container runs on port 8000, all API endpoints work in container, follows best practices (.dockerignore, non-root user), tests run in container | 5 points   |

---

## **Scoring**

**API Tests (10 points):**
- 5/5 tests passed: 10 points
- 4/5 tests passed: 8 points  
- 3/5 tests passed: 6 points
- 2/5 tests passed: 4 points
- 1/5 tests passed: 2 points
- 0/5 tests passed: 0 points

**Docker (5 points):**
- Complete working Docker implementation: 5 points
- Docker build fails or container doesn't work: 0 points

---

## **Test Descriptions**

### **1. `test_read_root`**
- **Route:** `GET /`
- **Purpose:** Tests that the API returns the correct welcome message.
- **Expected Output:**
  ```json
  {"message": "Welcome to the Cloud Computing!"}
  ```
- **Criteria:** Passes if the response status is `200 OK` and the returned message matches exactly.

---

### **2. `test_create_task`**
- **Route:** `POST /tasks/`
- **Purpose:** Tests creating a new task.
- **Request Body Example:**
  ```json
  {
    "title": "Test Task",
    "description": "This is a test task",
    "completed": false
  }
  ```
- **Criteria:** Passes if the response status is `200 OK` and the returned task matches the request body.

---

### **3. `test_get_tasks`**
- **Route:** `GET /tasks/`
- **Purpose:** Tests retrieving all tasks.
- **Criteria:** Passes if the response status is `200 OK` and all tasks are returned in the correct order.

---

### **4. `test_update_task`**
- **Route:** `PUT /tasks/{task_id}/`
- **Purpose:** Tests updating a task.
- **Request Body Example:**
  ```json
  {
    "title": "Updated Task",
    "description": "Updated description",
    "completed": true
  }
  ```
- **Criteria:** Passes if the task is updated correctly and the updated values are returned.

---

### **5. `test_delete_task`**
- **Route:** `DELETE /tasks/{task_id}/`
- **Purpose:** Tests deleting a task by ID.
- **Criteria:** Passes if the response status is `200 OK` and a success message is returned:
  ```json
  {"message": "Task {task_id} deleted successfully"}
  ```

---

## **Automated Grading with GitHub Actions**

Your assignment will be **automatically graded** using **GitHub Actions** when you push to any branch. The grading workflow performs:

### **API Testing (10 points)**
- Runs all 5 pytest unit tests
- Each passing test awards 2 points
- Tests run in a clean Python 3.12 environment with uv

### **Docker Testing (5 points)** 
- Builds your multi-stage Dockerfile
- Starts the container on port 8000
- Tests all API endpoints with curl commands
- Verifies container follows best practices

### **Viewing Your Grade**

1. **Push your code to GitHub**:
   ```bash
   git add .
   git commit -m "Implement API and Docker"
   git push origin main
   ```

2. **Check GitHub Actions**:
   - Navigate to your repository
   - Click the [**Actions**](images/github_actions_tab.png) tab
   - View the latest workflow run

3. **Successful run** looks like [this](images/successful_action.png)

**Your final grade will be determined by the GitHub Actions results on your latest push to the main branch.**

---

## **Running Tests Locally (Before Submission)**

### **API Tests**
```bash
# Activate virtual environment  
source .venv/bin/activate

# Run all tests
pytest tests/unit/test_server.py -v

# Run specific test
pytest tests/unit/test_server.py::test_create_task -v
```

### **Docker Tests**
```bash
# Build and test container
docker build -t task-manager .
docker run -d -p 8000:8000 --name test-container task-manager

# Test endpoints
curl http://localhost:8000/
curl http://localhost:8000/tasks/

# Cleanup
docker stop test-container && docker rm test-container
```

---

## **Manual Testing with `cURL` (Optional)**
You can manually test your API using **`cURL`** from your local machine (outside the Vagrant box):

### **1. Get Welcome Message (`GET /`)**
```bash
curl -X GET "http://localhost:8000/"
```

### **2. Create a New Task (`POST /tasks/`)**
```bash
curl -X POST "http://localhost:8000/tasks/" -H "Content-Type: application/json" -d '{"title": "Test Task", "description": "Test description", "completed": false}'
```

### **3. Get All Tasks (`GET /tasks/`)**
```bash
curl -X GET "http://localhost:8000/tasks/" -H "accept: application/json"
```

### **4. Update a Task (`PUT /tasks/{task_id}/`)**
```bash
curl -X PUT "http://localhost:8000/tasks/1/" \
-H "Content-Type: application/json" \
-d '{
  "title": "Updated Task Title",
  "description": "Updated task description",
  "completed": true
}'
```

### **5. Delete a Task (`DELETE /tasks/{task_id}/`)**
```bash
curl -X DELETE "http://localhost:8000/tasks/1/" -H "accept: application/json"
```

---

## **Submission Instructions**

1. Implement all endpoints (`GET`, `POST`, `PUT`, `DELETE`) in `server.py`.
2. Run the tests inside the Vagrant box to ensure all tests pass.
3. Push your code to the `main` branch of your GitHub repository.
4. Submit the GitHub repository link for grading.

---

## **Important Notes**

- Do **NOT** modify the `tests.py` file. Any modifications to the test file will result in a **0 score**.
- Ensure all dependencies are installed using:
  ```bash
  uv pip install -e .
  ```
- If you encounter `ModuleNotFoundError`, set the `PYTHONPATH`:
  ```bash
  export PYTHONPATH=.
  ```

---

## **Grading Example**

If you pass the following tests:
- `test_read_root` ✅
- `test_create_task` ✅
- `test_get_tasks` ✅
- `test_update_task` ❌
- `test_delete_task` ❌

Your score is:
```
3 points x 3 tests passed = 9/15 points
```
