## Docker Security and Health Check Verification

### 1. Docker Image

- Image: `cloudforge:1.1`
- Base image: `python:3.14-slim`
- Application runs as the non-root user `appuser`.

### 2. Container Security Configuration

The container was started with these restrictions:

- Memory limit: 256 MB
- CPU limit: 1 CPU
- Process limit: 100
- All Linux capabilities dropped
- No-new-privileges enabled
- Read-only root filesystem enabled
- Port bound to localhost (`127.0.0.1:5000`)
- Restart policy: `no`

### 3. Read-Only Filesystem Test

Command:

`sudo docker exec cloudforge-app sh -c 'touch /test-readonly'`

Expected result:

`Read-only file system`

The test confirmed that writing to the container's root filesystem is blocked.

### 4. Health Check

The Dockerfile includes a HEALTHCHECK instruction that checks:

`http://127.0.0.1:5000/health`

Verified container status:

- Status: running
- Health: healthy

### 5. Application Endpoint Tests

| Endpoint | Expected HTTP status | Result |
|---|---|---|
| `/` | 200 OK | Passed |
| `/health` | 200 OK | Passed |
| `/api/info` | 200 OK | Passed |

### 6. Log Review

Container logs confirmed successful Flask startup and repeated successful health-check requests.

Warning observed:

Flask's built-in development server is not suitable for production deployment. A production WSGI server, such as Gunicorn, should be configured before production use.

### 7. Cost and Infrastructure

All testing was performed locally using Docker Desktop and WSL2.

No AWS resources were created.
## 8. Continuous Integration Verification

GitHub Actions workflow: `CloudForge CI`

Trigger: Push to `main` or pull request targeting `main`.

Verified workflow steps:

- Repository checkout: Passed
- Python setup: Passed
- Dependency installation: Passed
- Automated tests: Passed (3 tests)
- Docker image build: Passed
- Job completion: Passed

GitHub Actions run:
- Commit: `90f584f`
- Branch: `main`
- Overall result: Success
- Total workflow duration: 29 seconds

The CI workflow validates the application and builds
the Docker image on a GitHub-hosted runner.

No AWS infrastructure was deployed by this workflow.

## 9. Enhanced Continuous Integration Verification

GitHub Actions workflow: `CloudForge CI`

Commit: `4c2b505`

Branch: `main`

GitHub Actions run: #3

Overall result: Success

Total workflow duration: 20 seconds

Verified workflow steps:

- Repository checkout: Passed
- Python setup (3.14): Passed
- Dependency installation: Passed
- Python syntax check (`compileall`): Passed
- Dependency consistency check (`pip check`): Passed
- Automated tests: Passed (3 tests)
- Docker image build: Passed
- Job completion: Passed

Additional local verification:

- Python syntax compilation: Passed
- Dependency consistency: No broken requirements found
- Pytest: 3 tests passed
- Docker image `cloudforge:ci`: Built successfully

The enhanced CI pipeline checks Python syntax and dependency
consistency before running tests and building the Docker image.

The workflow runs on GitHub-hosted infrastructure.

No AWS resources were created or deployed.

## 10. Gunicorn Migration and Verification

### 10.1 Why Gunicorn Was Introduced

The earlier container used Flask's built-in development server.
This was replaced with Gunicorn, a production-oriented WSGI server,
to serve the Flask application.

### 10.2 Dependency Update

The following dependency was added to `requirements.txt`:

- Flask: 3.1.3
- Gunicorn: 23.0.0

### 10.3 Docker Startup Configuration

The Dockerfile now starts the application using:

`gunicorn --bind 0.0.0.0:5000 --workers 2 --threads 4 --timeout 30 application.app:app`

Configuration:

- Bind address: `0.0.0.0:5000`
- Workers: 2
- Threads per worker: 4
- Request timeout: 30 seconds
- WSGI application: `application.app:app`
- Runtime user: `appuser`

### 10.4 Updated Container

- Image: `cloudforge:1.2`
- Container: `cloudforge-app-v1.2`
- Host binding: `127.0.0.1:5001`
- Container port: `5000`
- Memory limit: 256 MB
- CPU limit: 1 CPU
- Process limit: 100
- Linux capabilities: All dropped
- No-new-privileges: Enabled
- Root filesystem: Read-only
- Temporary filesystem: `/tmp`, 64 MB, `noexec`, `nosuid`
- Restart policy: `no`

### 10.5 Application Verification

The following endpoints were tested through the new container:

| Endpoint | HTTP status | Result |
|---|---|---|
| `/` | 200 OK | Passed |
| `/health` | 200 OK | Passed |
| `/api/info` | 200 OK | Passed |

The health endpoint returned:

`{"status":"healthy"}`

The HTTP response identified Gunicorn as the server.
Docker reported the container health as `healthy`.

### 10.6 Updated GitHub Actions Verification

GitHub Actions workflow: `CloudForge CI`

- Run: #5
- Commit: `f622208`
- Branch: `main`
- Overall result: Success
- Total duration: 17 seconds

Verified steps:

- Repository checkout: Passed
- Python setup: Passed
- Dependency installation: Passed
- Python syntax check: Passed
- Dependency consistency check: Passed
- Automated tests: Passed
- Docker image build: Passed

A non-blocking Node.js 20 deprecation warning was displayed
for the existing GitHub Actions dependencies.

### 10.7 Cost and Infrastructure

The Gunicorn migration and container verification were performed
locally using Docker Desktop and WSL2.

GitHub Actions ran the CI workflow on GitHub-hosted infrastructure.

No AWS resources were created or deployed.
