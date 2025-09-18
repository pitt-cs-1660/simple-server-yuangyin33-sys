# **Phase 1: Local Development Setup**

## **Prerequisites**
- Python 3.12 or higher
- uv (Fast Python package installer)

## **Installation**

### 1. **Install Python 3.12**
- **Windows**: Download from [python.org](https://www.python.org/downloads/)
- **macOS**: `brew install python@3.12` or download from python.org
- **Linux**: `sudo apt install python3.12 python3.12-venv python3.12-dev`

### 2. **Install uv**
```bash
# macOS/Linux
curl -LsSf https://astral.sh/uv/install.sh | sh

# Windows
powershell -c "irm https://astral.sh/uv/install.ps1 | iex"

# Alternative: pip install uv
pip install uv
```

### 3. **Verify Installations**
```bash
python3.12 --version
uv --version
```

## **Project Setup**

1. **Navigate to project directory**:
   ```bash
   cd cc-simple-server
   ```

2. **Create virtual environment and install dependencies**:
   ```bash
   uv sync
   ```
   
   **Note**: `uv sync` automatically creates a `.venv` virtual environment (equivalent to `python3.12 -m venv .venv`) and installs all dependencies from `pyproject.toml` in one command.

3. **Activate virtual environment**:
   ```bash
   # Linux/macOS
   source .venv/bin/activate
   
   # Windows
   .venv\Scripts\activate
   ```

4. **Test the installation**:
   ```bash
   python -c "import fastapi, uvicorn, pytest; print('All dependencies installed successfully')"
   ```

## **Development Workflow**

1. **Always activate your virtual environment first**:
   ```bash
   source .venv/bin/activate  # Linux/macOS
   # or
   .venv\Scripts\activate     # Windows
   ```

2. **Run the FastAPI server**:
   ```bash
   uvicorn cc_simple_server.server:app --reload --host 127.0.0.1 --port 8000
   ```

3. **Test your setup**:
   - Visit `http://localhost:8000/` - should see welcome message
   - Visit `http://localhost:8000/docs` - should see API documentation

## **Testing Your Installation**

Run these commands to verify everything works:

```bash
# 1. Test that dependencies are installed correctly
python -c "import fastapi, uvicorn, pytest; print('All dependencies installed successfully')"

# 2. Run a basic test to verify the project structure
pytest tests/unit/test_server.py::test_read_root -v
```

## **Assignment Tasks**

Implement the following API endpoints in `cc_simple_server/server.py`:

1. **`GET /tasks/`**: Retrieve all tasks from SQLite database
2. **`POST /tasks/`**: Create a new task  
3. **`PUT /tasks/{task_id}/`**: Update existing task
4. **`DELETE /tasks/{task_id}/`**: Delete task

**Note**: The root endpoint `/` is already implemented and returns `{"message": "Welcome to the Cloud Computing!"}`

## **Testing Your Implementation**

```bash
# Run all tests
pytest tests/unit/test_server.py -v

# Run specific test
pytest tests/unit/test_server.py::test_create_task -v

# If you get import errors, ensure virtual environment is activated
source .venv/bin/activate
pytest tests/unit/test_server.py -v
```

## **Troubleshooting**

- **Virtual environment not activated**: Always run `source .venv/bin/activate` first
- **Module not found errors**: Ensure you're in the virtual environment and ran `uv sync`
- **Port 8000 in use**: Use `--port 8001` or kill existing processes  
- **Permission errors**: On Linux/macOS, you may need `python3.12` instead of `python`
- **uv not found**: Make sure uv is installed and in your PATH after installation