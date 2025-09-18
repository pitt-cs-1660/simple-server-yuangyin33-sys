# **Phase 2: Docker Containerization**

## **Prerequisites**
- Complete Phase 1 (API implementation)
- Docker installed on your system
- Working API endpoints with passing tests

## **Installation**

### **Install Docker**
- **Windows/macOS**: Download [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- **Linux**: `sudo apt install docker.io` or use your distribution's package manager

### **Verify Installation**
```bash
docker --version
docker run hello-world
```

## **Assignment Tasks**

Create the following files to containerize your FastAPI application:

### 1. **Create Dockerfile with Multi-Stage Build**

Create a `Dockerfile` in the project root using **multi-stage builds** with these requirements:

**Build Stage:**
- Use Python 3.12 base image
- Install uv package manager
- Set working directory
- Copy `pyproject.toml` 
- Install Python dependencies using uv into a virtual environment

**Final Stage:**
- Use Python 3.12-slim base image (smaller footprint)
- Copy the virtual environment from build stage
- Copy application source code
- Create non-root user for security
- Expose port 8000
- Set CMD to run FastAPI server on `0.0.0.0:8000`

**Note**: SQLite is included with Python's standard library, so no additional system packages are needed.

### 2. **Create .dockerignore**

Create a `.dockerignore` file to exclude unnecessary files:
```
.venv/
__pycache__/
*.pyc
.git/
.gitignore
README.md
*.md
.pytest_cache/
tasks.db
```

### 3. **Build and Test Your Container**

```bash
# Build the Docker image
docker build -t task-manager .

# Run the container
docker run -p 8000:8000 task-manager

# Test the API
curl http://localhost:8000/
curl http://localhost:8000/docs
```

### 4. **Run Tests in Container**

Your Dockerfile should support running tests:
```bash
# Override the command to run tests
docker run --rm task-manager pytest tests/unit/test_server.py -v
```

## **Multi-Stage Build Benefits**

Your multi-stage Dockerfile should demonstrate:
- **Build stage**: Install build tools and dependencies
- **Final stage**: Copy only runtime dependencies (smaller image)
- **Layer optimization**: Efficient caching of dependency installation
- **Security**: Non-root user in final stage

## **Example Multi-Stage Structure**

```dockerfile
# Build stage
FROM python:3.12 as builder
# Install uv and dependencies...

# Final stage  
FROM python:3.12-slim
# Copy venv from builder stage...
```

## **Testing Your Docker Setup**

1. **Build succeeds without errors**:
   ```bash
   docker build -t task-manager .
   ```

2. **Container starts and serves API**:
   ```bash
   docker run -d -p 8000:8000 --name test-container task-manager
   curl http://localhost:8000/
   docker stop test-container && docker rm test-container
   ```

3. **Tests pass inside container**:
   ```bash
   docker run --rm task-manager pytest tests/unit/test_server.py -v
   ```

4. **Check image size** (should be smaller due to multi-stage):
   ```bash
   docker images task-manager
   ```

## **Submission Requirements**

- [ ] `Dockerfile` with multi-stage build
- [ ] `.dockerignore` file
- [ ] Container runs FastAPI server on port 8000
- [ ] All API endpoints work when containerized
- [ ] Tests can be run inside the container
- [ ] Uses non-root user for security
- [ ] Efficient layer caching and small final image size

## **Troubleshooting**

- **Build failures**: Check that uv installation and dependency copying work correctly
- **Port binding issues**: Ensure the server binds to `0.0.0.0:8000`, not `127.0.0.1:8000`
- **File not found errors**: Verify your COPY commands between build stages
- **Permission issues**: Ensure non-root user has proper permissions for copied files
- **SQLite issues**: Python's built-in sqlite3 module should work without additional packages