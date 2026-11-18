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
